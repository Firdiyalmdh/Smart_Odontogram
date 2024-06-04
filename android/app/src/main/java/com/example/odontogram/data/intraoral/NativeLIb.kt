package com.example.odontogram.data.intraoral

import android.graphics.Bitmap


class NativeLib {
    private var mNativePtr = nativeCreateCamera()
    fun destroyCamera() {
        nativeDestroyCamera(mNativePtr)
        mNativePtr = 0L
    }

    fun startPreview() = nativeStartPreview(mNativePtr, ML_PORT_SERIES5, ML_PORT_SERIES3)
    fun stopPreview() = nativeStopPreview(mNativePtr)
    fun getOneFrameBuffer() = nativeGetFrameBuffer(mNativePtr)
    fun drawYUV2ARGB(bmp: Bitmap) = nativeYUV2ABGR(mNativePtr, bmp)
    fun getVideoFormat(obj: VideoParams) = nativeGetVideoFormat(mNativePtr, obj)

    fun getCmdRemoteKey() = nativeCmdGetRemoteKey()

    companion object {
        const val ML_PORT_SERIES3 = 8030
        const val ML_PORT_SERIES5 = 7060
        external fun nativeAVIRecStop()
        external fun nativeCmdGetRemoteKey(): Int
        private external fun nativeCreateCamera(): Long
        private external fun nativeDestroyCamera(j: Long)
        private external fun nativeGetFrameBuffer(j: Long): ByteArray?
        external fun nativeGetPassErrorBuf(): ByteArray?
        private external fun nativeStartPreview(j: Long, i: Int, i2: Int): Boolean
        private external fun nativeStopPreview(j: Long)
        private external fun nativeYUV2ABGR(j: Long, bitmap: Bitmap): Int

        private external fun nativeGetVideoFormat(j: Long, videoParams: VideoParams): Int

        init {
            System.loadLibrary("mlcamera-2.2")
        }
    }
}