package com.wifiview.ui.screen

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
import com.wifiview.data.IntraOralCameraService
import com.wifiview.domain.entity.Detection
import com.wifiview.domain.entity.Resource
import com.wifiview.domain.entity.Tooth
import com.wifiview.domain.entity.ToothCondition
import com.wifiview.domain.entity.ToothQuadrant
import com.wifiview.domain.entity.ToothType
import com.wifiview.domain.entity.getId
import com.wifiview.domain.entity.getIdList
import com.wifiview.domain.entity.toToothQuadrant
import com.wifiview.domain.repository.FirebaseRepository
import com.wifiview.domain.service.ToothConditionClassifier
import com.wifiview.domain.service.ToothTypeDetector
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ClassificationViewModel @Inject constructor(
    private val intraOralCameraService: IntraOralCameraService,
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
    var streamImage by mutableStateOf<Bitmap?>(null)
        private set
    val detections = mutableStateListOf<Detection>()
    val toothData = mutableStateMapOf<Int, Tooth?>()
    var isLoading by mutableStateOf(false)

    private val _eventChannel = Channel<Event>()
    val eventChannelFlow = _eventChannel.receiveAsFlow()

    init {
        viewModelScope.launch {
            intraOralCameraService.startStream().collect {
                streamImage = it
            }
            intraOralCameraService.listenKeyAction {
                _eventChannel.send(Event.OnCaptureImage)
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        viewModelScope.launch {
            intraOralCameraService.destroy()
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

    private fun classify() = viewModelScope.launch {
        try {
            if (streamImage == null) throw Exception()
            val results = toothConditionClassifier.classify(
                streamImage!!.crop(detections.first().boundingBox),
                0
            )

            if (results.isEmpty()) throw Exception()
            condition = ToothCondition.valueOf(results.first().name.uppercase())
            type = ToothType.valueOf(detections.first().label.uppercase())
            toothImage = streamImage
            _eventChannel.send(Event.OnResult)
        } catch (e: Exception) {
            _eventChannel.send(Event.OnNotFound)
        }
    }

    fun detect(bitmap: Bitmap? = null) = viewModelScope.launch {
        try {
            val results = toothTypeDetector.detect(bitmap ?: streamImage!!, 0)
            if (results.isEmpty()) throw Exception()
            detections.addAll(results)
            classify()
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
        data object OnCaptureImage : Event
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