package com.example.odontogram.di

import android.content.Context
import com.example.odontogram.data.FirebaseRepositoryImpl
import com.example.odontogram.data.TfLiteToothConditionClassifier
import com.example.odontogram.data.TfLiteToothTypeDetector
import com.example.odontogram.domain.repository.FirebaseRepository
import com.example.odontogram.domain.service.ToothConditionClassifier
import com.example.odontogram.domain.service.ToothTypeDetector
import com.example.odontogram.ui.util.ToothTypeAnalyzer
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideToothTypeDetector(@ApplicationContext context: Context): ToothTypeDetector =
        TfLiteToothTypeDetector(
            context = context,
            threshold = 0.35f,
            maxResults = 1
        )

    @Provides
    @Singleton
    fun provideToothConditionClassifier(@ApplicationContext context: Context): ToothConditionClassifier =
        TfLiteToothConditionClassifier(
            context = context,
            threshold = 0.35f,
            maxResults = 1
        )

    @Provides
    @Singleton
    fun provideToothTypeAnalyzer(detector: ToothTypeDetector): ToothTypeAnalyzer = ToothTypeAnalyzer(detector)

    @Provides
    @Singleton
    fun provideFirebaseRepository(): FirebaseRepository = FirebaseRepositoryImpl()
}