package com.wifiview.di

import android.content.Context
import com.wifiview.data.FirebaseRepositoryImpl
import com.wifiview.data.IntraOralCameraService
import com.wifiview.data.TfLiteToothConditionClassifier
import com.wifiview.data.TfLiteToothTypeDetector
import com.wifiview.data.VideoParams
import com.wifiview.domain.repository.FirebaseRepository
import com.wifiview.domain.service.ToothConditionClassifier
import com.wifiview.domain.service.ToothTypeDetector
import com.wifiview.nativelibs.NativeLibs
import com.wifiview.ui.util.ToothTypeAnalyzer
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
    fun provideNativeLib(): NativeLibs = NativeLibs()

    @Provides
    @Singleton
    fun provideVideoParam(): VideoParams = VideoParams()


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
    fun provideIntraOralCameraService(
        videoParams: VideoParams,
        nativeLib: NativeLibs
    ): IntraOralCameraService = IntraOralCameraService(
        params = videoParams,
        nativeLib = nativeLib
    )

    @Provides
    @Singleton
    fun provideFirebaseRepository(): FirebaseRepository = FirebaseRepositoryImpl()
}