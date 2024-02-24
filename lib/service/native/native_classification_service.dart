import 'package:flutter/services.dart';

class NativeClassificationService {
  static const nativeChannelName = 'com.example.smartodontogram';
  static const methodChannel = MethodChannel(nativeChannelName);

  static const navigateFunctionName = 'nativeClassification';

  Future<String> runNativeClassification() async {
    try {
      print("test");
      var data = await methodChannel.invokeMethod(navigateFunctionName);
      return data;
    } on PlatformException catch (e) {
      return 'Failed to invoke: ${e.message}';
    }
  }
}
