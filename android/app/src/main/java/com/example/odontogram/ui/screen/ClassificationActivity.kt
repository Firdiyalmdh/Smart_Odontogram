package com.example.odontogram.ui.screen

import android.Manifest.permission.CAMERA
import android.Manifest.permission.WRITE_EXTERNAL_STORAGE
import android.content.Context
import android.content.Intent
import android.graphics.Rect
import android.os.Build.VERSION.SDK_INT
import android.os.Build.VERSION_CODES.TIRAMISU
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.camera.core.ExperimentalGetImage
import androidx.camera.core.ImageCapture
import androidx.camera.core.ImageCaptureException
import androidx.camera.core.ImageProxy
import androidx.camera.view.CameraController.IMAGE_ANALYSIS
import androidx.camera.view.CameraController.IMAGE_CAPTURE
import androidx.camera.view.LifecycleCameraController
import androidx.camera.view.PreviewView
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.NativePaint
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.res.vectorResource
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.core.content.ContextCompat
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.repeatOnLifecycle
import com.example.odontogram.R
import com.example.odontogram.domain.entity.Detection
import com.example.odontogram.ui.screen.ClassificationViewModel.Event.OnNotFound
import com.example.odontogram.ui.screen.ClassificationViewModel.Event.OnResult
import com.example.odontogram.ui.theme.AndroidTheme
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.google.accompanist.permissions.rememberMultiplePermissionsState
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.flow.Flow
import kotlin.math.max

@AndroidEntryPoint
class ClassificationActivity : ComponentActivity() {
    @OptIn(ExperimentalPermissionsApi::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val patientId = intent.extras?.getString(ARG_PATIENT_ID).orEmpty()
        val quadrant = intent.extras?.getInt(ARG_QUADRANT) ?: 1

        setContent {
            AndroidTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    val permissions = rememberMultiplePermissionsState(
                        permissions =
                        if (SDK_INT >= TIRAMISU) listOf(CAMERA)
                        else listOf(CAMERA, WRITE_EXTERNAL_STORAGE)
                    )
                    if (permissions.allPermissionsGranted) {
                        CameraScreen(
                            patientId = patientId,
                            quadrant = quadrant,
                            onShowToast = ::showToast,
                            onSave = {
                                val replyIntent = Intent()
                                replyIntent.putExtra(ARG_RESULT, "Coba")
                                setResult(RESULT_OK, replyIntent)
                                finish()
                            }
                        )
                    } else {
                        LaunchedEffect(Unit) {
                            permissions.launchMultiplePermissionRequest()
                        }
                    }
                }
            }
        }
    }

    private fun showToast(message: String) {
        Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT).show()
    }

    companion object {
        const val ARG_RESULT = "result"
        const val ARG_PATIENT_ID = "patientId"
        const val ARG_QUADRANT = "quadrant"
    }
}

