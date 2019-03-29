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
    
    enum ButtonImage: String {
        case play = "play_button"
        case pause = "stop"
    }
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var seachButton: UIButton!
    @IBAction func seachAction() {
        
        
        self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.player = nil
        videoPlay = false
        playButton.setImage(UIImage(named:String(ButtonImage.play.rawValue)), for: .normal)
        guard let title = textField.text else {return}
        guard let url = URL(string: title) else {return}
        let playerItem = AVPlayer(url: url)
        self.player = playerItem
        let playerLayer = AVPlayerLayer(player: playerItem)
        playerLayer.frame = view.bounds
        self.playerLayer = playerLayer
        videoSubView.layer.addSublayer(playerLayer)
    }
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playAction() {
        
        if  videoPlay {
            
            player?.pause()
            videoPlay = !videoPlay
            playButton.setImage(UIImage(named:String(ButtonImage.play.rawValue)), for: .normal)
        } else {
            
            player?.play()
            videoPlay = !videoPlay
            playButton.setImage(UIImage(named:String(ButtonImage.pause.rawValue)), for: .normal)
        }
        
    }
    @IBAction func forwardAction() {
        
    }
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBAction func backAction() {
        
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var fullSizeButton: UIButton!
    @IBAction func fullSize(_ sender: Any) {
    }
    
    
    @IBOutlet weak var muteButton: UIButton!
    @IBAction func muteAction() {
        
    }
    @IBOutlet weak var videoSubView: UIView!
    @IBOutlet weak var navigationBarVideo: UINavigationItem!
    var player:AVPlayer? = AVPlayer()
    var playerLayer:AVPlayerLayer? = AVPlayerLayer()
    var videoPlay = false
    
    
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
        playerLayer?.frame = view.bounds
        
        videoSubView.layer.addSublayer(playerLayer!)
       
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
    }
    
}

