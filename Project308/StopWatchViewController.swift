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
    
    // Variable calls for variables that we will use throughout the program follow:
    var elapsedTime : Double = 0
    var isRunning : Bool = false
    
    /*
     * Timeloop is responsible for actually keeping track of the timer. It spins up
     * a background thread using the DispatchQueue, and keeps track of elapsed time
     * using the built-in NSDate classes. Because we use a currentTime and a
     * previousTime date, we can avoid the problem of time incrementing when the timer
     * is stopped.
     *
     * After each run, we request the DispatchThread update the time label on the main
     * thread asynchronously, when possible, since it's impossible to update the UI
     * from a background thread.
     */
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
                let millis = Int(floor((self.elapsedTime * 1000))) % 1000
                
                let hourStr = String.init(format: "%d", hours)
                let minuteStr = String.init(format: "%02d", minutes)
                let secondsStr = String.init(format: "%02d", seconds)
                let millisStr = String.init(format: "%03d", millis)
                
                let timeString = "\(hourStr):\(minuteStr):\(secondsStr).\(millisStr)"
                
                DispatchQueue.main.async {
                    self.timeLabel.text! = timeString
                }
                usleep(1000)
            }
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        /*
         * Since the time is now ticking, we can enable the buttons that
         * allow stopping the timer and adding a lap time. However, we need to
         * disable the button that starts the timer
         */
        startButton.isEnabled = false
        lapButton.isEnabled = true
        stopButton.isEnabled = true
        
        /* We set the condition that keeps the while loop running to true,
        then call timeLoop() to start the stopwatch */
        isRunning = true
        timeLoop()
    }
    
    @IBAction func labButtonPressed(_ sender: UIButton) {
        /*
         * Since there is now at least one lap, we can enable the buttons
         * that allow laps to be cleared
         */
        clearLastLapButton.isEnabled = true
        clearAllLapsButton.isEnabled = true
        
        /* The following will add (currentTime + newLine) to the lap time
        text view */
        lapTimeTextView.text! += (timeLabel.text! + "\n")
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        /*
         * Since the time is not ticking, we need to re-enable the start button
         * and disable the stop button. We also need to enable the Clear Time button
         * since we know that the time is non-zero after pressing stop
         */
        startButton.isEnabled = true
        stopButton.isEnabled = false
        clearTimesButton.isEnabled = true
        
        // Setting isRunning to false will stop the timeLoop() function
        isRunning = false
    }
    
    @IBAction func clearLastLapButtonPressed(_ sender: UIButton) {
        /*
         * First, we must separate the string in lapTimesTextView.text! by
         * new line. Afterwards, we can remove the last value, effectively deleting
         * it. Then we set lapTimeTextView.text! equal to what's left over + a new l
         * line
         */
        if !lapTimeTextView.text!.isEmpty {
            var lapList = lapTimeTextView.text!.split(separator: "\n")
            lapList.popLast()
            lapTimeTextView.text! = lapList.joined(separator: "\n") + "\n"
        }
        /*
         * If, after clearing the last lap, there are no lap times, then we need to
         * disable both clear lap buttons
         */
        if lapTimeTextView.text!.isEmpty{
            clearLastLapButton.isEnabled = false
            clearAllLapsButton.isEnabled = false
        }
    }
    
    @IBAction func clearAllLapsButtonPressed(_ sender: UIButton) {
        // If all laps are cleared, then there will be no more laps to delete
        clearLastLapButton.isEnabled = false
        clearAllLapsButton.isEnabled = false
        
        // Simply empties the lapTimeTextView
        lapTimeTextView.text! = ""
    }
    
    @IBAction func clearTimeButtonPressed(_ sender: UIButton) {
        /*
         * At this point, we'll need to enable the start button, then
         * disable the stop and lap buttons.
         */
        startButton.isEnabled = true
        lapButton.isEnabled = false
        stopButton.isEnabled = false
        
        /*
         * If the time is cleared, we need to reset the values to what they were
         * when the user started the application
         */
        elapsedTime = 0
        timeLabel.text! = "0:00:00.000"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
