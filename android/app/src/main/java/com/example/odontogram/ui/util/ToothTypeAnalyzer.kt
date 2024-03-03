package com.example.odontogram.ui.util

import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import com.example.odontogram.domain.entity.Detection
import com.example.odontogram.domain.service.ToothTypeDetector
import javax.inject.Inject

class ToothTypeAnalyzer @Inject constructor(
    private val detector: ToothTypeDetector
) : ImageAnalysis.Analyzer {
    private var frameSkipCounter = 0
    private var onResults: ((List<Detection>) -> Unit)? = null

    fun setOnResult(onResults: (List<Detection>) -> Unit) {
        this.onResults = onResults
    }

    override fun analyze(image: ImageProxy) {
        if(frameSkipCounter % 60 == 0) {
            val rotationDegrees = image.imageInfo.rotationDegrees
            val bitmap = image.toBitmap()

            val results = detector.detect(bitmap, rotationDegrees)
            onResults?.invoke(results)
        }
        frameSkipCounter++

        image.close()
    }
}