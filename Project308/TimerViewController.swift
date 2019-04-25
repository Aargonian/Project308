//
//  TimerViewController.swift
//  Project308
//
//  Created by Davis, Timothy A. on 4/19/19.
//  Copyright © 2019 Helton, Aaron S. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var hour = 0.0
    var minute = 0.0
    var second = 0.0
    
    
    @IBAction func clearPressed(_ sender: UIButton) {
        hour = 0.0
        minute = 0.0
        second = 0.0
        timeLabel.text = "00:00:00"
    }
    
    @IBAction func startStopPressed(_ sender: UIButton) {
        if isRunning == false {
            isRunning = true
            startStopButton.setTitle("Stop", for: UIControl.State.normal)
        }
        else{
            isRunning = false
            startStopButton.setTitle("Start", for: UIControl.State.normal)
        }
    }
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return 99
        }
        else{
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hour = Double(timePicker.selectedRow(inComponent: 0))
        minute = Double(timePicker.selectedRow(inComponent: 1))
        second = Double(timePicker.selectedRow(inComponent: 2))
        let timeString = "\(hour):\(minute):\(second))"
        timeLabel.text! = timeString
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
                
                var hours = floor(self.hour-(self.elapsedTime/3600))
                var minutes = Int(self.minute-(self.elapsedTime/60)) % 60
                var seconds = Int(floor(self.second-self.elapsedTime))%60
                
                if seconds == 0{
                    if minutes != 0{
                        minutes -= 1
                        seconds = 60
                    }
                    else{
                        if hours != 0{
                            hours -= 1
                            minutes = 59
                            seconds = 60
                        }
                    }
                }
                if minutes == 0{
                    if hours != 0{
                        hours -= 1
                        minutes = 60
                    }
                }
                
                let hourStr = String.init(format: "%d", hours)
                let minuteStr = String.init(format: "%02d", minutes)
                let secondsStr = String.init(format: "%02d", seconds)
                
                let timeString = "\(hourStr):\(minuteStr):\(secondsStr))"
                
                DispatchQueue.main.async {
                    self.timeLabel.text! = timeString
                }
                
                if hours == 0 && minutes == 0 && seconds == 0{
                    let alertController = UIAlertController(title: "TIME IS UP",
                                                            message: "YOUR TIMER IS OVER",
                                                            preferredStyle: UIAlertController.Style.alert)
                    
                    let defaultAction = UIAlertAction(title: "STOP BEING LAZY",
                                                      style: UIAlertAction.Style.cancel,
                                                      handler: nil)
                    
                    // add the buttons into the alert controller object
                    alertController.addAction(defaultAction)
                    
                    // display
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.isRunning = false
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
