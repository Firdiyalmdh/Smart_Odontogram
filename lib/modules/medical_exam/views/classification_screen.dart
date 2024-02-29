import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/recognition.dart';
import 'package:odontogram/modules/medical_exam/controllers/classification_controller.dart';

class ClassificationScreen extends GetView<ClassificationController> {
  const ClassificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Container();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text(
    //       "Pemeriksaan Baru",
    //       style: TextStyle(
    //         color: Colors.white,
    //       ),
    //     ),
    //     iconTheme: const IconThemeData(
    //       color: Colors.white,
    //     ),
    //     backgroundColor: Colors.blue[900],
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           controller.save();
    //         },
    //         child: const Text(
    //           "Simpan",
    //           style: TextStyle(color: Colors.white),
    //         ),
    //       ),
    //     ],
    //   ),
    //   body: const BottomNavigationBarApp(),
    //   // body: const DetectorWidget(),
    //   // body: Column(
    //   //   children: [
    //   //     CameraViewerSection(),
    //   //     OdontogramListSection(),
    //   //     ActionSection()
    //   //   ],
    //   // ),
    // );
  }
}

// class CameraViewerSection extends StatelessWidget {
//   final ClassificationController controller = Get.find();
//   CameraViewerSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetX<ClassificationController>(
//       builder: (controller) {
//         if (!controller.isInitialized) {
//           return Container();
//         } else if (controller.image.isNotEmpty) {
//           return SizedBox(
//             height: Get.height - 300,
//             width: Get.width,
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: MemoryImage(controller.image),
//                 ),
//               ),
//             ),
//           );
//         }
//         return SizedBox(
//           height: Get.height - 300,
//           width: Get.width,
//           child: CameraPreview(controller.cameraController),
//         );
//       },
//     );
//   }
// }

// class ActionSection extends StatelessWidget {
//   final ClassificationController controller = Get.find();
//   ActionSection({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Obx(
//           () => Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.asset(
//               controller.quadrant.value.icon,
//               width: 50,
//               height: 50,
//             ),
//           ),
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: () => controller.capture(),
//           child: Container(
//             height: 100,
//             width: 100,
//             padding: const EdgeInsets.all(5),
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.transparent,
//                 border: Border.all(color: Colors.white, width: 5)),
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.camera,
//                   size: 60,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const Spacer(),
//         Obx(
//           () => Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: (controller.image.isNotEmpty)
//                 ? IconButton(
//                     icon: const Icon(Icons.delete),
//                     iconSize: 32,
//                     style: IconButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                         foregroundColor: Colors.white),
//                     onPressed: () {
//                       controller.resetImage();
//                     },
//                   )
//                 : IconButton(
//                     icon: const Icon(Icons.drive_folder_upload),
//                     iconSize: 32,
//                     style:
//                         IconButton.styleFrom(backgroundColor: Colors.white70),
//                     onPressed: () {
//                       controller.pickImageFromGallery();
//                     },
//                   ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class OdontogramListSection extends StatelessWidget {
//   final ClassificationController controller = Get.find();
//   OdontogramListSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Obx(
//           () => Row(
//             children: controller.result.entries
//                 .map(
//                   (entry) => ToothItem(
//                     id: entry.key,
//                     data: entry.value,
//                     onTap: () {
//                       Get.dialog(
//                         ConditionModal(
//                           selectedValue: entry.value?.condition.obs ??
//                               ToothCondition.NORMAL.obs,
//                           onClose: (selectedCondition) {
//                             controller.editResult(
//                                 entry.key,
//                                 Tooth(
//                                     id: entry.key.toString(),
//                                     type: entry.key.toothType,
//                                     condition: selectedCondition));
//                             Get.back();
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 )
//                 .toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ConditionModal extends StatelessWidget {
//   final ClassificationController controller = Get.find();
//   final Rx<ToothCondition> selectedValue;
//   final void Function(ToothCondition) onClose;

