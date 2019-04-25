//
//  TimerViewController.swift
//  Project308
//
//  Created by Davis, Timothy A. on 4/19/19.
//  Copyright © 2019 Helton, Aaron S. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBAction func clearPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func startStopPressed(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    var times = [
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24],[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60],[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60]
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times[component].count
    }
    
    
    
    var isRunning = false
    var elapsedTime = 0.0
    
    func timeLoop() {
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
                
                let hourStr = String.init(format: "%d", hours)
                let minuteStr = String.init(format: "%02d", minutes)
                let secondsStr = String.init(format: "%02d", seconds)
                
                let timeString = "\(hourStr):\(minuteStr):\(secondsStr))"
                
                DispatchQueue.main.async {
                    self.timeLabel.text! = timeString
                }
                usleep(1000)
            }
        }
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
