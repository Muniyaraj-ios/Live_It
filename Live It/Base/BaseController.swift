//
//  BaseController.swift
//  Live It
//
//  Created by Muniyaraj on 19/08/24.
//

import UIKit

class BaseController: UIViewController {
    
    var localizeService: LocalizationService?
    
    private var barButtonItem = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        observeChanges()
        view.backgroundColor = .BackgroundColor
        hideKeyboardWhenTappedAround()
    }
    func backBarButton(){
        let isRTL = self.localizeService?.currentLanguage == .arabic
        let backIcon = isRTL ? UIImage(named: "backIconFlip") : UIImage(named: "backIcon")
        if let backImage = backIcon?.resize(to: CGSize(width: 24, height: 24)) {
            barButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(buttonBarAction))
            barButtonItem.tintColor = UIColor.iconSecondaryColor
            self.navigationItem.leftBarButtonItem = barButtonItem
        }
    }
    @objc private func buttonBarAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        removeObserves()
        debugPrint("deinited \(String(describing: Self.self))")
    }
}
extension BaseController{
    fileprivate func observeChanges(){
        NotificationCenter.default.addObserver(self, selector: #selector(setupLang), name: LanguageManager.languageChangeDidNotification, object: nil)
    }
    @objc func setupLang() {
    }
    fileprivate func removeObserves(){
        NotificationCenter.default.removeObserver(self)
    }
}
