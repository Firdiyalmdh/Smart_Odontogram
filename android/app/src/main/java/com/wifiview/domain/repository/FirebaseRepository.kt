package com.wifiview.domain.repository

import android.graphics.Bitmap
import com.wifiview.domain.entity.Resource
import kotlinx.coroutines.flow.Flow

interface FirebaseRepository {
    suspend fun uploadImage(patientId: String, bitmap: Bitmap): Flow<Resource<String>>
}