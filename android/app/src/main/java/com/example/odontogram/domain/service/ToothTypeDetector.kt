package com.example.odontogram.domain.service

import android.graphics.Bitmap
import com.example.odontogram.domain.entity.Detection

interface ToothTypeDetector {
    fun detect(bitmap: Bitmap, rotation: Int): List<Detection>
}