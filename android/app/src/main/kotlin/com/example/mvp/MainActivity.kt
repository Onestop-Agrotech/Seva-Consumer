package com.example.mvp

import android.app.Activity
import android.content.*
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import io.flutter.embedding.android.FlutterActivity

// FOR SMS USER CONSENT API
import com.google.android.gms.common.api.Status
import com.google.android.gms.auth.api.credentials.Credential
import com.google.android.gms.auth.api.credentials.Credentials
import com.google.android.gms.auth.api.credentials.HintRequest
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes

import android.util.Log

class MainActivity: FlutterActivity() {

    private val CHANNEL = "sms_user_api"
    private lateinit var channel: MethodChannel

    // For request hint code
    private val CREDENTIAL_PICKER_REQUEST = 1  // Set to an unused request code
    // For getting back the SMS
    private val SMS_CONSENT_REQUEST = 2

    // Flutter Method Channel API
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler{
                    call, result ->
                    when(call.method){
                        "getPhoneNumber" ->
                            requestHint()
                        "getSMS" ->
                            {
                                val senderPhoneNumber=null
                                SmsRetriever.getClient(context).startSmsUserConsent(senderPhoneNumber /* or null */)
                                registerReceiver(smsVerificationReceiver, IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION))
                            }

                    }

                }
    }

    private val smsVerificationReceiver = object : BroadcastReceiver(){
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent != null) {
                if(SmsRetriever.SMS_RETRIEVED_ACTION == intent.action){
                    val extras = intent.extras
                    val smsRetrieverStatus = extras?.get(SmsRetriever.EXTRA_STATUS) as Status
                    when(smsRetrieverStatus.statusCode){
                        CommonStatusCodes.SUCCESS -> {
                            // Get consent intent
                            val consentIntent = extras.getParcelable<Intent>(SmsRetriever.EXTRA_CONSENT_INTENT)
                            try {
                                // Start activity to show consent dialog to user, activity must be started in
                                // 5 minutes,
                                startActivityForResult(consentIntent, SMS_CONSENT_REQUEST)
                            } catch (e: ActivityNotFoundException) {
                                // Handle the exception ...
                            }
                        }
                        CommonStatusCodes.TIMEOUT -> {
                            // Time out occurred, handle the error.
                        }
                    }
                }
            }
        }
    }

    // Open up the request hint box to pick the phone
    private fun requestHint(){
        val hintRequest = HintRequest.Builder()
                .setPhoneNumberIdentifierSupported(true)
                .build()
        val credentialsClient = Credentials.getClient(this)
        val intent = credentialsClient.getHintPickerIntent(hintRequest)
        startIntentSenderForResult(
                intent.intentSender,
                CREDENTIAL_PICKER_REQUEST,
                null, 0, 0, 0
        )

    }

    // Get the phone number
    public override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when(requestCode){
            CREDENTIAL_PICKER_REQUEST ->
                if(resultCode == Activity.RESULT_OK && data != null){
                    val credential = data.getParcelableExtra<Credential>(Credential.EXTRA_KEY)
                    // credential.id()
                    channel.invokeMethod("phone", credential.id)

                }
            SMS_CONSENT_REQUEST ->
                // Obtain the phone number from the result
                if (resultCode == Activity.RESULT_OK && data != null) {
                    // Get SMS message content
                    val message = data.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)
                    // Extract one-time code from the message and complete verification
                    // `message` contains the entire text of the SMS message, so you will need
                    // to parse the string.

                    val oneTimeCode = parseOneTimeCode(message) // define this function
                    channel.invokeMethod("sms",oneTimeCode.toString())

                    // send one time code to the server
                } else {
                    // Consent denied. User can type OTC manually.
                }
        }
    }

    // Parse the message and return the code only
    private fun parseOneTimeCode(message: String?): Any {
        return message?.filter { it.isDigit() } ?: ""
    }


}