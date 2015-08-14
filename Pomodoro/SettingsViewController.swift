//
//  SettingsViewController.swift
//  Pomodoro
//
//  Created by Shannon Coyne on 8/1/15.
//  Copyright (c) 2015 Shannon Coyne. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var model: SettingsDelegate!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var vibrateUISwitch: UISwitch! {
        didSet {
            if !model.vibrate {
                vibrateUISwitch.on = false
            }
        }
    }
    @IBOutlet weak var notificationsUISwitch: UISwitch! {
        didSet {
            if !model.notifications {
                notificationsUISwitch.on = false
            }
        }
    }
    
    @IBAction func vibrateSwitch(sender: UISwitch) {
        model.flipSwitch(SettingsModelKeys.vibrate)
        vibrateUISwitch.on = vibrateUISwitch.on
    }
    
    @IBAction func notificationsSwitch(sender: UISwitch) {
        model.flipSwitch(SettingsModelKeys.notifications)
        notificationsUISwitch.on = notificationsUISwitch.on
    }

    // MARK: - Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            // good stuff!
        } else {
            assertionFailure("sender and saveButton not the same object instance")
        }
    }

}
