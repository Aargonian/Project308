//
//  WorldClockViewController.swift
//  Project308
//
//  Created by Helton, Aaron S. on 4/19/19.
//  Copyright © 2019 Helton, Aaron S. All rights reserved.
//

import UIKit

class WorldClockViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var timezonePicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    
    let UTC_ZONES : [Int] = [
                                -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0,
                                1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
                            ]
    var currentZone = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return UTC_ZONES.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return "UTC " + (UTC_ZONES[row] >= 0 ? "+" : "") + String(UTC_ZONES[row])
    }
    
    func updateClock()
    {
        let date = Date().addingTimeInterval(TimeInterval(60 * 60 * UTC_ZONES[currentZone]))
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let timeString = String.init(format: "%02d:%02d:%02d", hour, minutes, seconds)
        clockLabel.text! = timeString
        
        //The following will kick off an asynchronous thread off the main event loop that will update the clock again, then kick another async thread off.
        //This is to prevent touch events and other UI events from blocking the clock, and the clock from blocking the Event thread.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateClock()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        updateClock()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentZone = UTC_ZONES.firstIndex(of: 0)!
    }
}
