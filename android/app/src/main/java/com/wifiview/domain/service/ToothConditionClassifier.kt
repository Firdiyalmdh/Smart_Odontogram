package com.wifiview.domain.service

import android.graphics.Bitmap
import com.wifiview.domain.entity.Classification

interface ToothConditionClassifier {
    fun classify(bitmap: Bitmap, rotation: Int): List<Classification>
}