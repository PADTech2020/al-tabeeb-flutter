//
//  FirstWidgetFactory.swift
//  Runner
//
//  Created by Bayhas Aroob on 2.10.2020.
//
 
 
import Foundation

public class OpenTokFactory : NSObject, FlutterPlatformViewFactory {
    let controller: FlutterViewController
    
    init(controller: FlutterViewController) {
        self.controller = controller
    }
    
    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let channel = FlutterMethodChannel(
            name: "plugins/open_tok_" + String(viewId),
            binaryMessenger: controller as! FlutterBinaryMessenger
        )
//        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!11111")
//        print(args ?? "defaultaaaa value")
        return OpenTokWidget(frame, viewId: viewId, channel: channel, args: args)
    }
}

