//
//  PomodoroViewController.swift
//  Pomodoro
//
//  Created by Shannon Coyne on 8/1/15.
//  Copyright (c) 2015 Shannon Coyne. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox // vibrate

class PomodoroViewController: UIViewController {
    var observer: NSObjectProtocol?
    
    var pomodoro: Pomodoro! { // Singular Pomodoro attributes are passed in from the TableViewController and are fixed in this view (no editing functionality, no selecting a different pomodoro once you're here). Hence, I've just a passed in a struct (value type) and not the whole model ref typically stored in a delegate variable.
        didSet {
            timerModel = TimerModel(sLength: pomodoro.intervalLength, bLength: pomodoro.breakLength, numberIntervals: pomodoro.numIntervals)
        }
    }
    
    var timerModel: TimerModel! {
        didSet { startTimerModelListener() }
    }
    
    var settingsModel: SettingsDelegate!
    
    @IBOutlet weak var sprintLabel: UILabel! {
        didSet { sprintLabel.text = "Interval \(timerModel.currentInterval) of \(pomodoro.numIntervals)" } // initial value only.
    }
    @IBOutlet weak var pauseStartButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.text = String(format: "%02d:00", pomodoro.intervalLength)
        }
    }
    @IBOutlet weak var timerProgressView: UIProgressView! {
        didSet {
            timerProgressView.progress = 0.0 // initial value only. the timer will trigger progression.
        }
    }
    
    @IBAction func startPauseButtonPressed(sender: UIButton) {
        if timerModel.isActive { // user wishes to pause
            timerModel.pauseTimer()
        } else { // user wishes to (re)start
            println("starting timer, from pomodoroviewcontroller")
            timerModel.startTimer()
        }
    }
    
    func disableStartPauseButtonAndUpdateIntervalLabel() {
        sprintLabel.text = "Completed \(pomodoro.numIntervals) Intervals"
        pauseStartButton.setTitle("Done!", forState: .Disabled)
    }
    
    func updateTimerLabel() {
        // countdown label text
        timerLabel.text = String(format: "%02d:%02d", timerModel.minutes, timerModel.seconds)
        
        // progress bar
        timerProgressView.progress = timerModel.progress
    }
    
    func updatePauseStartButtonText(statusString: String) {
        pauseStartButton.setTitle(statusString, forState: .Normal)
    }
    
    func startTimerModelListener() {
        let center = NSNotificationCenter.defaultCenter()
        let uiQueue = NSOperationQueue.mainQueue()
        
        observer = center.addObserverForName(TimerModelMessages.notificationName, object: timerModel, queue: uiQueue) {
            [unowned self]
            (notification) in
            if let message = notification.userInfo?[TimerModelMessages.notificationEventKey] as? String {
                self.handleNotification(message) //
            }
            else {
                assertionFailure("No message found in notification")
            }
        }
    }
    
    func updateSprintLabel() {
        if timerModel.isBreak {
            sprintLabel.text = "Break \(timerModel.currentBreak) of \(timerModel.numIntervals - 1)"
        } else {
            sprintLabel.text = "Interval \(timerModel.currentInterval) of \(timerModel.numIntervals)"
        }
    }
    
    func vibrate() {
        if settingsModel.vibrate {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    func handleNotification(message: String) {
        switch message {
        case TimerModelMessages.countdownDecrement:
            updateTimerLabel()
        case TimerModelMessages.timerDidStart:
            updatePauseStartButtonText("Pause")
        case TimerModelMessages.timerDidPause:
            updatePauseStartButtonText("Start")
        case TimerModelMessages.breakDidEnd, TimerModelMessages.intervalDidEnd:
            updateSprintLabel()
            vibrate()
        case TimerModelMessages.pomodoroDidFinish:
            disableStartPauseButtonAndUpdateIntervalLabel()
        default:
            assertionFailure("Unexpected message: \(message)")
        }
    }
}
