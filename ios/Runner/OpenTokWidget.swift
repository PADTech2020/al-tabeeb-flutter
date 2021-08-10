//
//  OpenTokWidget.swift
//  Runner
//
//  Created by Bayhas Aroob on 2.10.2020.
//

import Foundation
import UIKit
import OpenTok

public class OpenTokWidget: NSObject, FlutterPlatformView   {
     
    let audioMeetingType = 1
       let videoMeetingType = 0
       var isMute = false
       
       let muteImage = UIImage(named: "mute") as UIImage?
       let unMuteImage = UIImage(named: "unmute") as UIImage?
       
    
    var kApiKey: String = ""
     var kSessionId: String = ""
    var kToken: String = ""
    var kMeetingType: Int = 1
    var kMeetingTypeRequest: Int = 1
     
       
       var session: OTSession?
       var publisher: OTPublisher?
       var subscriber: OTSubscriber?
        
       var muteBTN: UIButton!
       
    
    let frame: CGRect
    let viewId: Int64
    let channel: FlutterMethodChannel
    var makeCallResult: FlutterResult?
    var mainView: UIView
    
    init(_ frame: CGRect, viewId: Int64, channel: FlutterMethodChannel, args: Any?) {
        self.frame = frame
        self.viewId = viewId
        self.channel = channel
        
        self.mainView  = UIView(frame: self.frame)
        self.mainView.backgroundColor = UIColor.black

        super.init()
        
        print(kApiKey )
        initViews()
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "makeCall") {
                self.makeCallResult = result
                self.makeCall(call: call )
                
            }
        })
    }
    
    public func makeCall(call: FlutterMethodCall ){
        let arguments = call.arguments as? [String: Any]
        kApiKey = arguments?["apiKey"] as! String
        kSessionId = arguments?["sessionId"] as! String
        kToken = arguments?["token"] as! String
        kMeetingType = arguments?["meetingType"] as? Int ?? 1
        kMeetingTypeRequest = arguments?["meetingTypeRequest"] as? Int ?? 1
//        print("............................ makeCall Fun")
//        print(kApiKey)
        connectToAnOpenTokSession() 
    }
    
    public func view() -> UIView {
       
        return mainView
    }
    
    func  initViews()  {
        let screenBounds = UIScreen.main.bounds
        
       let endCallBTN = UIButton(frame: CGRect(x: screenBounds.width / 2 - 30 , y: screenBounds.height - 100 , width: 60, height: 60))
       endCallBTN.setImage(UIImage(named: "call_off") as UIImage?, for:  UIControl.State.normal)
       endCallBTN.addTarget(self, action: #selector(self.endCallTapped), for: .touchUpInside)
       endCallBTN.layer.cornerRadius = 30
       mainView.addSubview(endCallBTN)
        
        muteBTN  = UIButton(frame: CGRect(x: 20 , y: screenBounds.height - 80 , width: 45, height: 45))
        muteBTN.setImage(muteImage, for:  UIControl.State.normal)
        muteBTN.addTarget(self, action: #selector(self.muteTapped), for: .touchUpInside)
        muteBTN.layer.cornerRadius = 22.5
       mainView.addSubview(muteBTN)
    }
    
    @objc func endCallTapped(sender : UIButton) {
        let startTime = session?.connection?.creationTime ?? Date()
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        print(duration)
        session?.disconnect()
        self.makeCallResult!("Call Ended")
    }
    
    @objc func muteTapped(sender : UIButton) {
        isMute = !isMute
        publisher?.publishAudio = !isMute
        if(isMute){
            muteBTN.setImage(unMuteImage, for:  UIControl.State.normal)
        }else{
            muteBTN.setImage(muteImage, for: UIControl.State.normal)
        }
    }
    
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
    }
    
}


// MARK: - OTSessionDelegate callbacks
extension OpenTokWidget: OTSessionDelegate {
    public func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")
        
        let settings = OTPublisherSettings()
        settings.name = UIDevice.current.name
       publisher = OTPublisher(delegate: self, settings: settings)
        
        if(kMeetingTypeRequest == 1)
        {
            publisher?.publishVideo = false
        }
        if(kMeetingType == 1){
            publisher?.publishVideo = false
        }
        
        var error: OTError?
        session.publish(publisher!, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        
        guard let publisherView = publisher?.view else {
            return
        }
        let screenBounds = UIScreen.main.bounds
        publisherView.frame = CGRect(x: screenBounds.width - 140 , y: screenBounds.height - 150 - 10, width: 125, height: 150)
        mainView.addSubview(publisherView)
        
    }
    
    public func sessionDidDisconnect(_ session: OTSession) {
        print("The client disconnected from the OpenTok session.")
    }
    
    public func session(_ session: OTSession, didFailWithError error: OTError) {
        print("The client failed to connect to the OpenTok session: \(error).")
    }
    public func session(_ session: OTSession, streamCreated stream: OTStream) {
        subscriber = OTSubscriber(stream: stream, delegate: self)
        guard let subscriber = subscriber else {
            return
        }
        
        if(kMeetingTypeRequest == 1)
        {
            subscriber.subscribeToVideo  = false
        }
        if(kMeetingType == 1){
            subscriber.subscribeToVideo = false
        }
        
        var error: OTError?
        session.subscribe(subscriber, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        
        guard let subscriberView = subscriber.view else {
            return
        }
        subscriberView.frame = UIScreen.main.bounds
        mainView.insertSubview(subscriberView, at: 0)
    }
    
    public  func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("A stream was destroyed in the session.")
    }
}

// MARK: - OTPublisherDelegate callbacks
extension OpenTokWidget: OTPublisherDelegate {
    public func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("The publisher failed: \(error)")
    }
}

// MARK: - OTSubscriberDelegate callbacks
extension OpenTokWidget: OTSubscriberDelegate {
      public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber did connect to the stream.")
    }
    
    public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("The subscriber failed to connect to the stream.")
    }
}



