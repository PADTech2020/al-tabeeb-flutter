package com.elajkom.mobileapp


import android.Manifest
import android.app.AlertDialog
import android.content.Context
import android.opengl.GLSurfaceView
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.FrameLayout
import android.widget.TextView
import android.widget.Toast
import com.opentok.android.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import pub.devrel.easypermissions.EasyPermissions

class OpenTokWidget internal constructor(context: Context, id: Int, args: Any?, messenger: BinaryMessenger) : PlatformView, MethodCallHandler,
        WebServiceCoordinator.Listener, Session.SessionListener, PublisherKit.PublisherListener   {
    private val view: View
    private val methodChannel: MethodChannel
    private var result: Result? = null
    private val context: Context

    // close Connection key String
    private val callEnd = "callEnd"
    private val configurationError = "ConfigurationError"
    private val onDisconnected = "onDisconnected"
    private val onStreamDropped = "onStreamDropped"
    private val onStreamDestroyed = "onStreamDestroyed"

    private val audioMeetingType = 1
    private val videoMeetingType = 0

    private var mSession: Session? = null
    private var mPublisher: Publisher? = null
    private var mSubscriber: Subscriber? = null

    private var btnEndCall: Button? = null
    private var btnAudio: Button? = null
    private var btnVideo: Button? = null

    private var mPublisherViewContainer: FrameLayout? = null
    private var mSubscriberViewContainer: FrameLayout? = null

    // Replace with your OpenTok API key
    private var apiKey: String = ""
    private var sessionId: String = ""
    private var token: String = ""
    private var meetingType = 1
    private var meetingTypeRequest = 1

    private var publishAudio = false
    private var publishVideo = false


    override fun getView(): View {
        Log.e(" getView method", "faffing faffing faffing faffing");
        return view
    }

    init {
        Log.e(" init method", "faffing faffing faffing faffing");
        this.context = context
        val params = args?.let { args as Map<*, *> }

        Log.e("%%%%%%%%%%%%%%%%*apiKey", params.toString())
        val text = params?.get("text") as CharSequence?
        view = LayoutInflater.from(context).inflate(R.layout.activity_video, null)
        methodChannel = MethodChannel(messenger, "plugins/open_tok_$id")
        methodChannel.setMethodCallHandler(this)


    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        this.result = result
        when (methodCall.method) {
            "makeCall" -> makeCall(methodCall)
            else -> result.notImplemented()
        }
    }

    private fun makeCall(methodCall: MethodCall) {
        apiKey = methodCall.argument<String>("apiKey").toString()
        sessionId = methodCall.argument<String>("sessionId").toString()
        token = methodCall.argument<String>("token").toString()
        meetingType = methodCall.argument<Int>("meetingType")!!
        meetingTypeRequest = methodCall.argument<Int>("meetingTypeRequest")!!


        Log.e("%%%%%%%%%%%%%%%%*apiKey", apiKey);

        // initialize view objects from your layout
        mPublisherViewContainer = view.findViewById<View>(R.id.publisher_container) as FrameLayout
        mSubscriberViewContainer = view.findViewById<View>(R.id.subscriber_container) as FrameLayout
        btnAudio = view.findViewById<View>(R.id.btnAudio) as Button
        btnAudio!!.setOnClickListener {
            setPublishAudio(!publishAudio)
        }
        btnVideo = view.findViewById<View>(R.id.btnVideo) as Button
        btnVideo!!.setOnClickListener {
            setPublishVideo(!publishVideo)
        }
        btnEndCall = view.findViewById<View>(R.id.btnEndCall) as Button
        btnEndCall!!.setOnClickListener {
            closeConnection(callEnd)
        }

        if (meetingType == videoMeetingType) {
            publishAudio = true
            if (meetingTypeRequest == videoMeetingType) {
                publishVideo = true
                //btnVideo!!.visibility = View.VISIBLE
                mPublisherViewContainer!!.visibility = View.VISIBLE
                mSubscriberViewContainer!!.visibility = View.VISIBLE
            }

        } else if (meetingType == audioMeetingType) {
            publishAudio = true
        } else {
            btnAudio!!.visibility = View.GONE
        }
        startCall()

    }


    private fun setPublishAudio(value: Boolean) {
        if (value) {
            if (meetingType <= audioMeetingType) {
                publishAudio = value
                btnAudio!!.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_baseline_volume_off_24, 0, 0);
                mPublisher!!.publishAudio = publishAudio
            }
        } else {
            publishAudio = value
            btnAudio!!.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_baseline_volume_up_24, 0, 0);
            mPublisher!!.publishAudio = publishAudio
        }
    }

    private fun setPublishVideo(value: Boolean) {
        if (value) {
            if (meetingType == videoMeetingType) {
                publishVideo = value
                mPublisherViewContainer!!.visibility = View.VISIBLE
                btnVideo!!.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_baseline_videocam_off_24, 0, 0);
                mPublisher!!.publishVideo = publishVideo
            }
        } else {
            publishVideo = value
            mPublisherViewContainer!!.visibility = View.GONE
            btnVideo!!.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_baseline_videocam_24, 0, 0);
            mPublisher!!.publishVideo = publishVideo
        }
    }


    private fun startCall() {

        val perms = arrayOf(Manifest.permission.INTERNET, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)
        if (EasyPermissions.hasPermissions(context, *perms)) {

            if (!apiKey.isBlank() && !sessionId.isBlank() && !token.isBlank()) {
                initializeSession(apiKey, sessionId, token)
            } else {
                closeConnection(configurationError)
            }

        }
    }

    private fun initializeSession(apiKey: String, sessionId: String, token: String) {

        mSession = Session.Builder(context, apiKey, sessionId).build()
        mSession!!.setSessionListener(this)

        mSession!!.connect(token)
    }

    /* Web Service Coordinator delegate methods */

    override fun onSessionConnectionDataReady(apiKey: String, sessionId: String, token: String) {

        Log.e(LOG_TAG, "ApiKey: $apiKey SessionId: $sessionId Token: $token")
        initializeSession(apiKey, sessionId, token)
    }

    override fun onWebServiceCoordinatorError(error: Exception) {

        Log.e(LOG_TAG, "Web Service error: " + error.message)
        Toast.makeText(context, "Web Service error: " + error.message, Toast.LENGTH_LONG).show()
        closeConnection(" Web Service error: " + error.message)

    }

    /* Session Listener methods */

    override fun onConnected(session: Session) {

        Log.e(LOG_TAG, "onConnected: Connected to session: " + session.sessionId)

        // initialize Publisher and set this object to listen to Publisher events
        mPublisher = Publisher.Builder(context).build()
        mPublisher!!.setPublisherListener(this)

        // set publisher video style to fill view
        mPublisher!!.renderer.setStyle(BaseVideoRenderer.STYLE_VIDEO_SCALE,
                BaseVideoRenderer.STYLE_VIDEO_FILL)
        mPublisherViewContainer!!.addView(mPublisher!!.view)
        if (mPublisher!!.view is GLSurfaceView) {
            (mPublisher!!.view as GLSurfaceView).setZOrderOnTop(true)
        }
        mPublisher!!.publishAudio = publishAudio
        mPublisher!!.publishVideo = publishVideo
        mSession!!.publish(mPublisher)
    }

    override fun onDisconnected(session: Session) {

        Log.e(LOG_TAG, "onDisconnected: Disconnected from session: " + session.sessionId)
    }

    override fun onStreamReceived(session: Session, stream: Stream) {

        Log.e(LOG_TAG, "onStreamReceived: New Stream Received " + stream.streamId + " in session: " + session.sessionId)
        view.findViewById<View>(R.id.tvWaiting).visibility = View.GONE
        if (mSubscriber == null) {
            mSubscriber = Subscriber.Builder(context, stream).build()
            mSubscriber!!.renderer.setStyle(BaseVideoRenderer.STYLE_VIDEO_SCALE, BaseVideoRenderer.STYLE_VIDEO_FILL)
//            mSubscriber!!.setSubscriberListener(this)
            mSubscriber!!.subscribeToAudio = meetingType <= audioMeetingType
            mSubscriber!!.subscribeToVideo = meetingType == videoMeetingType
            mSession!!.subscribe(mSubscriber!!)
            mSubscriberViewContainer!!.addView(mSubscriber!!.view)
        }

        val tvWaiting = view.findViewById<View>(R.id.tvWaiting) as TextView
        tvWaiting.text = ""
    }

    override fun onStreamDropped(session: Session, stream: Stream) {

        Log.e(LOG_TAG, "onStreamDropped: Stream Dropped: " + stream.streamId + " in session: " + session.sessionId)

        if (mSubscriber != null) {
            mSubscriber = null
            mSubscriberViewContainer!!.removeAllViews()
        }

        closeConnection(onStreamDropped)
    }

    override fun onError(session: Session, opentokError: OpentokError) {
        Log.e(LOG_TAG, "onError: " + opentokError.errorDomain + " : " +
                opentokError.errorCode + " - " + opentokError.message + " in session: " + session.sessionId)

        showOpenTokError(opentokError)
    }

    /* Publisher Listener methods */

    override fun onStreamCreated(publisherKit: PublisherKit, stream: Stream) {

        Log.e(LOG_TAG, "onStreamCreated: Publisher Stream Created. Own stream " + stream.streamId)

    }

    override fun onStreamDestroyed(publisherKit: PublisherKit, stream: Stream) {

        Log.e(LOG_TAG, "onStreamDestroyed: Publisher Stream Destroyed. Own stream " + stream.streamId)

        closeConnection(onStreamDestroyed)
    }

    override fun onError(publisherKit: PublisherKit, opentokError: OpentokError) {

        Log.e(LOG_TAG, "onError: " + opentokError.errorDomain + " : " +
                opentokError.errorCode + " - " + opentokError.message)

        showOpenTokError(opentokError)
    }
