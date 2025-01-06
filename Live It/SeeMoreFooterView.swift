//
//  SeeMoreFooterView.swift
//  Live It
//
//  Created by Muniyaraj on 29/08/24.
//

import UIKit

class SeeMoreFooterView: UICollectionReusableView, StoryboardCell {
    
    var seeMoreBtn: DefaultButton = DefaultButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalizeUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    private func initalizeUI(){
        addSubview(seeMoreBtn)
        seeMoreBtn.makeConstraints(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: bottomAnchor)
        setupView()
    }
    private func setupView(){
        seeMoreBtn.titleFont = .customFont(style: .semiBold, size: 14)
    }
    func setupConfigure(_ isLoaded: Bool,localizeService: LocalizationService?){
        seeMoreBtn.title = (isLoaded ? "seeless" : "seemore").localized(using: localizeService)
    }
}
