package com.wifiview.data

import android.graphics.Bitmap
import android.graphics.Bitmap.Config.ARGB_8888
import android.graphics.BitmapFactory
import android.util.Log
import com.wifiview.nativelibs.NativeLibs
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


class IntraOralCameraService(
    private val params: VideoParams = VideoParams(),
    private val nativeLib: NativeLibs = NativeLibs()
) {
    private var isRunning = false

    fun startStream(): Flow<Bitmap> = flow {
        if (!isRunning) {
            isRunning = true
            try {
                nativeLib.startPreview()
                val videoFormatFlow = flow {
                    do {
                        val format = nativeLib.getVideoFormat(params)
                        params.video_format = format
                        emit(format)
                        delay(100)
                    } while (params.video_format <= 0 && isRunning)
                }

                videoFormatFlow
                    .filter { it > 0 }
                    .firstOrNull()?.let {
                        if (params.video_format == 4) handleYUV()
                        else handleJPEG()
                    }
            } finally {
                nativeLib.stopPreview()
                isRunning = false
            }
        }
    }

    private fun handleYUV(): Flow<Bitmap> = flow {
        Log.d("coba", "create a bitmap size:" + params.video_width + "x" + params.video_height)
        val bmpBitmap = Bitmap.createBitmap(params.video_width, params.video_height, ARGB_8888)
        try {
            while (isRunning) {
                val ret: Int = nativeLib.drawYUV2ARGB(bmpBitmap)
                when {
                    ret <= 0 -> delay(5)
                    ret <= 5575 -> {
                        val passErrorBuf: ByteArray? = nativeLib.nativeGetPassErrorBuf()
                        val passErrorBmp = BitmapFactory.decodeByteArray(passErrorBuf, 0, passErrorBuf?.size ?: 0)
                        emit(passErrorBmp)
                        delay(5)
                    }

                    else -> {
                        val bitmap = bmpBitmap.copy(ARGB_8888, false)
                        emit(bitmap)
                    }
                }
            }
        } finally {
            bmpBitmap.recycle()
        }
    }

    private fun handleJPEG(): Flow<Bitmap> = flow {
        var bmpBitmap: Bitmap? = null
        try {
            while (isRunning) {
                val data: ByteArray? = nativeLib.getOneFrameBuffer()
                if (data == null) delay(5)
                else {
                    bmpBitmap = BitmapFactory.decodeByteArray(data, 0, data.size)
                    if (bmpBitmap != null) {
                        emit(bmpBitmap.copy(ARGB_8888, false))
                    }
                }
            }
        } finally {
            bmpBitmap?.recycle()
        }
    }

    suspend fun destroy() {
        isRunning = false
        nativeLib.nativeAVIRecStop()
        nativeLib.destroyCamera()
    }

    fun listenKeyAction(
        onCaptureImage: suspend () -> Unit
    ) = CoroutineScope(Dispatchers.IO).launch {
        while (isRunning) {
            val key = nativeLib.getCmdRemoteKey()
            withContext(Dispatchers.Main) {
                if (key in setOf(1, 2)) onCaptureImage()
            }
        }
    }
}

class VideoParams {
    var video_format = 0
    var video_height = 0
    var video_width = 0
    var stream_pass_ok = 0
}