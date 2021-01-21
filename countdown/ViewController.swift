//
//  ViewController.swift
//  countdown
//
//  Created by Don  Browning on 1/15/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minseclabel: UILabel!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var nextAuctionLabel: UILabel!
    @IBOutlet weak var speechSwitch: UISwitch!
    
    
    private var _timer: Timer?
    private var _nextAuction: CountdownTime?
    private var _newNextAuction: CountdownTimer?
    
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
        
        // TODO: remove this and handle nil starting time
        _nextAuction = CountdownTime(hour: 23, minutes: 24, seconds: 59)
        
        nextAuctionLabel.text = "No time set!"
        
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    }
    
    
    @IBAction func dateRefactor(_ sender: Any) {

        guard let ct = _newNextAuction else {
            print("The auction isn't set")
            return
        }
        
        let friendlyTime = ct.getDisplayTime()
        
        let now = ct.getNowAsSeconds()
        let stored = ct.getGoalTotalSeconds()
        let hh = ct.getGoalHours()
        let mm = ct.getGoalMinutes()
        let ss = ct.getGoalSeconds()
        
        print("Friendly time: \(friendlyTime)")
        print("Now: \(now) Stored: \(stored)")
        print("Goal Hours: \(hh)")
        print("Goal Minutes: \(mm)")
        print("Goal Seconds: \(ss)")
        
        
        let n = Date()
        
        let secondsRemaining = ct.diff(currentTime: n)
        print("secondsRemaining: \(secondsRemaining)")
        
        
    }
    
    @IBAction func setTimeAction(_ sender: Any) {
        
        let h = hourTextField.text ?? ""
        let m = minutesTextField.text ?? ""
        let s = secondsTextField.text ?? ""
        
        print("\(h): \(m) : \(s)")
        let hValid = Int(h) != nil
        let mValid = Int(m) != nil
        let sValid = Int(s) != nil
        
        var alert: UIAlertController
        if hValid && mValid && sValid {
            setAuctionTime(h: Int(h), m: Int(m), s: Int(s))
            
            alert = UIAlertController(title: "Success!", message: "The auction time was set", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            clearTimes()
            
        } else {
            alert = UIAlertController(title: "Failed!", message: "The input is invalid", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        
        
        self.present(alert, animated: true)
        
    }

    private func setAuctionTime(h: Int?, m: Int?, s: Int?) {
        print("Setting auction time for: \(h!):\(m!):\(s!)")
        
        _nextAuction = CountdownTime(hour: h!, minutes: m!, seconds: s!)
        
        _newNextAuction = CountdownTimer(hour: h!, minutes: m!, seconds: s!)
        
        let mins = m! < 10 ? doubleUp(t: m!) : String(m!)
        let secs = s! < 10 ? doubleUp(t: s!) : String(s!)
        
        nextAuctionLabel.text = "\(h!):\(mins):\(secs)"
    }

    @objc func fireTimer() {
        //fetchCurrentTime()
        
        newFetchCurrentTime()
        
    }
    
    private func clearTimes() {
        print("clear it out ")
        
        hourTextField.text = ""
        minutesTextField.text = ""
        secondsTextField.text = ""
        
        secondsTextField.resignFirstResponder()
        minutesTextField.resignFirstResponder()
        hourTextField.resignFirstResponder()
        
    }
    

    private func newFetchCurrentTime() {
        /*
        guard let nextAuction = _newNextAuction else {
            print("there is no action set")
            return
        }
        */
        //let now = nextAuction.getNowAsSeconds()
        let now = Date()
        //let secondsRemaining = nextAuction.diff(currentTime: now)
        
        // if there is now current auction set, then send -9999
        // to the display method
        let secondsRemaining: Int
        if let nextAuction = _newNextAuction {
            secondsRemaining = nextAuction.diff(currentTime: now)
        } else {
            secondsRemaining = -9999
        }
        
        displayTime(secondsRemaining: secondsRemaining, now: now)
        
        
    }
    
    private func displayTime(secondsRemaining: Int, now: Date) {
        // if -9999 is sent, there is no auction going, so just
        // paint the time... if other value, then one is one and
        // need to do all the fancy things
        
        // TODO: - CHECK FOR -9999 AND DO DISPLAY/SPEACH STUFF IF TRUE
        
        let calendar = Calendar.current
        let h = calendar.component(.hour, from: now)
        let m = calendar.component(.minute, from: now)
        let s = calendar.component(.second, from: now)
        
        hourLabel.text = String(h)
        let secs = doubleUp(t: s)
        let minsec = "\(m):\(secs)"
        minseclabel.text = minsec
        
    }
    
    private func fetchCurrentTime() {
        let date = Date()
        let calendar = Calendar.current
        
        let h = calendar.component(.hour, from: date)
        let m = calendar.component(.minute, from: date)
        let s = calendar.component(.second, from: date)
        
        // print("Time: \(h) : \(m) : \(s)")
        
        var currTime = CountdownTime(hour: h, minutes: m, seconds: s)
        
        
        formatTime(&currTime)
    }
    
    private func formatTime(_ currTime: inout ViewController.CountdownTime) {
        var inTheHour = false
        var inTheMinute = false
        
        if currTime.hour == _nextAuction?.hour {
            currTime.hourColor = .systemRed
            inTheHour = true
        } else {
            currTime.hourColor = .black
            inTheHour = false
        }
        
        
        // finally format the string and paint screen
        hourLabel.text = String(currTime.hour)
        hourLabel.textColor = currTime.hourColor
        
        // Do the minute stuff
        if ((currTime.minutes == _nextAuction?.minutes) && inTheHour) {
            print("we're getting close!!!!!")
            currTime.minutesColor = .red
            inTheMinute = true
        } else {
            currTime.minutesColor = .black
            inTheMinute = false
        }
        
        // This will be more complex soon
        if (inTheMinute) {
            currTime.secondsColor = .red
            
            if speechSwitch.isOn {
                speakCountdown(whatToSay: String(currTime.seconds))
            }
            
            
        } else {
            currTime.secondsColor = .black
        }
        
        var strSeconds: String?
        if currTime.seconds < 10 {
            strSeconds = doubleUp(t: currTime.seconds)
        } else {
            strSeconds = String(currTime.seconds)
        }
        
        //TODO: break this into a minute and second label
        let minsec = String(currTime.minutes) + ":" + strSeconds!
        minseclabel.textColor = currTime.minutesColor
        minseclabel.text = minsec
    }
    

    
    private func doubleUp(t: Int) -> String {
        if t < 10 {
            return "0" + String(t)
        } else {
            return String(t)
        }
        
    }
    
    private func speakCountdown(whatToSay: String) {
        print("Speak: \(whatToSay)")
        
        let utterance = AVSpeechUtterance(string: whatToSay)
        utterance.rate = 0.57
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        
        let voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.voice = voice
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

}

/*
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        
        return false
    }
}


extension ViewController  {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard())
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
*/
