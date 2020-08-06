//
//  MoviePlayViewController.swift
//  MovieApp
//
//  Created by Rana Amer on 7/28/20.
//  Copyright © 2020 Hamza. All rights reserved.
//

import UIKit
import AVKit

class MoviePlayViewController: UIViewController {
    
    // Required View Variables
    let vcPlayer = AVPlayerViewController()
    
    // Required Business logic variables
    var movieURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        playMovie()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playMovie()
    }
    
    func playMovie() {
        if let url = movieURL {
            let player = AVPlayer(url: url)
            vcPlayer.player = player
            vcPlayer.showsPlaybackControls = false
            self.present(vcPlayer, animated: true, completion: {
                /// player.play()
            })
        }
    }

}
