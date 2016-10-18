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


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if UserDefaults.standard.object(forKey: kPlaySounds) == nil {
            UserDefaults.standard.set(true, forKey: kPlaySounds)
            UserDefaults.standard.synchronize()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @discardableResult
    final class func playSound(_ name: String) -> Bool {
        guard UserDefaults.standard.bool(forKey: kPlaySounds) else {
            return true
        }

        guard let sound = NSSound(named: name) else {
            NSLog("Failed to play sound with name \(name)")
            return false
        }

        return sound.play()
    }

}