@androidx.annotation.OptIn(ExperimentalGetImage::class)
@Composable
fun CameraScreen(
    viewModel: ClassificationViewModel = hiltViewModel(),
    patientId: String,
    quadrant: Int,
    onShowToast: (String) -> Unit,
    onSave: () -> Unit
) = with(viewModel) {
    val context = LocalContext.current
    val config = LocalConfiguration.current

    val controller = remember {
        LifecycleCameraController(context).apply {
            setEnabledUseCases(IMAGE_ANALYSIS.or(IMAGE_CAPTURE))
            setImageAnalysisAnalyzer(
                ContextCompat.getMainExecutor(context),
                getToothTypeAnalyzer()
            )
        }
    }

    LaunchedEffect(Unit) {
        setPatientIdValue(patientId)
        setQuadrantValue(quadrant)
    }

    EventListener(flow = eventChannelFlow) {
        when (it) {
            is OnResult -> {
                onShowToast(it.type + it.condition)
            }

            is OnNotFound -> {
                onShowToast("Tidak terdeteksi!")
            }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
    ) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(config.screenWidthDp.dp)
        ) {
            CameraPreview(
                controller = controller,
                modifier = Modifier
                    .fillMaxSize()
            )

            OverlayView(
                detections = detections,
                previewHeight = config.screenWidthDp.dp,
                previewWidth = config.screenWidthDp.dp,
                modifier = Modifier
                    .fillMaxSize()
            )
        }

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
        ) {
            LazyRow(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
            ) {
                // TODO add list of odontogram result here
            }

            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
            ) {
                // OPEN GALLERY BUTTON
                IconButton(
                    onClick = { /*TODO OPEN GALLERY*/ }
                ) {
                    Icon(
                        imageVector = ImageVector.vectorResource(R.drawable.ic_folder_copy),
                        contentDescription = "open gallery"
                    )
                }

                // TAKE PICTURE BUTTON
                IconButton(
                    onClick = {
                        takePhoto(
                            context = context,
                            controller = controller,
                            onPhotoTaken = ::classify,
                            onError = onShowToast
                        )
                    },
                    enabled = detections.isNotEmpty(),
                    modifier = Modifier
                        .padding(8.dp)
                        .size(56.dp)
                        .clip(CircleShape),
                    colors = IconButtonDefaults.filledIconButtonColors(
                        containerColor = Color.White,
                        contentColor = Color.Gray,
                        disabledContainerColor = Color.LightGray,
                        disabledContentColor = Color.Red
                    )
                ) {
                    Icon(
                        imageVector = ImageVector.vectorResource(
                            if (detections.isNotEmpty()) R.drawable.ic_camera
                            else R.drawable.ic_camera_off
                        ),
                        contentDescription = "Take Picture"
                    )
                }

                IconButton(
                    onClick = { /*TODO SWITCH CAMERA*/ }
                ) {
                    Icon(
                        imageVector = ImageVector.vectorResource(R.drawable.ic_flip_camera),
                        contentDescription = "switch camera"
                    )
                }
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

@Composable
fun OverlayView(
    detections: List<Detection>,
    previewHeight: Dp,
    previewWidth: Dp,
    modifier: Modifier = Modifier,
) {
    val config = LocalConfiguration.current
    var scaleFactor by remember { mutableFloatStateOf(1f) }
    val paint = textPaint()
    val textList = detections.map { result ->
        val text = "${result.label} ${result.score}"
        Triple(text, textWidth(text, paint), textHeight(paint))
    }

//    LaunchedEffect(previewHeight, previewWidth) {
//        scaleFactor = max(config.screenWidthDp.dp * 1f / previewWidth, config.screenHeightDp.dp * 1f / previewHeight)
//    }

    Canvas(modifier = modifier.fillMaxSize()) {
        detections.forEachIndexed { index, result ->
            val boundingBox = result.boundingBox
            val (text, textWidth, textHeight) = textList[index]

            val top = (boundingBox.top.dp * scaleFactor).toPx()
            val bottom = (boundingBox.bottom.dp * scaleFactor).toPx()
            val left = (boundingBox.left.dp * scaleFactor).toPx()
            val right = (boundingBox.right.dp * scaleFactor).toPx()

            // Draw bounding box around detected objects
            drawRect(
                color = Color.Blue,
                topLeft = Offset(left, top),
                size = Size(right - left, bottom - top),
                style = Stroke(width = 8f)
            )

            // Draw background rect behind text
            drawRect(
                color = Color.Black,
                topLeft = Offset(left, top),
                size = Size(textWidth, textHeight),
            )

            // Draw text for detected object
            drawIntoCanvas { canvas ->
                canvas.nativeCanvas.drawText(
                    text,
                    left,
                    top + textHeight,
                    paint
                )
            }
        }
    }
}

@Composable
fun textPaint(): NativePaint {
    return Paint().asFrameworkPaint().apply {
        color = Color.White.hashCode()
        style = android.graphics.Paint.Style.FILL
        textSize = 50f
    }
}

@Composable
fun textWidth(text: String, paint: NativePaint): Float {
    val rect = Rect()
    paint.getTextBounds(text, 0, text.length, rect)
    return rect.width().toFloat()
}

@Composable
fun textHeight(paint: NativePaint): Float {
    val rect = Rect()
    paint.getTextBounds("H", 0, 1, rect)
    return rect.height().toFloat()
}

@Composable
fun <T : Any> EventListener(
    flow: Flow<T>,
    lifeCycleState: Lifecycle.State = Lifecycle.State.STARTED,
    collector: (T) -> Unit
) {
    val lifecycleOwner = LocalLifecycleOwner.current

    LaunchedEffect(flow) {
        lifecycleOwner.repeatOnLifecycle(lifeCycleState) {
            flow.collect(collector)
        }
    }
}

private fun takePhoto(
    context: Context,
    controller: LifecycleCameraController,
    onPhotoTaken: (ImageProxy) -> Unit,
    onError: (String) -> Unit
) {
    controller.takePicture(
        ContextCompat.getMainExecutor(context),
        object : ImageCapture.OnImageCapturedCallback() {
            override fun onCaptureSuccess(image: ImageProxy) {
                super.onCaptureSuccess(image)
                onPhotoTaken(image)
            }

            override fun onError(exception: ImageCaptureException) {
                super.onError(exception)
                Log.e("Camera", "Couldn't take photo: ", exception)
                onError(exception.localizedMessage.orEmpty())
            }
        }
    )
}