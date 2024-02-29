package com.example.odontogram.data

import android.content.Context
import android.graphics.Bitmap
import android.view.Surface
import com.example.odontogram.domain.Classification
import com.example.odontogram.domain.ToothConditionClassifier
import org.tensorflow.lite.DataType
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.support.common.ops.CastOp
import org.tensorflow.lite.support.common.ops.NormalizeOp
import org.tensorflow.lite.support.image.ImageProcessor
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.image.ops.ResizeOp
import org.tensorflow.lite.task.core.vision.ImageProcessingOptions

class TfLiteToothConditionClassifier(
    private val context: Context,
    private val threshold: Float = 0.5f,
    private val maxResults: Int = 3
) : ToothConditionClassifier {

    private var classifier: CustomImageClassifier? = null

    private fun setupClassifier() {
        val baseOptions = Interpreter.Options()
            .setNumThreads(2)

        val options = CustomImageClassifier.Options.builder()
            .setBaseOptions(baseOptions)
            .setMaxResult(maxResults)
            .setScoreThreshold(threshold)
            .build()

        try {
            classifier = CustomImageClassifier(
                context,
                "efficientnet_metadata.tflite",
                "efficientnet.txt",
                options
            )
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }
    }

    override fun classify(bitmap: Bitmap, rotation: Int): List<Classification> {
        if (classifier == null) {
            setupClassifier()
        }

        val imageProcessor = ImageProcessor.Builder()
            .add(ResizeOp(300, 300, ResizeOp.ResizeMethod.BILINEAR))
            .add(NormalizeOp(0f, 1f))
            .add(CastOp(DataType.FLOAT32))
            .build()
        val tensorImage = imageProcessor.process(TensorImage.fromBitmap(bitmap))

        val imageProcessingOptions = ImageProcessingOptions.builder()
            .setOrientation(getOrientationFromRotation(rotation))
            .build()

        val results = classifier?.classify(tensorImage)

        return results?.map {
            Classification(
                name = it.label,
                score = it.score
            )
        }?.distinctBy { it.name } ?: emptyList()
    }

    private fun getOrientationFromRotation(rotation: Int): ImageProcessingOptions.Orientation {
        return when (rotation) {
            Surface.ROTATION_270 -> ImageProcessingOptions.Orientation.BOTTOM_RIGHT
            Surface.ROTATION_90 -> ImageProcessingOptions.Orientation.TOP_LEFT
            Surface.ROTATION_180 -> ImageProcessingOptions.Orientation.RIGHT_BOTTOM
            else -> ImageProcessingOptions.Orientation.RIGHT_TOP
        }
    }
}