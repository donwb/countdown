//
//  ViewController.swift
//  countdown
//
//  Created by Don  Browning on 1/15/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minseclabel: UILabel!
    
    private var _timer: Timer?
    private var _nextAuction: CountdownTime?
    
    private struct CountdownTime {
        var hour: Int
        var hourColor: UIColor?
        var minutes: Int
        var minutesColor: UIColor?
        var seconds: Int
        var secondsColor: UIColor?
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        _nextAuction = CountdownTime(hour: 14, minutes: 45, seconds: 59)
        
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    }

    @objc func fireTimer() {
        fetchCurrentTime()
    }
    
    

    private func fetchCurrentTime() {
        let date = Date()
        let calendar = Calendar.current
        
        let h = calendar.component(.hour, from: date)
        let m = calendar.component(.minute, from: date)
        let s = calendar.component(.second, from: date)
        
        print("Time: \(h) : \(m) : \(s)")
        
        var currTime = CountdownTime(hour: h, minutes: m, seconds: s)
        
        
        formatTime(&currTime)
    }
    
    private func formatTime(_ currTime: inout ViewController.CountdownTime) {
        if currTime.hour == _nextAuction?.hour {
            print("within an hour yo")
            currTime.hourColor = .systemRed
        }
        
        
        // finally format the string and paint screen
        hourLabel.text = String(currTime.hour)
        hourLabel.textColor = currTime.hourColor
        var strSeconds: String?
        if currTime.seconds < 10 {
            strSeconds = doubleUp(t: currTime.seconds)
        } else {
            strSeconds = String(currTime.seconds)
        }
        
        let minsec = String(currTime.minutes) + ":" + strSeconds!
        minseclabel.text = minsec
    }
    

    
    private func doubleUp(t: Int) -> String {
        return "0" + String(t)
    }

}

