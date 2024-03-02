package com.example.odontogram.domain.repository

import android.graphics.Bitmap
import com.example.odontogram.domain.entity.Resource
import com.example.odontogram.domain.entity.Tooth
import kotlinx.coroutines.flow.Flow

interface FirebaseRepository {
    fun uploadImage(bitmap: Bitmap): Flow<Resource<String>>
    fun saveMedicalExamResult(data: List<Tooth>): Flow<Resource<Boolean>>
}