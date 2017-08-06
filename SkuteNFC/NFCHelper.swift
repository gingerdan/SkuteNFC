//
//  NFCHelper.swift
//  SkuteNFC
//
//  Created by Dan Griffiths on 2017-07-27.
//  Copyright © 2017 Dan Griffiths. All rights reserved.
//

import Foundation
import CoreNFC
import UIKit


class NFCHelper: NSObject, NFCNDEFReaderSessionDelegate {
    var onNFCResult: ((Bool, String) -> ())?
    let storyboard = UIStoryboard(name: "ChannelView", bundle: nil)
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

        //fireUrl()
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

