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
        case mute = "volume_off"
        case muteNo = "volume_up"
        case full = "full_screen_button"
        case noFull = "full_screen_exit"
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var seachButton: UIButton!
    @IBAction func seachAction() {
        
        timeSlider.value = 0
        nowTimeLabel.text = "00:00"
        self.muteButton.setImage(UIImage(named: ButtonImage.muteNo.rawValue), for: .normal)
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
        
        let duration = playerItem.asset.duration
        let seconds = CMTimeGetSeconds(duration)
        endTimeLabel.text = formatConversion(time: seconds)
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(seconds)
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
        
        guard let player = self.player else {
            return
        }
        
        if  videoPlay {
            
            player.pause()
            videoPlay = !videoPlay
            playButton.setImage(UIImage(named:String(ButtonImage.play.rawValue)), for: .normal)
        } else {
            
            player.play()
            videoPlay = !videoPlay
            playButton.setImage(UIImage(named:String(ButtonImage.pause.rawValue)), for: .normal)
        }
        
    }
    
    @IBOutlet weak var playButtonAndSafeAreaConstraint: NSLayoutConstraint!
    
    @IBAction func forwardAction() {
        
        guard let player = self.player else {
            return
        }
 
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let addTime = currentTime + Float64(10)
        let intTime = CMTime(seconds: addTime, preferredTimescale: 1)
        player.seek(to: intTime)
    }
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBAction func backAction() {
        
        guard let player = self.player else {
            return
        }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let addTime = currentTime - Float64(10)
        let intTime = CMTime(seconds: addTime, preferredTimescale: 1)
        player.seek(to: intTime)
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fullSizeButton: UIButton!
    @IBAction func fullSize(_ sender: Any) {
        
        if UIDevice.current.orientation.isLandscape {
            
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        } else {
            
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }
    
    
    @IBOutlet weak var muteButton: UIButton!
    @IBAction func muteAction() {
        guard let player = self.player else {
            return
        }
        
        if player.isMuted {
            
            muteButton.setImage(UIImage(named: ButtonImage.muteNo.rawValue), for: .normal)
            player.isMuted = !player.isMuted
           
        } else {

            muteButton.setImage(UIImage(named: ButtonImage.mute.rawValue), for: .normal)
            player.isMuted = !player.isMuted
        }
    }
    
    @IBOutlet weak var videoSubView: UIView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var sliderAndPlayButtonConstraint: NSLayoutConstraint!
    
    @IBAction func changeTime(_ sender: Any) {
        
        let seconds = Int64(timeSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player?.seek(to: targetTime)
    }
    
    @IBOutlet weak var nowTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var navigationBarVideo: UINavigationItem!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var videoPlay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
 
        // Do any additional setup after loading the view, typically from a nib.
        timeSlider.value = 0
        deviceStatusSetting()
        
        AVAudioSession.sharedInstance().outputVolume
               
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [unowned self]_ in
            
            self.playerLayer?.frame = self.view.bounds
            self.deviceStatusSetting()
        }, completion: { [unowned self]_ in
            
        })
        
        
    }
    
    private func deviceStatusSetting() {
        
        if UIDevice.current.orientation.isLandscape {
            
            self.navigationController?.isNavigationBarHidden = true
            self.fullSizeButton.setImage(UIImage(named: ButtonImage.noFull.rawValue), for: .normal)
        
        } else {
            
            self.navigationController?.isNavigationBarHidden = false
            self.fullSizeButton.setImage(UIImage(named: ButtonImage.full.rawValue), for: .normal)
        }
    }
    
    
    private func formatConversion(time:Float64) -> String {
        
        let songLength = Int(time)
        let minutes = Int(songLength / 60)
        let seconds = Int(songLength % 60)
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

