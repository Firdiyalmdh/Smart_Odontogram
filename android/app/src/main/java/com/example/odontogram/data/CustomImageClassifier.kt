package com.example.odontogram.data

import android.content.Context
import android.util.Log
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.flex.FlexDelegate
import org.tensorflow.lite.support.image.TensorImage
import org.tensorflow.lite.support.label.Category
import java.io.FileInputStream
import java.io.IOException
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel

class CustomImageClassifier(
    context: Context,
    modelPath: String,
    labelPath: String,
    val options: Options
) {
    private val interpreter: Interpreter
    private val labels: MutableList<String> = mutableListOf()

    init {
        val delegate = FlexDelegate()
        options.baseOptions.addDelegate(delegate)
        interpreter = Interpreter(loadModelFile(context, modelPath), options.baseOptions)
        labels.addAll(readTextFile(context, labelPath))
    }

    @Throws(IOException::class)
    private fun loadModelFile(context: Context, modelPath: String): MappedByteBuffer {
        val fileDescriptor = context.assets.openFd(modelPath)
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel = inputStream.channel
        val startOffset = fileDescriptor.startOffset
        val declaredLength = fileDescriptor.declaredLength
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
    }

    fun classify(image: TensorImage): List<Category> {
        var inputTensorBuffer = image.tensorBuffer
        val inputShape = interpreter.getInputTensor(0).shape()
        val inputSize = inputShape[1] * inputShape[2] * inputShape[3] * inputShape[0]

        if (inputTensorBuffer.typeSize != inputSize) {
            val resizedImage = TensorImage(image.dataType)
            resizedImage.load(inputTensorBuffer)
            inputTensorBuffer = resizedImage.tensorBuffer
        }

        val outputTensor = Array(1) { FloatArray(NUM_CLASSES) }
        interpreter.run(inputTensorBuffer.buffer, outputTensor)
        return getTopKLabels(softmax(outputTensor[0]))
    }

    private fun getTopKLabels(probabilities: FloatArray): List<Category> {
        val categories = mutableListOf<Category>()
        Log.d("coba", "getTopKLabels: ${probabilities.asList()} $labels")
        for (i in probabilities.indices) {
            if (probabilities[i] >= options.scoreThreshold) categories.add(
                Category(labels.getOrElse(i) { "Tidak Diketahui" }, probabilities[i])
            )
        }
        categories.sortByDescending { it.score }
        return categories.take(options.maxResult)
    }

    private fun readTextFile(context: Context, fileName: String): List<String> {
        val inputStream = context.assets.open(fileName)
        val lines = mutableListOf<String>()
        inputStream.bufferedReader().useLines { lines.addAll(it) }
        inputStream.close()
        return lines
    }

    private fun softmax(logits: FloatArray): FloatArray {
        // Compute the sum of exponentials of the logits
        var sumOfExp = 0.0f
        for (logit in logits) {
            sumOfExp += Math.exp(logit.toDouble()).toFloat()
        }

        // Apply softmax to each logit
        val probabilities = FloatArray(logits.size)
        for (i in logits.indices) {
            probabilities[i] = Math.exp(logits[i].toDouble()).toFloat() / sumOfExp
        }

        return probabilities
    }

    class Options private constructor(
        val baseOptions: Interpreter.Options,
        val maxResult: Int,
        val scoreThreshold: Float
    ) {
        class Builder {
            private var baseOptions = Interpreter.Options()
            private var maxResult = 999
            private var scoreThreshold = 0.5f

            fun setMaxResult(maxResult: Int) = apply { this@Builder.maxResult = maxResult }
            fun setScoreThreshold(scoreThreshold: Float) = apply { this@Builder.scoreThreshold = scoreThreshold }
            fun setBaseOptions(baseOptions: Interpreter.Options) = apply { this@Builder.baseOptions = baseOptions }
            fun build() = Options(
                baseOptions = baseOptions,
                maxResult = maxResult,
                scoreThreshold = scoreThreshold
            )
        }

        companion object {
            fun builder() = Builder()
        }
    }

    companion object {
        private const val NUM_CLASSES = 5 // Change according to your model
    }
}