//   ConditionModal({
//     super.key,
//     required this.selectedValue,
//     required this.onClose,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: PopScope(
//         child: Container(
//           height: 200,
//           margin: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Kondisi Gigi"),
//               ),
//               const SizedBox(height: 5),
//               InputDecorator(
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(vertical: 2.0),
//                 ),
//                 child: Obx(
//                   () => DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 2, horizontal: 10),
//                       value: selectedValue.value,
//                       items: ToothCondition.values
//                           .map(
//                             (condition) => DropdownMenuItem(
//                               value: condition,
//                               child: Text(
//                                 condition.name,
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (value) {
//                         selectedValue.value = value!;
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   onPressed: () => onClose(selectedValue.value),
//                   child: const Text("Simpan"),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Individual bounding box
// class BoxWidget extends StatelessWidget {
//   final Recognition result;

//   const BoxWidget({super.key, required this.result});

//   @override
//   Widget build(BuildContext context) {
//     // Color for bounding box
//     Color color = Colors.primaries[
//         (result.label.length + result.label.codeUnitAt(0) + result.id) %
//             Colors.primaries.length];

//     return Positioned(
//       left: result.renderLocation.left,
//       top: result.renderLocation.top,
//       width: result.renderLocation.width,
//       height: result.renderLocation.height,
//       child: Container(
//         width: result.renderLocation.width,
//         height: result.renderLocation.height,
//         decoration: BoxDecoration(
//             border: Border.all(color: color, width: 3),
//             borderRadius: const BorderRadius.all(Radius.circular(2))),
//         child: Align(
//           alignment: Alignment.topLeft,
//           child: FittedBox(
//             child: Container(
//               color: color,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(result.label),
//                   Text(" ${result.score.toStringAsFixed(2)}"),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Row for one Stats field
// class StatsWidget extends StatelessWidget {
//   final String left;
//   final String right;

//   const StatsWidget(this.left, this.right, {super.key});

//   @override
//   Widget build(BuildContext context) => Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [Text(left), Text(right)],
//         ),
//       );
// }

// /// [DetectorWidget] sends each frame for inference
// class DetectorWidget extends StatefulWidget {
//   /// Constructor
//   const DetectorWidget({super.key});

//   @override
//   State<DetectorWidget> createState() => _DetectorWidgetState();
// }

// class _DetectorWidgetState extends State<DetectorWidget>
//     with WidgetsBindingObserver {
//   /// List of available cameras
//   late List<CameraDescription> cameras;

//   /// Controller
//   CameraController? _cameraController;

//   // use only when initialized, so - not null
//   get _controller => _cameraController;

//   /// Object Detector is running on a background [Isolate]. This is nullable
//   /// because acquiring a [LiveDetectorService] is an asynchronous operation. This
//   /// value is `null` until the detector is initialized.
//   LiveDetectorService? _detector;
//   StreamSubscription? _subscription;

//   /// Results to draw bounding boxes
//   List<Recognition>? results;

//   /// Realtime stats
//   Map<String, String>? stats;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initStateAsync();
//   }

//   void _initStateAsync() async {
//     // initialize preview and CameraImage stream
//     _initializeCamera();
//     // Spawn a new isolate
//     LiveDetectorService.start().then((instance) {
//       setState(() {
//         _detector = instance;
//         _subscription = instance.resultsStream.stream.listen((values) {
//           setState(() {
//             results = values['recognitions'];
//             stats = values['stats'];
//           });
//         });
//       });
//     });
//   }

//   /// Initializes the camera by setting [_cameraController]
//   void _initializeCamera() async {
//     cameras = await availableCameras();
//     // cameras[0] for back-camera
//     _cameraController = CameraController(
//       cameras[0],
//       ResolutionPreset.medium,
//       enableAudio: false,
//     )..initialize().then((_) async {
//         await _controller.startImageStream(onLatestImageAvailable);
//         setState(() {});
//         ScreenParams.previewSize = _controller.value.previewSize!;
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Return empty container while the camera is not initialized
//     if (_cameraController == null || !_controller.value.isInitialized) {
//       return const SizedBox.shrink();
//     }

//     var aspect = 1 / _controller.value.aspectRatio;

//     return Stack(
//       children: [
//         AspectRatio(
//           aspectRatio: aspect,
//           child: CameraPreview(_controller),
//         ),
//         // Stats
//         _statsWidget(),
//         // Bounding boxes
//         AspectRatio(
//           aspectRatio: aspect,
//           child: _boundingBoxes(),
//         ),
//       ],
//     );
//   }

//   Widget _statsWidget() => (stats != null)
//       ? Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             color: Colors.white.withAlpha(150),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: stats!.entries
//                     .map((e) => StatsWidget(e.key, e.value))
//                     .toList(),
//               ),
//             ),
//           ),
//         )
//       : const SizedBox.shrink();

//   /// Returns Stack of bounding boxes
//   Widget _boundingBoxes() {
//     if (results == null) {
//       return const SizedBox.shrink();
//     }
//     return Stack(
//         children: results!.map((box) => BoxWidget(result: box)).toList());
//   }

//   /// Callback to receive each frame [CameraImage] perform inference on it
//   void onLatestImageAvailable(CameraImage cameraImage) async {
//     _detector?.processFrame(cameraImage);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     switch (state) {
//       case AppLifecycleState.inactive:
//         _cameraController?.stopImageStream();
//         _detector?.stop();
//         _subscription?.cancel();
//         break;
//       case AppLifecycleState.resumed:
//         _initStateAsync();
//         break;
//       default:
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _cameraController?.dispose();
//     _detector?.stop();
//     _subscription?.cancel();
//     super.dispose();
//   }
// }

// class BottomNavigationBarApp extends StatelessWidget {
//   const BottomNavigationBarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: BottomNavigationBarExample(),
//     );
//   }
// }

// class BottomNavigationBarExample extends StatefulWidget {
//   const BottomNavigationBarExample({super.key});

//   @override
//   State<BottomNavigationBarExample> createState() =>
//       _BottomNavigationBarExampleState();
// }

// class _BottomNavigationBarExampleState
//     extends State<BottomNavigationBarExample> {
//   late CameraDescription cameraDescription;
//   int _selectedIndex = 0;
//   List<Widget>? _widgetOptions;

//   bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       initPages();
//     });
//   }

//   initPages() async {
//     _widgetOptions = [const GalleryScreen()];

//     if (cameraIsAvailable) {
//       // get list available camera
//       cameraDescription = (await availableCameras()).first;
//       _widgetOptions!.add(CameraScreen(camera: cameraDescription));
//     }

//     setState(() {});
//   }

//   void _onItemTapped(int index) {
//     if (!cameraIsAvailable) {
//       debugPrint("This is not supported on your current platform");
//       return;
//     }
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions?.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.image),
//             label: 'Gallery screen',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.camera),
//             label: 'Live Camera',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({
//     super.key,
//     required this.camera,
//   });

