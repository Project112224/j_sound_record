package com.example.j_sound_record

import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.io.IOException
import java.io.RandomAccessFile
import kotlin.experimental.and

class WavRecord {
    private var RECORDER_SAMPLERATE: Int = 8000
    private var RECORDER_CHANNELS: Int = AudioFormat.CHANNEL_IN_MONO
    private var RECORDER_AUDIO_ENCODING: Int = AudioFormat.ENCODING_PCM_16BIT
    private var isRecording: Boolean = false
    private var filePath: String? = null
    // 8bit PCM → 1 byte per sample
    // 16bit PCM → 2 bytes per sample
    private var BytesPerElement: Int = 2
    private var BufferElements2Rec: Int = 1024
    private val CHANNELS = 1
    private val BITS_PER_SAMPLE = 16
    private val bufferSizeInBytes: Int = BufferElements2Rec * BytesPerElement

    private var recorder: AudioRecord? = null
    private var recordingThread: Thread? = null

    companion object {
        private const val LOG_TAG = "Record"
    }

    fun startRecord(
        path: String,
        samplingRate: Int,
        result: MethodChannel.Result
    ) {
        RECORDER_SAMPLERATE = samplingRate
        stop()
        try {
            recorder = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                RECORDER_SAMPLERATE,
                RECORDER_CHANNELS,
                RECORDER_AUDIO_ENCODING,
                bufferSizeInBytes
            )
            recorder?.startRecording()
            isRecording = true
            recordingThread = Thread(Runnable {
                run {
                    writeAudioDataToFile(path)
                }
            }, "AudioRecorder Thread")
            recordingThread?.start()
            result.success(null)
        } catch (e: Exception) {
            close()
            result.error("-1", "Start recording failure", e.message)
        }
    }

    private fun writeAudioDataToFile(path: String) {
        filePath = path
        var sData = ShortArray(BufferElements2Rec)
        var os: FileOutputStream? = null

        try {
            os = FileOutputStream(filePath!!)
            os.write(ByteArray(44))
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        }
        while (isRecording) {
            recorder?.read(sData, 0, BufferElements2Rec)
            Log.i(LOG_TAG, "Short writing to file $sData")
            try {
                var bData: ByteArray = short2byte(sData)
                os?.write(bData, 0, bufferSizeInBytes)
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }

        try {
            os?.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }

        try {
            val fis = FileInputStream(filePath!!)
            val fileBytes = fis.readBytes()
            fis.close()
            val header = getWavHeader(fileBytes)
            val raf = RandomAccessFile(filePath, "rw")
            raf.seek(0)
            raf.write(header, 0, 44)
            raf.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    private fun short2byte(sData: ShortArray): ByteArray {
        var shortArrsize: Int = sData.size
        var bytes = ByteArray(shortArrsize * 2)

        for (i in 0 until shortArrsize) {
            bytes[i * 2] = (sData[i] and 0x00FF).toByte()
            bytes[(i * 2) + 1] = (sData[i].toInt() shr 8).toByte()
            sData[i] = 0
        }
        return bytes
    }

    private fun getWavHeader(fileByte: ByteArray): ByteArray {
        val totalAudioLen = fileByte.size
        val byteRate = RECORDER_SAMPLERATE * CHANNELS * BITS_PER_SAMPLE / 8
        val header = ByteArray(44)

        // RIFF chunk
        header[0] = 'R'.code.toByte()
        header[1] = 'I'.code.toByte()
        header[2] = 'F'.code.toByte()
        header[3] = 'F'.code.toByte()

        val totalDataLen = totalAudioLen + 36
        header[4] = (totalDataLen and 0xff).toByte()
        header[5] = ((totalDataLen shr 8) and 0xff).toByte()
        header[6] = ((totalDataLen shr 16) and 0xff).toByte()
        header[7] = ((totalDataLen shr 24) and 0xff).toByte()

        header[8] = 'W'.code.toByte()
        header[9] = 'A'.code.toByte()
        header[10] = 'V'.code.toByte()
        header[11] = 'E'.code.toByte()

        // fmt chunk
        header[12] = 'f'.code.toByte()
        header[13] = 'm'.code.toByte()
        header[14] = 't'.code.toByte()
        header[15] = ' '.code.toByte()
        header[16] = 16  // PCM header size
        header[17] = 0
        header[18] = 0
        header[19] = 0
        header[20] = 1  // Audio format 1=PCM
        header[21] = 0
        header[22] = CHANNELS.toByte()
        header[23] = 0
        header[24] = (RECORDER_SAMPLERATE and 0xff).toByte()
        header[25] = ((RECORDER_SAMPLERATE shr 8) and 0xff).toByte()
        header[26] = ((RECORDER_SAMPLERATE shr 16) and 0xff).toByte()
        header[27] = ((RECORDER_SAMPLERATE shr 24) and 0xff).toByte()
        header[28] = (byteRate and 0xff).toByte()
        header[29] = ((byteRate shr 8) and 0xff).toByte()
        header[30] = ((byteRate shr 16) and 0xff).toByte()
        header[31] = ((byteRate shr 24) and 0xff).toByte()
        header[32] = (CHANNELS * BITS_PER_SAMPLE / 8).toByte() // block align
        header[33] = 0
        header[34] = BITS_PER_SAMPLE.toByte()
        header[35] = 0

        // data chunk
        header[36] = 'd'.code.toByte()
        header[37] = 'a'.code.toByte()
        header[38] = 't'.code.toByte()
        header[39] = 'a'.code.toByte()
        header[40] = (totalAudioLen and 0xff).toByte()
        header[41] = ((totalAudioLen shr 8) and 0xff).toByte()
        header[42] = ((totalAudioLen shr 16) and 0xff).toByte()
        header[43] = ((totalAudioLen shr 24) and 0xff).toByte()
        return header
    }

    fun stopRecord(result: MethodChannel.Result) {
        stop()
        result.success(filePath)
    }

    fun closeRecord() {
        close()
    }

    fun isRecording(result: MethodChannel.Result) {
        result.success(isRecording)
    }

    private fun stop() {
        if (recorder != null) {
            isRecording = false
            recorder?.stop()
            recorder?.release()
            recorder = null
            recordingThread = null
        }
    }

    private fun close() {
        if (recorder != null) {
            stop()
        }
    }

}