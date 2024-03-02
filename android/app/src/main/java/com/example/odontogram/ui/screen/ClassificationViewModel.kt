package com.example.odontogram.ui.screen

import androidx.camera.core.ImageProxy
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.odontogram.domain.entity.Detection
import com.example.odontogram.domain.service.ToothConditionClassifier
import com.example.odontogram.ui.util.ToothTypeAnalyzer
import com.example.odontogram.ui.util.centerCrop
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ClassificationViewModel @Inject constructor(
    private val toothTypeAnalyzer: ToothTypeAnalyzer,
    private val toothConditionClassifier: ToothConditionClassifier
) : ViewModel() {

    private var patientId by mutableStateOf("")
    private var quadrant by mutableIntStateOf(0)
    val detections = mutableStateListOf<Detection>()

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
        quadrant = value
    }

    fun getToothTypeAnalyzer() = toothTypeAnalyzer

    fun classify(image: ImageProxy) = viewModelScope.launch {
        val rotationDegrees = image.imageInfo.rotationDegrees
        val bitmap = image
            .toBitmap()
            .centerCrop(300, 300)

        val results = toothConditionClassifier.classify(bitmap, rotationDegrees)
        if (detections.isNotEmpty() && results.isNotEmpty()) {
            _eventChannel.send(Event.OnResult(detections.first().label, results.first().name))
        }
    }

    sealed interface Event {
        data class OnResult(val type: String, val condition: String) : Event
        data object OnNotFound : Event
    }
}