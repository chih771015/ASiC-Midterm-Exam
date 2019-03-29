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
        
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        self.playerLayer = playerLayer
        videoSubView.layer.addSublayer(playerLayer)
        
        // 抓取 playItem 的 duration
        let duration = playerItem.asset.duration
        // 把 duration 轉為我們歌曲的總時間（秒數）。
        let seconds = CMTimeGetSeconds(duration)
        // 把我們的歌曲總時長顯示到我們的 Label 上。
        endTimeLabel.text = formatConversion(time: seconds)
        timeSlider.minimumValue = 0
        // 更新 Slider 的 maximumValue。
        timeSlider.maximumValue = Float(seconds)
        // 這裡看個人需求，如果想要拖動後才更新進度，那就設為 false；如果想要直接更新就設為 true，預設為 true。
        timeSlider.isContinuous = true
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] (CMTime) in
            if self?.player?.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self!.player!.currentTime())
                self?.timeSlider.value = Float(currentTime)
                self?.nowTimeLabel.text = self?.formatConversion(time: currentTime)
            }
        })
       
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
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var nowTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    
    
    
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
       
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
    }
    
    
    func formatConversion(time:Float64) -> String {
        let songLength = Int(time)
        let minutes = Int(songLength / 60) // 求 songLength 的商，為分鐘數
        let seconds = Int(songLength % 60) // 求 songLength 的餘數，為秒數
        var time = ""
        if minutes < 10 {
            time = "0\(minutes):"
        } else {
            time = "\(minutes)"
        }
        if seconds < 10 {
            time += "0\(seconds)"
        } else {
            time += "\(seconds)"
        }
        return time
    }
}

