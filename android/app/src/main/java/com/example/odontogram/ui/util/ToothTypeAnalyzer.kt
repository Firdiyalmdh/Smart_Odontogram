package com.example.odontogram.ui.util

import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import com.example.odontogram.domain.Detection
import com.example.odontogram.domain.ToothTypeDetector

class ToothTypeAnalyzer(
    private val detector: ToothTypeDetector,
    private val onResults: (List<Detection>) -> Unit
) : ImageAnalysis.Analyzer {
    private var frameSkipCounter = 0

    override fun analyze(image: ImageProxy) {
        if(frameSkipCounter % 60 == 0) {
            val rotationDegrees = image.imageInfo.rotationDegrees
            val bitmap = image
                .toBitmap()
                .centerCrop(321, 321)

            val results = detector.detect(bitmap, rotationDegrees)
            onResults(results)
        }
        frameSkipCounter++

        image.close()
    }
}