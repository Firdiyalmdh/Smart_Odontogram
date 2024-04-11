package com.example.odontogram.data

import android.graphics.Bitmap
import com.example.odontogram.domain.entity.Resource
import com.example.odontogram.domain.repository.FirebaseRepository
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.FirebaseStorage
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.tasks.await
import java.io.ByteArrayOutputStream

class FirebaseRepositoryImpl : FirebaseRepository {

    private val db by lazy { FirebaseFirestore.getInstance() }
    private val storage by lazy { FirebaseStorage.getInstance() }

    override suspend fun uploadImage(patientId: String, bitmap: Bitmap) = flow {
        emit(Resource.Loading())
        try {
            val baos = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos)
            val data = baos.toByteArray()
            val ref = storage
                .getReference(MEDICAL_RECORD_COLLECTION)
                .child(patientId)
                .child(System.currentTimeMillis().toString())
            val downloadUrl = ref.putBytes(data).await().storage.downloadUrl.await().toString()
            emit(Resource.Success(downloadUrl))
        } catch (e: Exception) {
            emit(Resource.Error(e.localizedMessage ?: "Unknown Error"))
        }
    }

    companion object {
        const val PATIENT_COLLECTION = "patients"
        const val MEDICAL_RECORD_COLLECTION = "medical_records"
    }
}