
//  CurtainViewController.swift
//  Brainshots
//
//  Created by Amritpal Singh on 18/01/17.
//  Copyright © 2017 Anuradha Sharma. All rights reserved.
//
//
//

    //
    //  AccountGroupViewController.swift
    //  Pegase
    //
    //  Created by thierryH24 on 19/09/2021.
    //

import Cocoa

final class CurtainViewController: NSViewController {

    @IBOutlet weak var secureText: NSSecureTextField!

    var size = CGSize.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do view setup here.

        self.secureText.delegate = self

        self.view.wantsLayer = true
        let image = NSImage(named: NSImage.Name( "curtain"))
        self.view.layer!.contents = image

        self.preferredContentSize = size
    }

    @IBAction func confirm(_ sender: Any) {
        let passWord = Defaults.string(forKey: "password")

        if passWord == secureText.stringValue || passWord == nil {
            if presentingViewController != nil {
                presentingViewController!.dismiss(self)
            }
        } else {
//            shakeLogin()
            secureText.shake(withCompletion: nil)
        }
    }

//    private func shakeLogin() {
//
//        let numberOfShakes = 5
//        let durationOfShake = 0.5
//        let vigourOfShake: CGFloat = 0.05
//
//        let frame: CGRect = (self.view.window!.frame)
//        let shakeAnimation = CAKeyframeAnimation()
//
//        let shakePath = CGMutablePath()
//        shakePath.move(to: CGPoint(x: NSMinX(frame), y: NSMinY(frame)))
//        for _ in 1 ... numberOfShakes {
//            shakePath.addLine(to: CGPoint(x: NSMinX(frame) - frame.size.width * vigourOfShake, y: NSMinY(frame)))
//            shakePath.addLine(to: CGPoint(x: NSMinX(frame) + frame.size.width * vigourOfShake, y: NSMinY(frame)))
//        }
//        shakePath.closeSubpath()
//
//        shakeAnimation.path = shakePath
//        shakeAnimation.duration = CFTimeInterval(durationOfShake)
//        self.view.window?.animations = ["frameOrigin": shakeAnimation]
//        let origin = self.view.window?.frame.origin
//        self.view.window?.animator().setFrameOrigin(origin!)
//    }

}

extension CurtainViewController: NSTextFieldDelegate {

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            confirm(textView)
            return true
//        } else if (commandSelector == #selector(NSResponder.deleteForward(_:))) {
//            // Do something against DELETE key
//            return true
//        } else if (commandSelector == #selector(NSResponder.deleteBackward(_:))) {
//            // Do something against BACKSPACE key
//            return true
//        } else if (commandSelector == #selector(NSResponder.insertTab(_:))) {
//            // Do something against TAB key
//            return true
//        } else if (commandSelector == #selector(NSResponder.cancelOperation(_:))) {
//            // Do something against ESCAPE key
//            return true
        }

        // return true if the action was handled; otherwise false
        return false
    }

}


//
//  CurtainViewController.swift
//  Brainshots
//
//  Created by Amritpal Singh on 18/01/17.
//  Copyright © 2017 Anuradha Sharma. All rights reserved.
//

//import AppKit
//import AVFoundation
//
//protocol CurtainDelegate {
//    func openCurtain() -> Double
//    func closeCurtain() -> Double
//}
//
//final class CurtainViewController: NSViewController {
//
//    var curtainsSound : AVAudioPlayer? = nil
//    var curtainsOpenSound : AVAudioPlayer? = nil
//
//    lazy var imageArray = [NSImage]()
//    var playIndex = 0
//    var playTotalTime : Double = 0
//    var animTimer : Timer?
//
//    @IBOutlet weak var imageView: NSImageView!
//    @IBOutlet weak var passwordField: NSSecureTextField!
//    @IBOutlet weak var userField: NSTextField!
//    @IBOutlet weak var gridView: NSGridView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        openCurtainsSound()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func viewDidAppear() {
//        super.viewDidAppear()
//
////        self.view.wantsLayer = true
//        self.view.layer?.backgroundColor = NSColor.clear.cgColor
//    }
//
//    /*Add Bottle On Counter Sound*/
//    func curtainSound(){
//
//        let path = Bundle.main.path(forResource: "CURTAINS CLOSE_OPEN.wav", ofType:nil)!
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            curtainsSound = try AVAudioPlayer(contentsOf: url)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//
//    func openCurtainsSound(){
//
//        let path = Bundle.main.path(forResource: "CURTAINS OPEN.wav", ofType:nil)!
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            curtainsOpenSound = try AVAudioPlayer(contentsOf: url)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//
//    func readGifDataAndConfigImageView(name: String) {
//
//        imageArray.removeAll()
//        playIndex = 0
//        playTotalTime = 0
//        animTimer?.invalidate()
//
//        guard let gifPath = Bundle.main.pathForImageResource( name ) else {return}
//        guard let gifData = NSData(contentsOfFile: gifPath) else {return}
//
//        guard let imageSourceRef = CGImageSourceCreateWithData(gifData, nil) else {return}
//
//        let imageCount = CGImageSourceGetCount(imageSourceRef)
//
//        for  i in 0 ..< imageCount {
//
//            guard let cgImageRef =  CGImageSourceCreateImageAtIndex(imageSourceRef, i, nil) else {continue}
//
//            let image =  NSImage(cgImage: cgImageRef, size: CGSize(width: cgImageRef.width, height: cgImageRef.height))
//            imageArray.append(image)
//
//            let cfProperties =  CGImageSourceCopyPropertiesAtIndex(imageSourceRef, i, nil)
//            let gifProperties: CFDictionary = unsafeBitCast(
//                CFDictionaryGetValue(cfProperties,
//                                     Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
//
//            var delayObject: AnyObject = unsafeBitCast(
//                CFDictionaryGetValue(gifProperties,
//                                     Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
//            if delayObject.doubleValue == 0 {
//                delayObject = unsafeBitCast(CFDictionaryGetValue(
//                    gifProperties,
//                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
//            }
//            playTotalTime += delayObject as! Double
//        }
//
//        imageView.image = imageArray.first
//
//        self.imageView.canDrawSubviewsIntoLayer = true
//        self.imageView.imageScaling = .scaleAxesIndependently
//        self.imageView.frame = CGRect(x: 100.0, y: 100.0, width: self.view.frame.size.width / 10, height: self.view.frame.size.height / 10)
//
//        curtainsOpenSound?.stop()
//        curtainsOpenSound?.prepareToPlay()
//        curtainsOpenSound?.play()
//    }
//
//    func timer() {
//
//        animTimer = Timer(timeInterval: playTotalTime / Double(imageArray.count), target: self, selector: #selector(startGifAnimated), userInfo: nil, repeats: true)
//        RunLoop.current.add(animTimer!, forMode: RunLoop.Mode.common)
//    }
//
//    @objc func startGifAnimated() {
//        imageView.image = imageArray[playIndex]
//        playIndex += 1
//        if playIndex == imageArray.count {
//            animTimer!.invalidate()
//            playIndex = 0
//        }
//    }
//}
//
//extension CurtainViewController : CurtainDelegate{
//
//    func openCurtain() -> Double {
//
//        gridView.isHidden = true
//
//        readGifDataAndConfigImageView(name: "CurtainOpen640.gif")
//        timer()
//        return playTotalTime * 10
//    }
//
//    func closeCurtain() -> Double {
//
//        gridView.isHidden = false
//
//        passwordField.stringValue = ""
//        userField.stringValue = ""
//
//        readGifDataAndConfigImageView(name: "CurtainClose640.gif")
//        timer()
//        return playTotalTime
//    }
//
//
//}
