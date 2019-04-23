//
//  StopwatchViewController.swift
//  Project308
//
//  Created by Davis, Timothy A. on 4/19/19.
//  Copyright © 2019 Helton, Aaron S. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {
    @IBOutlet weak var lapTimeTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var clearLastLapButton: UIButton!
    @IBOutlet weak var clearAllLapsButton: UIButton!
    @IBOutlet weak var clearTimesButton: UIButton!
    
    var elapsedTime : Double = 0
    var isRunning : Bool = false
    
    
    func timeLoop()
    {
        DispatchQueue.global(qos: .background).async {
            var currentTime = Date()
            var previousTime = currentTime
            while(self.isRunning) {
                currentTime = Date()
                self.elapsedTime += currentTime.timeIntervalSince(previousTime)
                previousTime = currentTime
                
                let hours = floor(self.elapsedTime/3600)
                let minutes = Int((self.elapsedTime/60)) % 60
                let seconds = Int(floor(self.elapsedTime))%60
                let millis = Int(floor((self.elapsedTime * 1000))) % 1000
                
                let hourStr = String.init(format: "%d", hours)
                let minuteStr = String.init(format: "%02d", minutes)
                let secondsStr = String.init(format: "%02d", seconds)
                let millisStr = String.init(format: "%03d", millis)
                let timeString = "\(hourStr):\(minuteStr):\(secondsStr).\(millisStr)"
                print("TimeSTR: " + timeString)
                DispatchQueue.main.async {
                    self.timeLabel.text! = timeString
                }
                usleep(1000)
            }
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startButton.isEnabled = false
        lapButton.isEnabled = true
        stopButton.isEnabled = true
        
        isRunning = true
        timeLoop()
    }
    
    @IBAction func labButtonPressed(_ sender: UIButton) {
        clearLastLapButton.isEnabled = true
        clearAllLapsButton.isEnabled = true
        
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        startButton.isEnabled = true
        stopButton.isEnabled = false
        clearTimesButton.isEnabled = true
        
        isRunning = false
        
    }
    
    @IBAction func clearLastLapButtonPressed(_ sender: UIButton) {
        if lapTimeTextView.text! == "" {
            clearLastLapButton.isEnabled = false
            clearAllLapsButton.isEnabled = false
        } else {
            
        }
    }
    
    @IBAction func clearAllLapsButtonPressed(_ sender: UIButton) {
        clearLastLapButton.isEnabled = false
        clearAllLapsButton.isEnabled = false
        
        lapTimeTextView.text! = ""
    }
    
    @IBAction func clearTimeButtonPressed(_ sender: UIButton) {
        startButton.isEnabled = true
        elapsedTime = 0
        timeLabel.text! = "0:00:00.000"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
