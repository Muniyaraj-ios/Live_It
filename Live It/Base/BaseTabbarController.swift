//
//  BaseTabbarController.swift
//  Live It
//
//  Created by Muniyaraj on 05/09/24.
//

import UIKit

class BaseTabbarController: UITabBarController {
    
    var localizeService: LocalizationService?

    override func viewDidLoad() {
        super.viewDidLoad()
        observeChanges()
    }
    deinit {
        removeObserves()
        debugPrint("deinited \(String(describing: Self.self))")
    }
}
extension BaseTabbarController{
    fileprivate func observeChanges(){
        NotificationCenter.default.addObserver(self, selector: #selector(setupLang), name: LanguageManager.languageChangeDidNotification, object: nil)
    }
    @objc func setupLang() {
        DispatchQueue.main.async { //[weak self] in
//            guard let self else{ return }
//            let isRTL = localizeService?.currentLanguage == .arabic
//            tabBar.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        }
    }
    fileprivate func removeObserves(){
        NotificationCenter.default.removeObserver(self)
    }
}
