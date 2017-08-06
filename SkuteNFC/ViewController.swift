//
//  ViewController.swift
//  SkuteNFC
//
//  Created by Dan Griffiths on 2017-07-27.
//  Copyright © 2017 Dan Griffiths. All rights reserved.
//
import Foundation
import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
   
    @IBOutlet weak var smallSkuteButton: UIButton!
    @IBOutlet weak var largeSkuteButton: UIButton!
    var payloadLabel: UILabel!
    var onNFCResult: ((Bool, String) -> ())?
    
    func fireContent () {
        /*
        let url = URL(string: "https://www.youtube.com/watch?v=gvHIjO7AqA8")!
         if #available(iOS 10.0, *) {
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
         } else {
         UIApplication.shared.openURL(url)
         }
 
 
         let ChannelView:UIViewController = UIStoryboard(name: "ChannelView", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as UIViewController
         // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
         
         self.present(ChannelView, animated: true, completion: nil)
 
 
       
        let storyboard = UIStoryboard(name: "ChannelView", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChannelView")
        // self.addTarget(controller, action: "test:", forControlEvents: UIControlEvents.TouchUpInside)
        self.present(controller, animated: true, completion: nil)
 */

        self.performSegue(withIdentifier: "ContentTransition", sender: self)
 

        
        
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        largeSkuteButton.addTarget(self, action: #selector(didTapReadNFC), for: .touchUpInside)
        smallSkuteButton.addTarget(self, action: #selector(didTapReadNFC), for: .touchUpInside)
        
        
        payloadLabel = UILabel(frame: largeSkuteButton.frame.offsetBy(dx: 0, dy: 0))
        payloadLabel.numberOfLines = 10
        payloadLabel.text = ""
        self.view.addSubview(payloadLabel)
    }
    
    func onNFCResult(success: Bool, msg: String) {
        DispatchQueue.main.async {
            self.payloadLabel.text = "\(self.payloadLabel.text!)\n\(msg)"
        }
    }
    
    @objc func didTapReadNFC() {
        print("didTapReadNFC")
        self.payloadLabel.text = ""
       onNFCResult = onNFCResult(success:msg:)
       restartSession()
        // helper.fireUrl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Trigger when valid NFC tag is read
    func restartSession() {
        let session = NFCNDEFReaderSession(delegate: self,
                                           queue: nil,
                                           invalidateAfterFirstRead: true)
        session.begin()
    }
    // MARK: NFCNDEFReaderSessionDelegate
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        guard let onNFCResult = onNFCResult else { return }
        onNFCResult(false, error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // MARK: Load content view
        fireContent()
        guard let onNFCResult = onNFCResult else { return }
        for message in messages {
            for record in message.records {
                if let resultString = String(data: record.payload, encoding: .utf8) {
                    onNFCResult(true, resultString)
                }
            }
        }
    }
    
}


