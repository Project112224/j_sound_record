package com.example.j_sound_record

import android.Manifest
import android.os.Build
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import android.util.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import java.io.File
import java.io.IOException

/** JSoundRecordPlugin */
class JSoundRecordPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activityBinding: ActivityPluginBinding? = null
  private lateinit var recorder : Recorder
  private lateinit var wavRecorder : WavRecord
  private var pendingPermResult: MethodChannel.Result? = null
  private var isWav: Boolean = false

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "j_sound_record")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "start" -> {
        val encoder = call.argument<Any>("encoder") as Int
        isWav = encoder == 6
        var fileNameExtension = if (isWav) { "wav" } else { "m4a" }
        var path = call.argument<Any>("path") as String?
        if (path == null) {
          val outputDir = activityBinding!!.activity.cacheDir
          val outputFile: File?
          try {
            outputFile = File.createTempFile("audio", ".$fileNameExtension", outputDir)
            path = outputFile.path
          } catch (e: IOException) {
            e.printStackTrace()
          }
        }
        if (isWav) {
          val rate = (call.argument<Any>("samplingRate") as Double).toInt()
          wavRecorder.startRecord(
            path!!,
            rate,
            result
          )
          return
        }
        recorder.start(
          path!!,
          encoder,
          call.argument<Any>("bitRate") as Int,
          call.argument<Any>("samplingRate") as Double,
          result
        )
      }
      "stop" -> {
        if (isWav) {
          wavRecorder.stopRecord(result)
        } else {
          recorder.stop(result)
        }
      }
      "pause" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        recorder.pause(result)
      }
      "resume" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        recorder.resume(result)
      }
      "isPaused" -> recorder.isPaused(result)
      "isRecording" -> {
        if (isWav) {
          wavRecorder.isRecording(result)
        } else {
          recorder.isRecording(result)
        }
      }
      "hasPermission" -> hasPermission(result)
      "getAmplitude" -> recorder.getAmplitude(result)
      "dispose" -> {
        close()
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


  // ActivityAware
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityBinding = binding
    recorder = Recorder(activityBinding!!.activity)
    wavRecorder = WavRecord()
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    stopPlugin()
  }

  private fun stopPlugin() {
    activityBinding = null
    channel!!.setMethodCallHandler(null)
  }

  private fun hasPermission(result: MethodChannel.Result) {
    try {
      if (!isPermissionGranted) {
        pendingPermResult = result
        askForPermission()
      } else {
        result.success(true)
      }
    } catch (ex: Exception) {
      result.success(ex)
    }
  }

  private val isPermissionGranted: Boolean
    get() {
      val result =
        ActivityCompat.checkSelfPermission(activityBinding!!.activity, Manifest.permission.RECORD_AUDIO)
      return result == PackageManager.PERMISSION_GRANTED
    }

  private fun askForPermission() {
    ActivityCompat.requestPermissions(
      activityBinding!!.activity, arrayOf(Manifest.permission.RECORD_AUDIO),
      RECORD_AUDIO_REQUEST_CODE
    )
  }

  /// Custom function

  companion object {
    private const val RECORD_AUDIO_REQUEST_CODE = 1001
  }

  private fun close() {
    wavRecorder.closeRecord()
    recorder.close()
    pendingPermResult = null
  }

}
