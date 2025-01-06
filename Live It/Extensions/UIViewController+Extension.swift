//
//  UIViewController+Extension.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController{
    var appdelegate: AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    var sceneDelegate: SceneDelegate?{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene,let delegate = window.delegate as? SceneDelegate else { return nil }
        return delegate
    }
    //MARK: function to push the target from navigation Stack
    func pushToController(_ viewcontroller: UIViewController, animated: Bool = true,languageService: LocalizationService?){
        var navigationController: UINavigationController?
        if let navVC  = self as? UINavigationController{
            navigationController = navVC
        }else{
            navigationController = self.navigationController
        }
        if let vc = viewcontroller as? BaseController{
            vc.localizeService = languageService
        }
        navigationController?.pushViewController(viewcontroller, animated: animated)
    }
    func presentToController(_ viewController: UIViewController, animated: Bool = true, languageService: LocalizationService?){
        var navigationController: UINavigationController?
        if let navVC = self as? UINavigationController{
            navigationController = navVC
        }else{
            navigationController = self.navigationController
        }
        if let vc = viewController as? BaseController{
            vc.localizeService = languageService
        }
        navigationController?.present(viewController, animated: true)
    }
}

extension UIViewController{
    func setNavigationBarTitleAttributes(_ attributes: [NSAttributedString.Key: Any]){
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    func setNavigationBarTitleAttributes(font: UIFont = .customFont(style: .semiBold, size: 16), color: UIColor = .TextPrimaryColor, lineSpacing: CGFloat = 0){
        navigationController?.navigationBar.titleTextAttributes = NSAttributedString.createAttributes(font: font, color: color, lineSpacing: lineSpacing)
    }
}

extension UIAlertController {
    static func showCustomAlert(on viewController: UIViewController,
                                title: String?,
                                message: String?,
                                continueTitle: String,
                                cancelTitle: String,
                                continueHandler: @escaping () -> Void,
                                cancelHandler: (() -> Void)? = nil) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        /*// Customize the title attributes
        let titleAttributedString = NSAttributedString(string: title ?? "", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.systemPink
        ])
        alertController.setValue(titleAttributedString, forKey: "attributedTitle")
        
        // Customize the message attributes
        let messageAttributedString = NSAttributedString(string: message ?? "", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ])
        alertController.setValue(messageAttributedString, forKey: "attributedMessage")*/
        
        // Continue action
        let continueAction = UIAlertAction(title: continueTitle, style: .default) { _ in
            continueHandler()
        }
        continueAction.setValue(UIColor.TextPrimaryColor, forKey: "titleTextColor")
        alertController.addAction(continueAction)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelHandler?()
        }
        cancelAction.setValue(UIColor.PrimaryColor, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        // Present the alert
        viewController.present(alertController, animated: true, completion: nil)
    }
}
