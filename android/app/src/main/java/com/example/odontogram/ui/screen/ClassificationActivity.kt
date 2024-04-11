package com.example.odontogram.ui.screen

import android.Manifest.permission.CAMERA
import android.Manifest.permission.WRITE_EXTERNAL_STORAGE
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Rect
import android.net.Uri
import android.os.Build.VERSION.SDK_INT
import android.os.Build.VERSION_CODES.TIRAMISU
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.OnBackPressedCallback
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.camera.core.AspectRatio.RATIO_4_3
import androidx.camera.core.ExperimentalGetImage
import androidx.camera.core.ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST
import androidx.camera.core.ImageCapture
import androidx.camera.core.ImageCaptureException
import androidx.camera.core.ImageProxy
import androidx.camera.view.CameraController.IMAGE_ANALYSIS
import androidx.camera.view.CameraController.IMAGE_CAPTURE
import androidx.camera.view.CameraController.OutputSize
import androidx.camera.view.LifecycleCameraController
import androidx.camera.view.PreviewView
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Button
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
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
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.res.vectorResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.compose.ui.window.Dialog
import androidx.core.content.ContextCompat
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.repeatOnLifecycle
import coil.compose.AsyncImage
import com.example.odontogram.R
import com.example.odontogram.domain.entity.Detection
import com.example.odontogram.domain.entity.Tooth
import com.example.odontogram.domain.entity.ToothCondition
import com.example.odontogram.domain.entity.ToothQuadrant
import com.example.odontogram.domain.entity.ToothType
import com.example.odontogram.domain.entity.isReverse
import com.example.odontogram.ui.screen.ClassificationViewModel.Event.OnError
import com.example.odontogram.ui.screen.ClassificationViewModel.Event.OnNotFound
import com.example.odontogram.ui.screen.ClassificationViewModel.Event.OnResult
import com.example.odontogram.ui.theme.AndroidTheme
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.google.accompanist.permissions.rememberMultiplePermissionsState
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.flow.Flow
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.FileNotFoundException
import java.io.InputStream
import kotlin.math.max

