package com.example.odontogram

import android.content.Intent
import com.example.odontogram.ui.screen.ClassificationActivity
import com.example.odontogram.ui.screen.ClassificationActivity.Companion.ARG_PATIENT_ID
import com.example.odontogram.ui.screen.ClassificationActivity.Companion.ARG_QUADRANT
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val eventChannel = "com.example.smartodontogram"
    private val navigateFunctionName = "nativeClassification"
    private var methodChannelResult: MethodChannel.Result? = null

    private val composeActivityRequestCode: Int = 4

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            eventChannel
        ).setMethodCallHandler { call, result ->
            methodChannelResult = result

            if (call.method == navigateFunctionName) {
                val intent = Intent(this, ClassificationActivity::class.java)
                intent.putExtra(ARG_PATIENT_ID, call.argument<String>(ARG_PATIENT_ID))
                intent.putExtra(ARG_QUADRANT, call.argument<Int>(ARG_QUADRANT))
                startActivityForResult(intent, composeActivityRequestCode)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == composeActivityRequestCode) {
            if (resultCode == RESULT_OK) {
                val value = data?.getStringExtra(ClassificationActivity.ARG_RESULT)
                methodChannelResult?.success(value)
            }
        }
    }
}
