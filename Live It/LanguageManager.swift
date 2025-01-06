//
//  LanguageManager.swift
//  Live It
//
//  Created by Muniyaraj on 19/08/24.
//

import Foundation
import UIKit

enum LanguageCodes: String{
    case english = "en"
    case arabic = "ar"
    
    var localeCode: String{
        switch self {
        case .english: return "en_US"
        case .arabic: return "ar_AE"
        }
    }
}

protocol LocalizationService: AnyObject{
    var currentLanguage: LanguageCodes{ get set }
    func localizedString(for key: String) -> String
}

final class LanguageManager: LocalizationService{
    
    private var bundle: Bundle?
    
    var currentLanguage: LanguageCodes{
        didSet{
            if oldValue != currentLanguage{
                //update_BundleForLanguageChanges() // didn't thread saftey
                updateBundleForLanguageChanges() // handled thread saftey
            }
        }
    }
    
    private var bundleCache: [String: Bundle] = [:]
    private let cacheQueue = DispatchQueue(label: "com.doitlive.localization.cacheQueue", attributes: .concurrent)
    // DispatchQueue to ensure that only one thread can modify the bundleCache at a time, while still allowing multiple threads to read from it concurrently:
    
    init(bundle: Bundle? = nil, languageCode: LanguageCodes) {
        self.bundle = bundle
        self.currentLanguage = languageCode
        //update_BundleForLanguageChanges() // didn't handle thread safety
        updateBundleForLanguageChanges() // handled thread safety
    }
    
    func localizedString(for key: String) -> String {
        return NSLocalizedString(key, bundle: self.bundle ?? Bundle.main, comment: "")
    }
}

extension LanguageManager{
    func update_BundleForLanguageChanges(){
        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) else{
            self.bundle = Bundle.main
            return
        }
        self.bundle = bundle
        updateForLanguageChanges()
    }
    private func updateBundleForLanguageChanges() {
        let languageCode = currentLanguage.rawValue
        
        cacheQueue.sync {
            if let cachedBundle = bundleCache[languageCode] {
                self.bundle = cachedBundle
            } else {
                if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
                   let newBundle = Bundle(path: path) {
                    cacheQueue.async(flags: .barrier) {
                        self.bundleCache[languageCode] = newBundle
                    }
                    self.bundle = newBundle
                } else {
                    self.bundle = Bundle.main
                }
            }
        }
        updateForLanguageChanges()
        updateRTLLayoutDirection()
    }
    
    private func updateRTLLayoutDirection() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let isRTL = currentLanguage == .arabic
            let semanticAttribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight

            UIView.appearance().semanticContentAttribute = semanticAttribute
            UINavigationBar.appearance().semanticContentAttribute = semanticAttribute
            
            UIBarButtonItem.appearance().customView?.semanticContentAttribute = semanticAttribute

            // Force the view to layout again to apply the changes
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = window.rootViewController
                window.makeKeyAndVisible()
            }
        }
    }
    func updateForLanguageChanges(){
        NotificationCenter.default.post(name: LanguageManager.languageChangeDidNotification, object: nil)
    }
    static let languageChangeDidNotification = NSNotification.Name(rawValue: "languageChangeDidNotification")
}

extension LanguageManager{
    func clearBundleCache() {
        cacheQueue.async(flags: .barrier) {
            self.bundleCache.removeAll()
        }
    }
}
class DefaultLocalizationService: LocalizationService {
    
    var currentLanguage: LanguageCodes = .arabic
    
    func localizedString(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}


extension String{
    func localized(using service: LocalizationService?)-> String{
        let service_: LocalizationService = service ?? DefaultLocalizationService()
        return service_.localizedString(for: self)
    }
}

extension UIView {
    
    func updateTextAlignment(for service_: LocalizationService?) {
        let service = service_
        let isRTL = service?.currentLanguage == .arabic
        let semanticAttribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        /*if let textField = self as? OTPField {
            textField.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceRightToLeft
            return
        }else*/
        if let textField = self as? UITextField {
            textField.textAlignment = isRTL ? .right : .left
        } else if let textView = self as? UITextView {
            textView.textAlignment = isRTL ? .right : .left
        } else if let label = self as? UILabel {
            label.textAlignment = isRTL ? .right : .left
        }else if let collectionView = self as? UICollectionView {
            collectionView.semanticContentAttribute = semanticAttribute
            
            collectionView.setNeedsLayout()
            collectionView.layoutIfNeeded()
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        // Recursively apply to subviews
        subviews.forEach { $0.updateTextAlignment(for: service) }
    }
}
