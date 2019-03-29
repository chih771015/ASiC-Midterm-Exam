//
//  ViewController.swift
//  Exam
//
//  Created by 姜旦旦 on 2019/3/29.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit
import AVKit

class MediaExamViewController: UIViewController {

    @IBOutlet weak var navigationBarVideo: UINavigationItem!
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //self.navigationController?.navigationBar.tintColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        
        player = AVPlayer(url: URL(string: "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4")!) // your video url
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
}

