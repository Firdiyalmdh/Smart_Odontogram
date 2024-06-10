package com.example.odontogram.ui.screen

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Rect
import androidx.compose.runtime.getValue
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
import com.example.odontogram.domain.service.ToothTypeDetector
import com.example.odontogram.ui.util.ToothTypeAnalyzer
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ClassificationViewModel @Inject constructor(
    private val toothTypeAnalyzer: ToothTypeAnalyzer,
    private val toothConditionClassifier: ToothConditionClassifier,
    private val toothTypeDetector: ToothTypeDetector,
    private val firebase: FirebaseRepository
) : ViewModel() {

    private var patientId by mutableStateOf("")
    var quadrant by mutableStateOf(ToothQuadrant.QUADRANT_I)
        private set
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
//        quadrant.getIdList().forEachIndexed { index, id ->
//            toothData[id] = dummyData[index].copy(id = id.toString())
//        }
    }

    fun setToothType(new: ToothType) {
        type = new
    }

    fun setToothCondition(new: ToothCondition) {
        condition = new
    }

    fun getToothTypeAnalyzer() = toothTypeAnalyzer

    fun classify(bitmap: Bitmap, rotationDegrees: Int) = viewModelScope.launch {
        try {
            val croppedBitmap =
                if (detections.isNotEmpty()) bitmap.crop(detections.first().boundingBox)
                else bitmap
            val results = toothConditionClassifier.classify(
                croppedBitmap,
                rotationDegrees
            )

            condition =
                if (results.isNotEmpty()) ToothCondition.valueOf(results.first().name.uppercase())
                else ToothCondition.NORMAL
            type =
                if (detections.isNotEmpty()) ToothType.valueOf(detections.first().label.uppercase())
                else ToothType.SERI_1
            toothImage = bitmap
            _eventChannel.send(Event.OnResult)
        } catch (e: Exception) {
            _eventChannel.send(Event.OnNotFound)
        }
    }

    fun detect(bitmap: Bitmap) = viewModelScope.launch {
        try {
            val results = toothTypeDetector.detect(bitmap, 0)
            if (results.isNotEmpty()) detections.addAll(results)
            classify(bitmap, 0)
        } catch (e: Exception) {
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

    private fun Bitmap.crop(rect: Rect): Bitmap {
        val croppedBitmap = Bitmap.createBitmap(rect.width(), rect.height(), Bitmap.Config.ARGB_8888)
        val canvas = Canvas(croppedBitmap)
        val destRect = Rect(0, 0, rect.width(), rect.height())
        canvas.drawBitmap(this, rect, destRect, null)
        return croppedBitmap
    }

    sealed interface Event {
        data object OnResult : Event
        data object OnNotFound : Event
        data class OnError(val message: String) : Event
    }

    private val dummyData = listOf(
        Tooth("1", ToothType.SERI_1, ToothCondition.NORMAL, "https://firebasestorage.googleapis.com/v0/b/smart-odontogram.appspot.com/o/medical_records%2F8NW3AJSaD5dzAmKqTM6O%2F1712213261646?alt=media&token=07fabec6-920c-463a-b03e-fa9d7aab6368"),
        Tooth("2", ToothType.SERI_2, ToothCondition.KARIES, "https://firebasestorage.googleapis.com/v0/b/smart-odontogram.appspot.com/o/medical_records%2F8NW3AJSaD5dzAmKqTM6O%2F1712213261646?alt=media&token=07fabec6-920c-463a-b03e-fa9d7aab6368"),
        Tooth("3", ToothType.TARING, ToothCondition.TUMPATAN, "https://firebasestorage.googleapis.com/v0/b/smart-odontogram.appspot.com/o/medical_records%2F8NW3AJSaD5dzAmKqTM6O%2F1712213261646?alt=media&token=07fabec6-920c-463a-b03e-fa9d7aab6368"),
        Tooth("4", ToothType.PREMOLAR_1, ToothCondition.SISA_AKAR, "https://firebasestorage.googleapis.com/v0/b/smart-odontogram.appspot.com/o/medical_records%2F8NW3AJSaD5dzAmKqTM6O%2F1712213261646?alt=media&token=07fabec6-920c-463a-b03e-fa9d7aab6368"),
        Tooth("5", ToothType.PREMOLAR_2, ToothCondition.NORMAL, "https://firebasestorage.googleapis.com/v0/b/smart-odontogram.appspot.com/o/medical_records%2F8NW3AJSaD5dzAmKqTM6O%2F1712213261646?alt=media&token=07fabec6-920c-463a-b03e-fa9d7aab6368"),
        Tooth("6", ToothType.MOLAR_1, ToothCondition.KARIES, "https://firebasestorage.googleapis.com/v0/b/smart-odontogram.appspot.com/o/medical_records%2F8NW3AJSaD5dzAmKqTM6O%2F1712213261646?alt=media&token=07fabec6-920c-463a-b03e-fa9d7aab6368"),
        Tooth("7", ToothType.MOLAR_2, ToothCondition.TUMPATAN, "https://firebasestorage.googleapis.com/v0/b/smart-odontogram.appspot.com/o/medical_records%2F8NW3AJSaD5dzAmKqTM6O%2F1712213261646?alt=media&token=07fabec6-920c-463a-b03e-fa9d7aab6368"),
        Tooth("8", ToothType.MOLAR_3, ToothCondition.SISA_AKAR, "https://firebasestorage.googleapis.com/v0/b/smart-odontogram.appspot.com/o/medical_records%2F8NW3AJSaD5dzAmKqTM6O%2F1712213261646?alt=media&token=07fabec6-920c-463a-b03e-fa9d7aab6368")
    )
}