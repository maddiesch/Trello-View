//
//  AppDelegate.swift
//  Trello View
//
//  Created by Skylar Schipper on 3/4/16.
//  Copyright © 2016 Ministry Centered. All rights reserved.
//

import Cocoa

let kPlaySounds = "playSounds"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if NSUserDefaults.standardUserDefaults().objectForKey(kPlaySounds) == nil {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: kPlaySounds)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }

    final class func playSound(name: String) -> Bool {
        guard NSUserDefaults.standardUserDefaults().boolForKey(kPlaySounds) else {
            return true
        }

        guard let sound = NSSound(named: name) else {
            NSLog("Failed to play sound with name \(name)")
            return false
        }

        return sound.play()
    }

}

