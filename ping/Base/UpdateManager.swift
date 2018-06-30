//
//  UpdateManager.swift
//  ping
//
//  Created by Michael Fröhlich on 30.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import Foundation
import Siren

class UpdateManager {
    
    static func setup() {
        
        /* Siren code should go below window?.makeKeyAndVisible() */
        
        // Siren is a singleton
        let siren = Siren.shared
        
        // Optional: Defaults to .option
        siren.alertType = .skip
        
        // Optional: Change the various UIAlertController and UIAlertAction messaging. One or more values can be changes. If only a subset of values are changed, the defaults with which Siren comes with will be used.
        siren.alertMessaging = SirenAlertMessaging(updateTitle: "Update Available",
                                                   updateMessage: "A new version of Ping is available.",
                                                   updateButtonMessage: "Update now",
                                                   nextTimeButtonMessage: "Remind me later ",
                                                   skipVersionButtonMessage: "Skip this version")
        
        // Optional: Set this variable if you would only like to show an alert if your app has been available on the store for a few days.
        // This default value is set to 1 to avoid this issue: https://github.com/ArtSabintsev/Siren#words-of-caution
        // To show the update immediately after Apple has updated their JSON, set this value to 0. Not recommended due to aforementioned reason in https://github.com/ArtSabintsev/Siren#words-of-caution.
        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 3
        
        // Replace .immediately with .daily or .weekly to specify a maximum daily or weekly frequency for version checks.
        // DO NOT CALL THIS METHOD IN didFinishLaunchingWithOptions IF YOU ALSO PLAN TO CALL IT IN applicationDidBecomeActive.
        siren.checkVersion(checkType: .immediately)
        
    }
    
    static func checkVersionRegularly() {
        
        /*
         Perform daily (.daily) or weekly (.weekly) checks for new version of your app.
         Useful if user returns to your app from the background after extended period of time.
         Place in applicationDidBecomeActive(_:).    */
        
        Siren.shared.checkVersion(checkType: .daily)
        
    }
    
    static func checkVersionImmediately() {
        
        /*
         Useful if user returns to your app from the background after being sent to the
         App Store, but doesn't update their app before coming back to your app.
         
         ONLY USE WITH Siren.AlertType.immediately
         */
        
        Siren.shared.checkVersion(checkType: .immediately)
        
    }
    
}
