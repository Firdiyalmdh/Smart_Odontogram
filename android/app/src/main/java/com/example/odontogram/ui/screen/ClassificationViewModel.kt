package com.example.odontogram.ui.screen

import android.graphics.Bitmap
import androidx.camera.core.ImageProxy
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.odontogram.domain.entity.Detection
import com.example.odontogram.domain.entity.Resource
import com.example.odontogram.domain.entity.Tooth
import com.example.odontogram.domain.entity.ToothCondition
import com.example.odontogram.domain.entity.ToothQuadrant
import com.example.odontogram.domain.entity.ToothType
import com.example.odontogram.domain.entity.getId
import com.example.odontogram.domain.entity.getIdList
import com.example.odontogram.domain.entity.toToothQuadrant
import com.example.odontogram.domain.repository.FirebaseRepository
import com.example.odontogram.domain.service.ToothConditionClassifier
import com.example.odontogram.ui.util.ToothTypeAnalyzer
import com.example.odontogram.ui.util.centerCrop
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ClassificationViewModel @Inject constructor(
    private val toothTypeAnalyzer: ToothTypeAnalyzer,
    private val toothConditionClassifier: ToothConditionClassifier,
    private val firebase: FirebaseRepository
) : ViewModel() {

    private var patientId by mutableStateOf("")
    private var quadrant by mutableStateOf(ToothQuadrant.QUADRANT_I)
    var condition by mutableStateOf(ToothCondition.NORMAL)
    private set
    var type by mutableStateOf(ToothType.SERI_1)
    private set
    var toothImage by mutableStateOf<Bitmap?>(null)
    private set
    val detections = mutableStateListOf<Detection>()
    val toothData = mutableStateMapOf<Int, Tooth?>()
    var isLoading by mutableStateOf(false)

    private val _eventChannel = Channel<Event>()
    val eventChannelFlow = _eventChannel.receiveAsFlow()

    init {
        toothTypeAnalyzer.setOnResult {
            detections.clear()
            detections.addAll(it)
        }
    }

    fun setPatientIdValue(id: String) {
        patientId = id
    }

    fun setQuadrantValue(value: Int) {
        quadrant = value.toToothQuadrant()
        quadrant.getIdList().forEach { toothData[it] = null }
    }

    fun setToothType(new: ToothType) {
        type = new
    }

    fun setToothCondition(new: ToothCondition) {
        condition = new
    }

    fun getToothTypeAnalyzer() = toothTypeAnalyzer

    fun classify(image: ImageProxy) = viewModelScope.launch {
        val rotationDegrees = image.imageInfo.rotationDegrees
        val bitmap = image.toBitmap()
        image.close()

        val results = toothConditionClassifier.classify(bitmap, rotationDegrees)
        if (detections.isNotEmpty() && results.isNotEmpty()) {
            condition = ToothCondition.valueOf(results.first().name.uppercase())
            type = ToothType.valueOf(detections.first().label.uppercase())
            toothImage = bitmap
            _eventChannel.send(Event.OnResult)
        } else {
            _eventChannel.send(Event.OnNotFound)
        }
    }

    fun saveResult() = viewModelScope.launch {
        toothImage?.let {
            firebase.uploadImage(patientId, it).collect { result ->
                when (result) {
                    is Resource.Loading -> isLoading = true
                    is Resource.Error -> {
                        isLoading = false
                        _eventChannel.send(Event.OnError(result.message.orEmpty()))
                    }
                    is Resource.Success -> {
                        val id = type.getId(quadrant)
                        toothData[id] = Tooth(
                            id = id.toString(),
                            type = type,
                            condition = condition,
                            imagePath = result.data.orEmpty()
                        )
                    }
                }
            }
        }
    }

    fun saveQuadrant() = viewModelScope.launch {
        firebase.saveMedicalExamResult(patientId, toothData.toMap().mapNotNull { it.value }).collect { result ->
            when (result) {
                is Resource.Loading -> isLoading = true
                is Resource.Error -> {
                    isLoading = false
                    _eventChannel.send(Event.OnError(result.message.orEmpty()))
                }
                is Resource.Success -> { _eventChannel.send(Event.OnSuccess) }
            }
        }
    }

    sealed interface Event {
        data object OnResult : Event
        data object OnNotFound : Event
        data class OnError(val message: String) : Event
        data object OnSuccess : Event
    }
}