@AndroidEntryPoint
class ClassificationActivity : ComponentActivity() {
    @OptIn(ExperimentalPermissionsApi::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val patientId = intent.extras?.getString(ARG_PATIENT_ID).orEmpty()
        val quadrant = intent.extras?.getInt(ARG_QUADRANT) ?: 1

        onBackPressedDispatcher.addCallback(object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                val replyIntent = Intent()
                replyIntent.putExtra(ARG_RESULT, Json.encodeToString(emptyList<String>()))
                setResult(RESULT_OK, replyIntent)
                finish()
            }
        })

        setContent {
            AndroidTheme(
                darkTheme = false
            ) {
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
                            quadrantId = quadrant,
                            onShowToast = ::showToast,
                            onSaved = {
                                val replyIntent = Intent()
                                replyIntent.putExtra(ARG_RESULT, Json.encodeToString(it))
                                setResult(RESULT_OK, replyIntent)
                                finish()
                            },
                            onBackPressed = { onBackPressedDispatcher.onBackPressed() }
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

@OptIn(ExperimentalMaterial3Api::class)
@androidx.annotation.OptIn(ExperimentalGetImage::class)
@Composable
fun CameraScreen(
    viewModel: ClassificationViewModel = hiltViewModel(),
    patientId: String,
    quadrantId: Int,
    onShowToast: (String) -> Unit,
    onSaved: (List<Tooth>) -> Unit,
    onBackPressed: () -> Unit
) = with(viewModel) {
    val context = LocalContext.current
    var showSaveModal by remember { mutableStateOf(false) }
    var selectedTooth by remember { mutableStateOf<Tooth?>(null) }

    val controller = remember {
        LifecycleCameraController(context).apply {
            previewTargetSize = OutputSize(RATIO_4_3)
            imageAnalysisTargetSize = OutputSize(RATIO_4_3)
            imageAnalysisBackpressureStrategy = STRATEGY_KEEP_ONLY_LATEST
            setEnabledUseCases(IMAGE_ANALYSIS.or(IMAGE_CAPTURE))
            setImageAnalysisAnalyzer(
                ContextCompat.getMainExecutor(context),
                getToothTypeAnalyzer()
            )
        }
    }

    val imagePicker = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent(),
        onResult = { result ->
            result?.let { uri ->
                getBitmapFromUri(context, uri)?.let { detect(it) }
            }
        }
    )

    LaunchedEffect(Unit) {
        setPatientIdValue(patientId)
        setQuadrantValue(quadrantId)
    }

    EventListener(flow = eventChannelFlow) {
        when (it) {
            is OnResult -> { showSaveModal = true }

            is OnNotFound -> { onShowToast("Tidak terdeteksi!") }

            is OnError -> { onShowToast(it.message) }
        }
    }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = Color(0xff0D48A1),
                    titleContentColor = Color.White,
                    navigationIconContentColor = Color.White
                ),
                title = {
                    Text(
                        "Pemeriksaan Kuadran $quadrantId",
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(end = 16.dp)
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBackPressed) {
                        Icon(
                            imageVector = Icons.Filled.ArrowBack,
                            contentDescription = "Back"
                        )
                    }
                },
                actions = {
                    Button(onClick = {
                        onSaved(toothData.toMap().mapNotNull { it.value })
                    }) {
                        Text(text = "Simpan")
                    }
                },
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .padding(paddingValues)
                .background(Color.White)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(3 / 4f)
            ) {
                var previewSize by remember { mutableStateOf(IntSize(0, 0)) }

                CameraPreview(
                    controller = controller,
                    modifier = Modifier
                        .fillMaxSize()
                        .onGloballyPositioned { previewSize = it.size }
                )

                OverlayView(
                    detections = detections,
                    previewHeight = previewSize.height.pxToDp(),
                    previewWidth = previewSize.width.pxToDp(),
                    modifier = Modifier
                        .fillMaxSize()
                )
            }

            Column(
                verticalArrangement = Arrangement.Bottom,
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
            ) {
                LazyRow(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)
                ) {
                    items(toothData.toMap().keys.toList().reversed(quadrant)) {
                        val tooth = toothData[it]
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            verticalArrangement = Arrangement.spacedBy(8.dp),
                            modifier = Modifier.clickable {
                                if (tooth != null) selectedTooth = tooth
                                else onShowToast("Data masih kosong! isi data untuk gigi $it terlebih dahulu!")
                            }
                        ) {
                            AsyncImage(
                                model = tooth?.icon ?: R.drawable.tooth_empty,
                                contentDescription = "Tooth Icon",
                                modifier = Modifier.size(48.dp)
                            )
                            Text(text = it.toString())
                        }
                    }
                }

                Row(
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp)
                ) {
                    IconButton(
                        onClick = { imagePicker.launch("image/*") }
                    ) {
                        Icon(
                            imageVector = ImageVector.vectorResource(R.drawable.ic_folder_copy),
                            contentDescription = "open gallery",
                            tint = Color.LightGray
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
                            containerColor = Color.LightGray,
                            contentColor = Color.DarkGray,
                            disabledContainerColor = Color.DarkGray,
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
                            contentDescription = "switch camera",
                            tint = Color.LightGray
                        )
                    }
                }
            }
        }
    }

    if (showSaveModal) {
        DetailToothDialog(
            bitmap = toothImage,
            selectedToothType = type,
            selectedToothCondition = condition,
            onToothTypeSelected = ::setToothType,
            onToothConditionSelected = ::setToothCondition,
            onSave = ::saveResult,
            onDismiss = { showSaveModal = false }
        )
    }

    if (selectedTooth != null) {
        DetailToothDialog(
            imageUrl = selectedTooth?.imagePath,
            selectedToothType = selectedTooth?.type ?: ToothType.SERI_1,
            selectedToothCondition = selectedTooth?.condition ?: ToothCondition.NORMAL,
            onToothTypeSelected = { selectedTooth = selectedTooth?.copy(type = it) },
            onToothConditionSelected = { selectedTooth = selectedTooth?.copy(condition = it) },
            onSave = {
                selectedTooth?.id?.toInt()?.let { toothData[it] = selectedTooth }
            },
            onDismiss = { selectedTooth = null }
        )
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
    val imageSize = 320.pxToDp()
    var scaleFactor by remember { mutableFloatStateOf(1f) }
    val paint = textPaint()
    val textList = detections.map { result ->
        val text = "${result.label} ${result.score}"
        Triple(text, textWidth(text, paint), textHeight(paint))
    }

    LaunchedEffect(previewHeight, previewWidth) {
        scaleFactor = max(previewWidth * 1f / imageSize, previewHeight * 1f / imageSize)
    }

    Canvas(modifier = modifier.fillMaxSize()) {
        detections.forEachIndexed { index, result ->
            val boundingBox = result.boundingBox
            val (text, textWidth, textHeight) = textList[index]

            val top = boundingBox.top * scaleFactor
            val bottom = boundingBox.bottom * scaleFactor
            val left = boundingBox.left * scaleFactor
            val right = boundingBox.right * scaleFactor

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

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DetailToothDialog(
    bitmap: Bitmap? = null,
    imageUrl: String? = null,
    selectedToothType: ToothType,
    selectedToothCondition: ToothCondition,
    onToothTypeSelected: (ToothType) -> Unit,
    onToothConditionSelected: (ToothCondition) -> Unit,
    onSave: () -> Unit,
    onDismiss: () -> Unit
) {
    Dialog(onDismissRequest = onDismiss) {
        var isToothTypeExpanded by remember { mutableStateOf(false) }
        var isToothConditionExpanded by remember { mutableStateOf(false) }

        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth()
                .background(Color.White)
        ) {
            bitmap?.let {
                Image(bitmap = it.asImageBitmap(), contentDescription = null)
                Spacer(modifier = Modifier.height(16.dp))
            }

            imageUrl?.let {
                AsyncImage(model = it, contentDescription = null)
                Spacer(modifier = Modifier.height(16.dp))
            }

            ExposedDropdownMenuBox(
                expanded = isToothTypeExpanded,
                onExpandedChange = {
                    isToothTypeExpanded = !isToothTypeExpanded
                }
            ) {
                TextField(
                    value = selectedToothType.name,
                    onValueChange = {},
                    readOnly = true,
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = isToothTypeExpanded) },
                    modifier = Modifier.menuAnchor()
                )

                ExposedDropdownMenu(
                    expanded = isToothTypeExpanded,
                    onDismissRequest = { isToothTypeExpanded = false }
                ) {
                    ToothType.entries.forEach { toothType ->
                        DropdownMenuItem(
                            onClick = {
                                onToothTypeSelected(toothType)
                                isToothTypeExpanded = false
                            },
                            text = { Text(toothType.name) }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            ExposedDropdownMenuBox(
                expanded = isToothConditionExpanded,
                onExpandedChange = {
                    isToothConditionExpanded = !isToothConditionExpanded
                }
            ) {
                TextField(
                    value = selectedToothCondition.name,
                    onValueChange = {},
                    readOnly = true,
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = isToothConditionExpanded) },
                    modifier = Modifier.menuAnchor()
                )

                ExposedDropdownMenu(
                    expanded = isToothConditionExpanded,
                    onDismissRequest = { isToothConditionExpanded = false }
                ) {
                    ToothCondition.entries.forEach { condition ->
                        DropdownMenuItem(
                            onClick = {
                                onToothConditionSelected(condition)
                                isToothConditionExpanded = false
                            },
                            text = { Text(condition.name) }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = {
                    onDismiss()
                    onSave()
                }
            ) {
                Text("Save")
            }
        }
    }
}

@Composable
fun Int.pxToDp() = with(LocalDensity.current) { toDp() }

private fun takePhoto(
    context: Context,
    controller: LifecycleCameraController,
    onPhotoTaken: (Bitmap, Int) -> Unit,
    onError: (String) -> Unit
) {
    controller.takePicture(
        ContextCompat.getMainExecutor(context),
        object : ImageCapture.OnImageCapturedCallback() {
            override fun onCaptureSuccess(image: ImageProxy) {
                super.onCaptureSuccess(image)
                val orientation = image.imageInfo.rotationDegrees
                val bitmap = image.toBitmap()
                image.close()
                onPhotoTaken(bitmap, orientation)
            }

            override fun onError(exception: ImageCaptureException) {
                super.onError(exception)
                Log.e("Camera", "Couldn't take photo: ", exception)
                onError(exception.localizedMessage.orEmpty())
            }
        }
    )
}

fun getBitmapFromUri(context: Context, uri: Uri): Bitmap? {
    return try {
        val contentResolver: ContentResolver = context.contentResolver
        val inputStream: InputStream? = contentResolver.openInputStream(uri)
        BitmapFactory.decodeStream(inputStream)
    } catch (e: FileNotFoundException) {
        e.printStackTrace()
        null
    }
}

fun <T> List<T>.reversed(quadrant: ToothQuadrant): List<T> = if (quadrant.isReverse()) reversed() else this