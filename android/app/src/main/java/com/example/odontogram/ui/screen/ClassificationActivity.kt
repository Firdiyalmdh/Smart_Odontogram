package com.example.odontogram.ui.screen

import android.Manifest
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.camera.core.ExperimentalGetImage
import androidx.camera.view.CameraController
import androidx.camera.view.LifecycleCameraController
import androidx.camera.view.PreviewView
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.core.content.ContextCompat
import androidx.hilt.navigation.compose.hiltViewModel
import com.example.odontogram.data.TfLiteToothConditionClassifier
import com.example.odontogram.data.TfLiteToothTypeDetector
import com.example.odontogram.domain.Classification
import com.example.odontogram.domain.Detection
import com.example.odontogram.ui.theme.AndroidTheme
import com.example.odontogram.ui.util.ToothConditionAnalyzer
import com.example.odontogram.ui.util.ToothTypeAnalyzer
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.google.accompanist.permissions.rememberMultiplePermissionsState
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class ClassificationActivity : ComponentActivity() {
    @OptIn(ExperimentalPermissionsApi::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            AndroidTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val permissions = rememberMultiplePermissionsState(
                        permissions = listOf(
                            Manifest.permission.CAMERA
                        )
                    )
                    if (permissions.allPermissionsGranted) {
                        CameraScreen {
                            val replyIntent = Intent()
                            replyIntent.putExtra(RESULT, "Coba")
                            setResult(RESULT_OK, replyIntent)
                            finish()
                        }
                    } else {
                        LaunchedEffect(Unit) {
                            permissions.launchMultiplePermissionRequest()
                        }
                    }
                }
            }
        }
    }

    companion object {
        const val RESULT = "result"
    }
}

@androidx.annotation.OptIn(ExperimentalGetImage::class)
@Composable
fun CameraScreen(
    viewModel: ClassificationViewModel = hiltViewModel(),
    onClick: () -> Unit
) = with(viewModel) {
    val context = LocalContext.current
    var detections by remember {
        mutableStateOf(emptyList<Detection>())
    }
    var classifications by remember {
        mutableStateOf(emptyList<Classification>())
    }
//    val analyzer = remember {
//        ToothTypeAnalyzer(
//            detector = TfLiteToothTypeDetector(
//                context = context
//            ),
//            onResults = {
//                detections = it
//            }
//        )
//    }
    val analyzer = remember {
        ToothConditionAnalyzer(
            classifier = TfLiteToothConditionClassifier(
                context = context,
                maxResults = 1
            ),
            onResults = {
                classifications = it
            }
        )
    }
    val controller = remember {
        LifecycleCameraController(context).apply {
            setEnabledUseCases(CameraController.IMAGE_ANALYSIS)
            setImageAnalysisAnalyzer(
                ContextCompat.getMainExecutor(context),
                analyzer
            )
        }
    }
    Box(
        modifier = Modifier
            .fillMaxSize()
    ) {
        CameraPreview(controller, Modifier.fillMaxSize())

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.TopCenter)
        ) {
            classifications.forEach {
                Text(
                    text = "${it.name} - ${it.score}",
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(MaterialTheme.colorScheme.primaryContainer)
                        .padding(8.dp),
                    textAlign = TextAlign.Center,
                    fontSize = 20.sp,
                    color = MaterialTheme.colorScheme.primary
                )
            }
        }
    }
}

@Composable
fun CameraPreview(
    controller: LifecycleCameraController,
    modifier: Modifier = Modifier
) {
    val lifecycleOwner = LocalLifecycleOwner.current
    AndroidView(
        factory = {
            PreviewView(it).apply {
                this.controller = controller
                controller.bindToLifecycle(lifecycleOwner)
            }
        },
        modifier = modifier
    )
}