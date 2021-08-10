import 'dart:async';
import 'dart:developer';
import 'package:elajkom/util/custome_widgets/messages.dart';
import 'package:elajkom/util/utility/global_var.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OpenTokCreatedCallback = void Function(OpenTokController controller);

class OpenTokWidget extends StatefulWidget {
  const OpenTokWidget({Key key, this.onOpenTokCreated, this.responseFromNative, this.creationParams = const {}}) : super(key: key);

  final OpenTokCreatedCallback onOpenTokCreated;
  final Function(dynamic res) responseFromNative;
  final Map<String, dynamic> creationParams;

  static void resultHandler(BuildContext context, dynamic res, GlobalKey<ScaffoldState> _scafoldKey) {
    // close Connection key String
    const String callEnd = "callEnd";
    const String configurationError = "ConfigurationError";
    const String onDisconnected = "onDisconnected";
    const String onStreamDropped = "onStreamDropped";
    const String onStreamDestroyed = "onStreamDestroyed";
    switch (res) {
      case callEnd:
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.openTaoCallEnd));
        break;
      case configurationError:
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.openTokConfigurationError));
        break;
      case onDisconnected:
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.openTokConnectionLost));
        break;
      case onStreamDropped:
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.openTokConnectionLost));
        break;
      case onStreamDestroyed:
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(str.app.openTokConnectionLost));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.blankSnakBar(res));
    }
  }

  @override
  State<StatefulWidget> createState() => _OpenTokState();
}

class _OpenTokState extends State<OpenTokWidget> {
  final String viewType = 'plugins/open_tok';
  @override
  Widget build(BuildContext context) {
    log('fdsafdsaf afadsfsd fsd f: ${widget.creationParams}');
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: viewType,
        creationParams: widget.creationParams,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: viewType,
        creationParams: widget.creationParams,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else
      return const Text('  Platform is not implemented yet.');
  }

  void _onPlatformViewCreated(int id) {
    log('id : $id');
    if (widget.onOpenTokCreated == null) {
      return;
    }
    log('id 2: $id');
    widget.onOpenTokCreated(OpenTokController(id, widget.responseFromNative));
  }
}

class OpenTokController {
  MethodChannel _channel;
  Function responseFromNative;
  OpenTokController(int id, Function responseFromNative) {
    _channel = MethodChannel('plugins/open_tok_$id');
    _channel.setMethodCallHandler(_invokedMethodHandle);
    this.responseFromNative = responseFromNative;
  }

  Future<dynamic> _invokedMethodHandle(MethodCall call) async {
    switch (call.method) {
      case 'closeCall':
        String text = call.arguments as String;
        log('sendFromNative : $text ');
        responseFromNative(text);
      // return Future<String>.value("Text from native: $text");
    }
  }

  Future<dynamic> makeCall(Map<String, dynamic> args) async {
    return await _channel.invokeMethod<dynamic>('makeCall', args);
  }
}
