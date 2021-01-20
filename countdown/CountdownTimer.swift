//
//  CountdownTimer.swift
//  countdown
//
//  Created by Don  Browning on 1/20/21.
//

import Foundation


public class CountdownTimer {
    private var _date: Date?
    
    
    init(date: Date) {
        _date = date
    }
    
    init (hour: Int, minutes: Int, seconds: Int){
        // The formatter for the instance var _date
        // I have now doubt there is an easier way lol
       
        let storedDF = setupDateFormatter(formatString: "yyyy/MM/dd HH:mm:ss")
        
        // Use today as the date, so get the year, month, day
        let today = Date()
        let df = setupDateFormatter(formatString: "yyyy")
        let year = df.string(from: today)
        
        df.dateFormat = "MM"
        let month = df.string(from: today)
        
        df.dateFormat = "dd"
        let day = df.string(from: today)
        
        
        // Create the stored time
        let dateString = "\(year)/\(month)/\(day) \(hour):\(minutes):\(seconds)"
        print("DateString for saved time: \(dateString)")
        let time = storedDF.date(from: dateString)
        
        if let time = time {
            print("successfully saved time!")
            _date = time
        }
    }
    
    public func getFriendlyTime() -> String {
        let df = setupDateFormatter(formatString: "HH:mm:ss")
        
        let t = df.string(from: _date!)
        
        return t
        
    }
    
    public func getGoalHours() -> Int {
        let df = setupDateFormatter(formatString: "HH")
        
        let t = df.string(from: _date!)
        if let intTime = Int(t) {
            return intTime
        } else {
            return -1
        }
        
        
    }
    public func getNowAsSeconds() -> Int {
        let d = Date()
        let secs = d.timeIntervalSinceReferenceDate
        
        return Int(secs)
        
    }
    
    // returns 0 if fails
    public func goalSeconds() -> Int {
        if let secs = _date?.timeIntervalSinceReferenceDate {
            return Int(secs)
        } else {
            return 0
        }
    }
    
    
    private func setupDateFormatter(formatString: String) -> DateFormatter {
        let df = DateFormatter()
        df.locale = NSLocale.current
        df.timeZone = .current
        df.dateFormat = formatString
        
        return df
    }
    
}
