package com.example.odontogram.domain

import android.graphics.Bitmap

interface ToothTypeDetector {
    fun detect(bitmap: Bitmap, rotation: Int): List<Detection>
}