//   final CameraDescription camera;

//   @override
//   State<StatefulWidget> createState() => CameraScreenState();
// }

// class CameraScreenState extends State<CameraScreen>
//     with WidgetsBindingObserver {
//   late CameraController cameraController;
//   late ImageClassificationHelper imageClassificationHelper;
//   Map<String, double>? classification;
//   bool _isProcessing = false;

//   // init camera
//   initCamera() {
//     cameraController = CameraController(widget.camera, ResolutionPreset.medium,
//         imageFormatGroup: Platform.isIOS
//             ? ImageFormatGroup.bgra8888
//             : ImageFormatGroup.yuv420);
//     cameraController.initialize().then((value) {
//       cameraController.startImageStream(imageAnalysis);
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }

//   Future<void> imageAnalysis(CameraImage cameraImage) async {
//     // if image is still analyze, skip this frame
//     if (_isProcessing) {
//       return;
//     }
//     _isProcessing = true;
//     classification =
//         await imageClassificationHelper.inferenceCameraFrame(cameraImage);
//     _isProcessing = false;
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     initCamera();
//     imageClassificationHelper = ImageClassificationHelper();
//     imageClassificationHelper.initHelper();
//     super.initState();
//   }

//   @override
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     switch (state) {
//       case AppLifecycleState.paused:
//         cameraController.stopImageStream();
//         break;
//       case AppLifecycleState.resumed:
//         if (!cameraController.value.isStreamingImages) {
//           await cameraController.startImageStream(imageAnalysis);
//         }
//         break;
//       default:
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     cameraController.dispose();
//     imageClassificationHelper.close();
//     super.dispose();
//   }

//   Widget cameraWidget(context) {
//     var camera = cameraController.value;
//     // fetch screen size
//     final size = MediaQuery.of(context).size;

//     // calculate scale depending on screen and camera ratios
//     // this is actually size.aspectRatio / (1 / camera.aspectRatio)
//     // because camera preview size is received as landscape
//     // but we're calculating for portrait orientation
//     var scale = size.aspectRatio * camera.aspectRatio;

//     // to prevent scaling down, invert the value
//     if (scale < 1) scale = 1 / scale;

//     return Transform.scale(
//       scale: scale,
//       child: Center(
//         child: CameraPreview(cameraController),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Size size = MediaQuery.of(context).size;
//     List<Widget> list = [];

//     list.add(
//       SizedBox(
//         child: (!cameraController.value.isInitialized)
//             ? Container()
//             : cameraWidget(context),
//       ),
//     );
//     list.add(Align(
//       alignment: Alignment.bottomCenter,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (classification != null)
//               ...(classification!.entries.toList()
//                     ..sort(
//                       (a, b) => a.value.compareTo(b.value),
//                     ))
//                   .reversed
//                   .take(3)
//                   .map(
//                     (e) => Container(
//                       padding: const EdgeInsets.all(8),
//                       color: Colors.white,
//                       child: Row(
//                         children: [
//                           Text(e.key),
//                           const Spacer(),
//                           Text(e.value.toStringAsFixed(2))
//                         ],
//                       ),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     ));

//     return SafeArea(
//       child: Stack(
//         children: list,
//       ),
//     );
//   }
// }

// class GalleryScreen extends StatefulWidget {
//   const GalleryScreen({super.key});

//   @override
//   State<GalleryScreen> createState() => _GalleryScreenState();
// }

// class _GalleryScreenState extends State<GalleryScreen> {
//   ImageClassificationHelper? imageClassificationHelper;
//   final imagePicker = ImagePicker();
//   String? imagePath;
//   img.Image? image;
//   Map<String, double>? classification;
//   bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

//   @override
//   void initState() {
//     imageClassificationHelper = ImageClassificationHelper();
//     imageClassificationHelper!.initHelper();
//     super.initState();
//   }

//   // Clean old results when press some take picture button
//   void cleanResult() {
//     imagePath = null;
//     image = null;
//     classification = null;
//     setState(() {});
//   }

//   // Process picked image
//   Future<void> processImage() async {
//     if (imagePath != null) {
//       // Read image bytes from file
//       final imageData = File(imagePath!).readAsBytesSync();

//       // Decode image using package:image/image.dart (https://pub.dev/image)
//       image = img.decodeImage(imageData);
//       setState(() {});
//       classification = await imageClassificationHelper?.inferenceImage(image!);
//       setState(() {});
//     }
//   }

//   @override
//   void dispose() {
//     imageClassificationHelper?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               if (cameraIsAvailable)
//                 TextButton.icon(
//                   onPressed: () async {
//                     cleanResult();
//                     final result = await imagePicker.pickImage(
//                       source: ImageSource.camera,
//                     );

//                     imagePath = result?.path;
//                     setState(() {});
//                     processImage();
//                   },
//                   icon: const Icon(
//                     Icons.camera,
//                     size: 48,
//                   ),
//                   label: const Text("Take a photo"),
//                 ),
//               TextButton.icon(
//                 onPressed: () async {
//                   cleanResult();
//                   final result = await imagePicker.pickImage(
//                     source: ImageSource.gallery,
//                   );

//                   imagePath = result?.path;
//                   setState(() {});
//                   processImage();
//                 },
//                 icon: const Icon(
//                   Icons.photo,
//                   size: 48,
//                 ),
//                 label: const Text("Pick from gallery"),
//               ),
//             ],
//           ),
//           const Divider(color: Colors.black),
//           Expanded(
//               child: Stack(
//             alignment: Alignment.center,
//             children: [
//               if (imagePath != null) Image.file(File(imagePath!)),
//               if (image == null)
//                 const Text("Take a photo or choose one from the gallery to "
//                     "inference."),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Row(),
//                   if (image != null) ...[
//                     // Show model information
//                     if (imageClassificationHelper?.inputTensor != null)
//                       Text(
//                         'Input: (shape: ${imageClassificationHelper?.inputTensor.shape} type: '
//                         '${imageClassificationHelper?.inputTensor.type})',
//                       ),
//                     if (imageClassificationHelper?.outputTensor != null)
//                       Text(
//                         'Output: (shape: ${imageClassificationHelper?.outputTensor.shape} '
//                         'type: ${imageClassificationHelper?.outputTensor.type})',
//                       ),
//                     const SizedBox(height: 8),
//                     // Show picked image information
//                     Text('Num channels: ${image?.numChannels}'),
//                     Text('Bits per channel: ${image?.bitsPerChannel}'),
//                     Text('Height: ${image?.height}'),
//                     Text('Width: ${image?.width}'),
//                   ],
//                   const Spacer(),
//                   // Show classification result
//                   SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         if (classification != null)
//                           ...(classification!.entries.toList()
//                                 ..sort(
//                                   (a, b) => a.value.compareTo(b.value),
//                                 ))
//                               .reversed
//                               .take(3)
//                               .map(
//                                 (e) => Container(
//                                   padding: const EdgeInsets.all(8),
//                                   color: Colors.white,
//                                   child: Row(
//                                     children: [
//                                       Text(e.key),
//                                       const Spacer(),
//                                       Text(e.value.toStringAsFixed(2))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           )),
//         ],
//       ),
//     );
//   }
// }
