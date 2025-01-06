//
//  CameraViewModel.swift
//  Live It
//
//  Created by Muniyaraj on 26/09/24.
//

import Foundation
import AVFoundation

final class CameraViewModel: ObservableObject{
    
    @Published var isCameraAuthorized: PermissionState = .none
    
    @Published var isAudiAuthorized: PermissionState = .none
    
    deinit {
        debugPrint(" \(String(describing: Self.self)) deinited")
    }
}

enum PermissionState{
    case granted
    case not_granted
    case none
}

// MARK:: CAMERA PERMISSION

extension CameraViewModel{
    func checkCameraAuthorization(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            isCameraAuthorized = .granted
            break
        case .notDetermined:
            requestCameraAccess()
            break
        case .denied,.restricted:
            isCameraAuthorized = .not_granted
            break
        @unknown default:
            isCameraAuthorized = .not_granted
            break
        }
    }
    
    private func requestCameraAccess(){
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async { [weak self] in
                self?.isCameraAuthorized = granted ? .granted : .not_granted
            }
        }
    }
}

// MARK:: AUDIO PERMISSION

extension CameraViewModel{
    func checkAudioAuthorization(){
        switch AVCaptureDevice.authorizationStatus(for: .audio){
        case .notDetermined:
            requestAudioAccess()
            break
        case .restricted, .denied:
            isAudiAuthorized = .not_granted
            break
        case .authorized:
            isAudiAuthorized = .granted
            break
        @unknown default:
            isAudiAuthorized = .none
            break
        }
    }
    
    private func requestAudioAccess(){
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async { [weak self] in
                self?.isAudiAuthorized = granted ? .granted : .not_granted
            }
        }
    }
}
