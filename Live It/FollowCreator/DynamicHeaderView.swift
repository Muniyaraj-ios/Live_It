//
//  DynamicHeaderView.swift
//  Live It
//
//  Created by Muniyaraj on 29/08/24.
//

import UIKit

final class DynamicHeaderView: UICollectionReusableView, StoryboardCell {
    
    var label: AttributedLabel = AttributedLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI(){
        addSubview(label)
        label.makeConstraints(toView: self,edge: .init(top: 12, left: 0, bottom: 12, right: 0))
        
        label.titleFont = .customFont(style: .semiBold, size: 16)
        label.subTitleFont = .customFont(style: .regular, size: 14)
        label.seperatedText = "\n\n"
        label.titleColor = .PrimaryDarkColor
        label.subTitleColor = .TextTeritaryColor
        
        layoutIfNeeded()
    }
    func setupConfigure(localizeService: LocalizationService?){
        let isRTL = localizeService?.currentLanguage == .arabic
        label.alignment = isRTL ? .right : .natural
        label.titleText = "\t" + "select_your_interest".localized(using: localizeService)
        label.subTitleText = "choose_category_intro".localized(using: localizeService)
        
//        layoutIfNeeded()
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize)
        return CGSize(width: size.width, height: max(size.height, 44)) // Minimum height if needed
    }
}
