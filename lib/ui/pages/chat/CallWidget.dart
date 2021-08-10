import 'dart:developer';

import 'package:elajkom/classes/services/openTok_service.dart';
import 'package:flutter/material.dart';
import '../../../generated/locale_base.dart';
import '../../../util/utility/global_var.dart';

class CallWidget extends StatefulWidget {
  static const String routeName = '/CallWidget';
  final Map<String, dynamic> creationParams;
  CallWidget(this.creationParams);
  @override
  _CallWidgetState createState() => _CallWidgetState();
}

class _CallWidgetState extends State<CallWidget> {
  OpenTokController controller;
  @override
  Widget build(BuildContext context) {
    str = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.indigo),
            Transform.scale(
              alignment: Alignment.bottomRight,
              scale: scaleFactor ? 0.3 : 1,
              child: OpenTokWidget(
                creationParams: widget.creationParams,
                onOpenTokCreated: (controller) async {
                  this.controller = controller;
                  var res = await controller.makeCall(widget.creationParams);
                  log('re////////////s : $res');
                },
                responseFromNative: (args) {
                  log('/////////////////////////////// responseFromNative Function ${args.toString()}');
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: scalFun),
    );
  }

  bool scaleFactor = false;
  void scalFun() async {
    setState(() => scaleFactor = !scaleFactor);
  }
}
