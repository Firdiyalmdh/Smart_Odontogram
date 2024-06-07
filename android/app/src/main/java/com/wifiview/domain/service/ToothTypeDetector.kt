package com.wifiview.domain.service

import android.graphics.Bitmap
import com.wifiview.domain.entity.Detection

interface ToothTypeDetector {
    fun detect(bitmap: Bitmap, rotation: Int): List<Detection>
}