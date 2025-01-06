//
//  ImagePickerViewModel.swift
//  Live It
//
//  Created by Muniyaraj on 23/08/24.
//

import UIKit
import Photos

class BaseObject: NSObject{
    deinit {
        debugPrint("\(Self.self) class deinitized..")
    }
}

final class ImagePickerViewModel: BaseObject {

    var imagePicker = UIImagePickerController()
    weak var viewController: UIViewController?
    
    var dismissImagePickerClosure: ((_ image: UIImage) -> Void)?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func openPhotoGallery() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            presentImagePicker()
        case .denied, .restricted:
            showAlertForDeniedAccess()
        case .notDetermined:
            requestPhotoLibraryPermission()
        case .limited:
            break
        @unknown default:
            fatalError("Unknown authorization status.")
        }
    }

    private func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.navigationBar.isTranslucent = false
            imagePicker.navigationBar.barTintColor = UIColor(red: 29.0 / 255.0, green: 33.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
            viewController?.present(imagePicker, animated: true, completion: nil)
        }
    }

    func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self?.presentImagePicker()
                    break
                case .denied, .restricted:
                    self?.showAlertForDeniedAccess()
                    break
                case .notDetermined:
                    // The user hasn't made a choice yet.
                    break
                case .limited:
                    break
                @unknown default:
                    fatalError("Unknown authorization status.")
                }
            }
        }
    }

    private func showAlertForDeniedAccess() {
        let alert = UIAlertController(title: "Access Denied", message: "Please allow access to your photo library in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        viewController?.present(alert, animated: true, completion: nil)
    }
}

extension ImagePickerViewModel: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            // Handle the edited image
            handleSelectedImage(image)
        } else if let image = info[.originalImage] as? UIImage {
            // Handle the original image
            handleSelectedImage(image)
        }
        viewController?.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true, completion: nil)
    }

    private func handleSelectedImage(_ image: UIImage) {
        // Handle the selected image here
        dismissImagePickerClosure?(image)
    }
}


/*import UIKit

final class ImagePickerViewModel: NSObject{
    
    var imagePicker = UIImagePickerController()
    var presentImagePickerClosure: ((_ imagePicker: UIImagePickerController) -> Void)?
    var dismissImagePickerClosure: ((_ image: UIImage) -> Void)?
    
}
extension ImagePickerViewModel{
    func openPhotoGallery() {
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.barTintColor = UIColor(red: 29.0 / 255.0, green: 33.0 / 255.0, blue: 44.0 / 255.0, alpha: 1.0)
        presentImagePickerClosure?(imagePicker)
      }
    }
}

extension ImagePickerViewModel: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
          dismissImagePickerClosure?(image)
          return
        }
        if let image = info[.originalImage] as? UIImage {
          dismissImagePickerClosure?(image)
        }
   }
}
*/
