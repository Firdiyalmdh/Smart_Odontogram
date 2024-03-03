package com.example.odontogram.data

import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import android.view.Surface
import androidx.compose.ui.graphics.toComposeRect
import androidx.core.graphics.toRect
import com.example.odontogram.domain.entity.Detection
import com.example.odontogram.domain.service.ToothTypeDetector
import org.tensorflow.lite.gpu.CompatibilityList
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import org.tensorflow.lite.task.core.BaseOptions
import org.tensorflow.lite.task.core.vision.ImageProcessingOptions
import org.tensorflow.lite.task.vision.detector.ObjectDetector

class TfLiteToothTypeDetector(
    private val context: Context,
    private val threshold: Float = 0.25f,
    private val maxResults: Int = 3
) : ToothTypeDetector {

    private var detector: ObjectDetector? = null

    private fun setupDetector() {
        val baseOptionsBuilder = BaseOptions.builder()
            .setNumThreads(2)
        if (CompatibilityList().isDelegateSupportedOnThisDevice) {
            baseOptionsBuilder.useGpu()
        } else {
            baseOptionsBuilder.useNnapi()
        }

        val options = ObjectDetector.ObjectDetectorOptions.builder()
            .setBaseOptions(baseOptionsBuilder.build())
            .setMaxResults(maxResults)
            .setScoreThreshold(threshold)
            .build()

        try {
            detector = ObjectDetector.createFromFileAndOptions(
                context,
                "efficientdet.tflite",
                options
            )
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }
    }

    override fun detect(bitmap: Bitmap, rotation: Int): List<Detection> {
        if(detector == null) {
            setupDetector()
        }

        val imageProcessor = ImageProcessor.Builder()
            .add(ResizeOp(320, 320, ResizeOp.ResizeMethod.BILINEAR))
            .build()
        val tensorImage = imageProcessor.process(TensorImage.fromBitmap(bitmap))

        val imageProcessingOptions = ImageProcessingOptions.builder()
            .setOrientation(getOrientationFromRotation(rotation))
            .build()

        val results = detector?.detect(tensorImage, imageProcessingOptions)

        return results?.map {
            Detection(
                label = it.categories.first().label,
                score = it.categories.first().score,
                boundingBox = it.boundingBox.toRect()
            )
        }?.distinctBy { it.label } ?: emptyList()
    }

    private fun getOrientationFromRotation(rotation: Int): ImageProcessingOptions.Orientation {
        return when(rotation) {
            Surface.ROTATION_270 -> ImageProcessingOptions.Orientation.BOTTOM_RIGHT
            Surface.ROTATION_90 -> ImageProcessingOptions.Orientation.TOP_LEFT
            Surface.ROTATION_180 -> ImageProcessingOptions.Orientation.RIGHT_BOTTOM
            else -> ImageProcessingOptions.Orientation.RIGHT_TOP
        }
    }
}