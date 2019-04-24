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
    
    let UTC_ZONES : [(String, Double)] =
                            [
                                ("U.S. Minor Outlying Islands", -12),
                                ("French Polynesia", -11),
                                ("Honolulu", -10),
                                ("Marquesas Islands", -9.5),
                                ("Anchorage", -9),
                                ("Pacific Standard Time", -8),
                                ("Mountain Time", -7),
                                ("Central Standard Time", -6),
                                ("Eastern Standard Time", -5),
                                ("Santo Domingo/Halifax", -4),
                                ("Newfoundland", -3.5),
                                ("Argentina", -3),
                                ("Fernando de Noronha", -2),
                                ("Greenland/Ittoqqortoormiit", -1),
                                ("UTC Standard/GMT", 0),
                                ("Paris", 1),
                                ("Cairo", 2),
                                ("Moscow/Istanbul", 3),
                                ("Iran", 3.5),
                                ("Dubai", 4),
                                ("Afghanistan", 4.5),
                                ("Pakistan", 5),
                                ("India", 5.5),
                                ("Nepal", 5.75),
                                ("Bangladesh", 6),
                                ("Yangon", 6.5),
                                ("Bangkok/Ho Chi Minh City", 7),
                                ("Hong Kong", 8),
                                ("Eucla", 8.75),
                                ("Tokyo", 9),
                                ("Adelaide", 9.5),
                                ("Sydney", 10),
                                ("Lord Howe Island", 10.5),
                                ("Magadan", 11),
                                ("Aukland", 12),
                                ("Chatham Islands", 12.75),
                                ("Samoa", 13),
                                ("Kiribati", 14)
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
        let sign = UTC_ZONES[row].1 >= 0 ? "+" : ""
        let hour_part = Int(floor(UTC_ZONES[row].1 / 1))
        let minute_part = String.init(format: "%02d", abs(Int(UTC_ZONES[row].1.truncatingRemainder(dividingBy: 1)*60)))
        return UTC_ZONES[row].0 + " " + sign + "\(hour_part):\(minute_part)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        currentZone = row
    }
    
    func updateClock()
    {
        let date = Date().addingTimeInterval(TimeInterval(60 * 60 * UTC_ZONES[currentZone].1))
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
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
        timezonePicker.selectRow(currentZone, inComponent: 0, animated: true)
        updateClock()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        currentZone = 0
        for i in 0...UTC_ZONES.count-1 {
            if UTC_ZONES[i].1 == 0 {
                currentZone = i
            }
        }
    }
}
