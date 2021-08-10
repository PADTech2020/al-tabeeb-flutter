package com.elajkom.mobileapp


import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class OenTokFactory(private val messenger: BinaryMessenger  ) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return OpenTokWidget(context = context, id = viewId,args = args, messenger = messenger )
    }
}