//
//    override fun onConnected(subscriberKit: SubscriberKit) {
//
//        Log.e(LOG_TAG, "onConnected: Subscriber connected. Stream: " + subscriberKit.stream.streamId)
//    }
//
//    override fun onDisconnected(subscriberKit: SubscriberKit) {
//
//        Log.e(LOG_TAG, "onDisconnected: Subscriber disconnected. Stream: " + subscriberKit.stream.streamId)
//    }
//
//    override fun onError(subscriberKit: SubscriberKit, opentokError: OpentokError) {
//
//        Log.e(LOG_TAG, "onError: " + opentokError.errorDomain + " : " +
//                opentokError.errorCode + " - " + opentokError.message)
//
//        showOpenTokError(opentokError)
//    }

    private fun showOpenTokError(opentokError: OpentokError) {

        Toast.makeText(context, opentokError.errorDomain.name + ": " + opentokError.message + " Please, see the logcat.", Toast.LENGTH_LONG).show()


        closeConnection(opentokError.toString())
        // finish()
    }

    private fun showConfigError(alertTitle: String, errorMessage: String) {
        Log.e(LOG_TAG, "Error $alertTitle: $errorMessage")
        AlertDialog.Builder(context)
                .setTitle(alertTitle)
                .setMessage(errorMessage)
                .setPositiveButton("ok") { dialog, which -> methodChannel.invokeMethod("closeCall", errorMessage) }
                .setIcon(android.R.drawable.ic_dialog_alert)
                .show()
    }

    companion object {

        private val LOG_TAG = "openTok Activity"
        private const val RC_VIDEO_APP_PERM = 124
    }

    private fun closeConnection(msg: String) {
        try {
            if (mSession != null) {
                val date = mSession!!.connection.creationTime
                Log.e("SessionCall", "Start time is : " + date.time)
                mSession!!.disconnect()
                mSession = null
                result!!.success(callEnd)
            }
        } catch (err: Exception) {
            Log.e("closeConnection", err.toString())
        }
    }


    override fun dispose() {

    }
}