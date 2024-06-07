package com.wifiview.domain.entity

import android.graphics.Rect

data class Detection(
    val label: String,
    val score: Float,
    val boundingBox: Rect
)
