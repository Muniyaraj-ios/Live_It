//
//  TrackingViewModel.swift
//  Live It
//
//  Created by MacBook on 26/09/24.
//

import Foundation
import AppTrackingTransparency

class TrackingViewModel{
    
    func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Tracking authorized")
                // Proceed with tracking
            case .denied:
                print("Tracking denied")
                // Handle denial
            case .notDetermined:
                print("Tracking not determined")
                // User has not made a choice yet
            case .restricted:
                print("Tracking restricted")
                // Tracking is restricted
            @unknown default:
                print("Unknown status")
            }
        }
    }

}
