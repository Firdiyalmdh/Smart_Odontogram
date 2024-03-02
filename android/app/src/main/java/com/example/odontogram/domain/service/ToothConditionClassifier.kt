package com.example.odontogram.domain.service

import android.graphics.Bitmap
import com.example.odontogram.domain.entity.Classification

interface ToothConditionClassifier {
    fun classify(bitmap: Bitmap, rotation: Int): List<Classification>
}