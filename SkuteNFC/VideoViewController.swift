//
//  VideoViewController.swift
//  SkuteNFC
//
//  Created by Dan Griffiths on 2017-08-02.
//  Copyright © 2017 Dan Griffiths. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "NewBalanceBoots", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}
