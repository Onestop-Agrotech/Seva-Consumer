package com.onestop.seva

import android.app.Activity
import android.content.*
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

// FOR IN APP UPDATES
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability

// Utilities
import android.util.Log

class MainActivity: FlutterActivity() {

    private val CHANNEL = "sms_user_api"
    private lateinit var channel: MethodChannel

    // For In App Updates
    private val UPDATECHANNEL = "update_app"
    private lateinit var updateChannel: MethodChannel

    // For request hint code
    private val CREDENTIAL_PICKER_REQUEST = 1  // Set to an unused request code

    // For in app update call back
    private val IN_APP_UPDATE = 3

    // Flutter Method Channel API
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // SMS USER CONSENT
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler{
                    call, result ->
                    when(call.method){
                        "getPhoneNumber" ->
                            requestHint()

                    }

                }
        // IN APP UPDATES
        updateChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UPDATECHANNEL)
        updateChannel.setMethodCallHandler {
            call, result ->
            when(call.method){
                "checkForUpdate" -> {
                    doUpdate()
                }

            }
        }
    }

    // check for update, if exists then update
    private fun doUpdate(){
        // Creates instance of the manager.
        val appUpdateManager = AppUpdateManagerFactory.create(context)

        // Returns an intent object that you use to check for an update.
        val appUpdateInfoTask = appUpdateManager.appUpdateInfo

        // Checks that the platform will allow the specified type of update.
        appUpdateInfoTask.addOnSuccessListener { appUpdateInfo ->
            if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
                    // check if update type - IMMEDIATE can be allowed
                    && appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)
            ) {
                // Request the update.
                appUpdateManager.startUpdateFlowForResult(
                        // Pass the intent that is returned by 'getAppUpdateInfo()'.
                        appUpdateInfo,
                        // Or 'AppUpdateType.FLEXIBLE' for flexible updates.
                        AppUpdateType.IMMEDIATE,
                        // The current activity making the update request.
                        this,
                        // Include a request code to later monitor this update request.
                        IN_APP_UPDATE)
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

                } else {
                    // none of the above
                    channel.invokeMethod("phone",null)
                }
            IN_APP_UPDATE ->
                if(resultCode != Activity.RESULT_OK){
                    // update has failed
                    Log.d("update", "Android failed to update")
                }
        }
    }

}