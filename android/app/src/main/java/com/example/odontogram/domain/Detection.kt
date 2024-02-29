package com.example.odontogram.domain

import androidx.compose.ui.geometry.Rect

data class Detection(
    val label: String,
    val score: Float,
    val boundingBox: Rect
)
