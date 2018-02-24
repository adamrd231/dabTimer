//
//  ViewController.swift
//  dabTimer3.0
//
//  Created by Justin Reed on 9/29/17.
//  Copyright © 2017 RD concepts. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox  // vibrate the iphone
import GoogleMobileAds



protocol UpDownTimerViewControllerDelegate: class {
    func returnTimerToWorkWith(_ controller: UpDownTimerViewController, didFinishWithTimer timer: UpDownTimer)
}

class UpDownTimerViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var GoogleBannerView: GADBannerView!
    @IBOutlet weak var heatUpLabel: UILabel!
    @IBOutlet weak var coolDownLabel: UILabel!
    @IBOutlet weak var heatUpStepperOutlet: UIStepper!
    @IBOutlet weak var coolDownStepperOutlet: UIStepper!
    @IBOutlet weak var stopOutlet: UIButton!
    @IBOutlet weak var startOutlet: UIButton!
    
    var heatTimerFlashed = false
    var coolTimerFlashed = false
    
    var timer = Timer()
    
    //MARK:- Delegate and Timer Object
    // Inform this controller it has a delegate.
    weak var delegate: UpDownTimerViewControllerDelegate?
    // Create an UpDownTimer optional for the TimerTableViewController to fill
    var timerToWorkWith: UpDownTimer?
    
    var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        if let timerToWorkWith = timerToWorkWith {
            title = timerToWorkWith.name
            heatUpLabel.text = String(timerToWorkWith.heatUpTimer)
            heatUpStepperOutlet.value = Double(timerToWorkWith.heatUpTimer)
            coolDownLabel.text = String(timerToWorkWith.coolDownTimer)
            coolDownStepperOutlet.value = Double(timerToWorkWith.coolDownTimer)
            
        }
        
        //MARK:= google Adwords
        // Test AdMob Banner ID
        GoogleBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        
        // Live AdMob Banner ID
        //GoogleBannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        GoogleBannerView.rootViewController = self
        GoogleBannerView.load(GADRequest())

        //        do {
        //            let audioPath = Bundle.main.path(forResource: "text_notification", ofType: ".mp3")
        //            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        //        }
        //        catch {
        //            //ERROR
        //        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //disables sleep timer
        UIApplication.shared.isIdleTimerDisabled = true
 
    }
    

  
    //Mark:- Timer functionality
    
    @objc func Clock() {
        
        if let timerToWorkWith = timerToWorkWith {
            
            timerToWorkWith.runTimers(upDownTimer: timerToWorkWith, heat: heatUpLabel, cool: coolDownLabel, timer: timer)
            
            if heatTimerFlashed == false && heatUpLabel.text == "0" {
                heatTimerFlashed = true
                flash()
            }
            
            if coolTimerFlashed == false && coolDownLabel.text == "0" {
                coolTimerFlashed = true
                flash()
                reset()
            }
       
        }
    }
    
    
    //MARK:- UI Button Actions
    
    @IBAction func done(_ sender: Any) {
        
        if let timerToWorkWith = timerToWorkWith {
            
            if timerToWorkWith.timerIsRunning == true {
                return
            } else {

                timerToWorkWith.heatTimerSaved = timerToWorkWith.heatUpTimer
                timerToWorkWith.coolTimerSaved = timerToWorkWith.coolDownTimer
                timerToWorkWith.timerIsRunning = false
                
                timerToWorkWith.name = title!
                timerToWorkWith.heatUpTimer = Int(heatUpLabel.text!)!
                timerToWorkWith.coolDownTimer = Int(coolDownLabel.text!)!
                delegate?.returnTimerToWorkWith(self, didFinishWithTimer: timerToWorkWith)
            }
            
        }
        
    }
    
    
    @IBAction func start(_ sender: Any) {
        
        coolTimerFlashed = false
        heatTimerFlashed = false
        
        if let timerToWorkWith = timerToWorkWith {
            // Check to see if the timer is running
            if timerToWorkWith.timerIsRunning == false {
                // If not, start the timer and set timerIsRunning to true
                timerToWorkWith.timerIsRunning = true
                // Save the current timers to the saved variable, so if the user resets, it will save any changes to the timer
                timerToWorkWith.heatTimerSaved = timerToWorkWith.heatUpTimer
                timerToWorkWith.coolTimerSaved = timerToWorkWith.coolDownTimer
                // Run the timers using the clock function
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Clock), userInfo: nil, repeats: true)
                
            }
        }
        
    }
    
    @IBAction func heatUpStepper(_ sender: UIStepper) {
        
        if let timerToWorkWith = timerToWorkWith {
            timerToWorkWith.heatUpTimer = Int(sender.value)
            timerToWorkWith.heatUpTimer = Int(sender.value)
            heatUpLabel.text = String(timerToWorkWith.heatUpTimer)
        }
    }
    
    
    @IBAction func coolDownStepper(_ sender: UIStepper) {
        
        if let timerToWorkWith = timerToWorkWith {
            timerToWorkWith.coolDownTimer = Int(sender.value)
            coolDownLabel.text = String(timerToWorkWith.coolDownTimer)
        }
    }

   
    @IBAction func reset() {
        
        if let timerToWorkWith = timerToWorkWith {
            timerToWorkWith.resetTimers(upDownTimer: timerToWorkWith, heat: heatUpLabel, cool: coolDownLabel, timer: timer)
            heatUpStepperOutlet.value = Double(timerToWorkWith.heatUpTimer)
            coolDownStepperOutlet.value = Double(timerToWorkWith.coolDownTimer)
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
     //screen flash
        func flash() {
            if let wnd = self.view {
    
                var v = UIView(frame: wnd.bounds)
                v.backgroundColor = UIColor.white
                v.alpha = 1
    
                wnd.addSubview(v)
                UIView.animate(withDuration: 1.0, animations: {
                    v.alpha = 0.0
                }, completion: {(finished:Bool) in
                    print("inside")
                    v.removeFromSuperview()
                })
            }
        }

}
