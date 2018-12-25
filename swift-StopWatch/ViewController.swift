//
//  ViewController.swift
//  swift-StopWatch
//
//  Created by nsuhara on 2018/11/17.
//  Copyright © 2018 nsuhara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTimerMMSS: UILabel!
    @IBOutlet weak var labelTimerSSS: UILabel!
    @IBOutlet weak var labelStart: UIButton!
    @IBOutlet weak var labelStop: UIButton!
    @IBOutlet weak var labelReset: UIButton!
    @IBOutlet weak var labelGrade: UILabel!
    @IBOutlet weak var labelBestSSS: UILabel!
    
    var objTimeInterval: TimeInterval? = nil
    var objTimer: Timer? = nil
    var dElapsedTime: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.labelTitle.layer.cornerRadius = self.labelTitle.bounds.width / 20
        self.labelTitle.layer.masksToBounds = true
        setButtonEnabled(bStart: true, bStop: false, bReset: false)
    }

    func setButtonEnabled(bStart: Bool, bStop: Bool, bReset: Bool) {
        self.labelStart.isEnabled = bStart
        self.labelStop.isEnabled = bStop
        self.labelReset.isEnabled = bReset
    }
    
    @objc func callbackTimer() {
        if let objTimeInterval = self.objTimeInterval {
            let dTime: Double = Date.timeIntervalSinceReferenceDate - objTimeInterval + self.dElapsedTime
            let intMM = Int(dTime / 60)
            let intSS = Int(dTime) % 60
            let intSSS = Int((dTime - Double(intMM * 60) - Double(intSS)) * 100.0)
            
            self.labelTimerMMSS.text = String(format: "%02d:%02d:", intMM, intSS)
            self.labelTimerSSS.text = String(format: "%02d", intSSS)
        }
    }
    
    func setGrede() {
        switch Int(self.labelTimerSSS.text!) ?? 99 {
        case 0:
            self.labelGrade.text = "You are ヲタク!"
        case 1...5:
            self.labelGrade.text = "You are 鉄人!"
        case 6...20:
            self.labelGrade.text = "You are エリート!"
        default:
            self.labelGrade.text = "You are 平民!"
        }
    }
    
    func setBestSSS() {
        if Int(self.labelTimerSSS.text!) ?? 99 < Int(self.labelBestSSS.text!) ?? 99 {
            self.labelBestSSS.text = self.labelTimerSSS.text
        }
    }
    
    @IBAction func buttonStart(_ sender: Any) {
        setButtonEnabled(bStart: false, bStop: true, bReset: false)
        // Set start time.
        self.objTimeInterval = Date.timeIntervalSinceReferenceDate
        // Set timer.
        self.objTimer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.callbackTimer),
            userInfo: nil,
            repeats: true)
    }
    
    @IBAction func buttonStop(_ sender: Any) {
        setButtonEnabled(bStart: true, bStop: false, bReset: true)
        if let objTimeInterval = self.objTimeInterval {
            self.dElapsedTime += Date.timeIntervalSinceReferenceDate - objTimeInterval
        }
        if let objTimer = self.objTimer {
            objTimer.invalidate()
        }
        setGrede()
        setBestSSS()
    }
    
    @IBAction func buttonReset(_ sender: Any) {
        setButtonEnabled(bStart: true, bStop: false, bReset: false)
        self.objTimeInterval = nil
        self.objTimer = nil
        self.labelTimerMMSS.text = String(format: "%02d:%02d:", 0, 0)
        self.labelTimerSSS.text = String(format: "%02d", 0)
        self.dElapsedTime = 0.0
        self.labelGrade.text = "評価"
        self.labelBestSSS.text = String(format: "%02d", 99)
    }
    
}

