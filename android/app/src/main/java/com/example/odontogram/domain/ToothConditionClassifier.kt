package com.example.odontogram.domain

import android.graphics.Bitmap

interface ToothConditionClassifier {
    fun classify(bitmap: Bitmap, rotation: Int): List<Classification>
}