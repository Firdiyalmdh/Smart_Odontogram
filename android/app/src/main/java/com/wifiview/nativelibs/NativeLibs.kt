package com.wifiview.nativelibs

import android.graphics.Bitmap
import com.wifiview.data.VideoParams
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class NativeLibs {
    private var nativePtr = 0L
    private val nativeMutex = Object()
    suspend fun destroyCamera() = callNativeFunction {
        nativeDestroyCamera(nativePtr)
        nativePtr = 0L
    }

    suspend fun startPreview() = callNativeFunction { nativeStartPreview(nativePtr, ML_PORT_SERIES5, ML_PORT_SERIES3) }
    suspend fun stopPreview() = callNativeFunction { nativeStopPreview(nativePtr) }
    suspend fun getOneFrameBuffer() = callNativeFunction { nativeGetFrameBuffer(nativePtr) }
    suspend fun drawYUV2ARGB(bmp: Bitmap) = callNativeFunction { nativeYUV2ABGR(nativePtr, bmp) }
    suspend fun getVideoFormat(obj: VideoParams) = callNativeFunction { nativeGetVideoFormat(nativePtr, obj) }

    suspend fun getCmdRemoteKey() = callNativeFunction { nativeCmdGetRemoteKey() }

    private fun initialize() {
        if (nativePtr != 0L) return
        nativePtr = nativeCreateCamera()
    }

    private suspend fun <T> callNativeFunction(
        dispatcher: CoroutineDispatcher = Dispatchers.Default,
        nativeFunction: () -> T
    ) = withContext(dispatcher) {
        synchronized(nativeMutex) {
            initialize()
            return@withContext nativeFunction()
        }
    }

    external fun nativeAVIRecStop()
    private external fun nativeCmdGetRemoteKey(): Int
    private external fun nativeCreateCamera(): Long
    private external fun nativeDestroyCamera(j: Long)
    private external fun nativeGetFrameBuffer(j: Long): ByteArray?
    external fun nativeGetPassErrorBuf(): ByteArray?
    private external fun nativeStartPreview(j: Long, i: Int, i2: Int): Boolean
    private external fun nativeStopPreview(j: Long)
    private external fun nativeYUV2ABGR(j: Long, bitmap: Bitmap): Int

    private external fun nativeGetVideoFormat(j: Long, videoParams: VideoParams): Int

    companion object {
        const val ML_PORT_SERIES3 = 8030
        const val ML_PORT_SERIES5 = 7060

        init {
            System.loadLibrary("mlcamera-2.2")
        }
    }
}