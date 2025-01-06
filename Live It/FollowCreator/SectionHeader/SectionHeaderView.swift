//
//  SectionHeaderView.swift
//  Live It
//
//  Created by Muniyaraj on 29/08/24.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView, StoryboardCell {
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Most Popular"
        label.isUserInteractionEnabled = false
        return label
    }()
    
    var headerBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "down_arrow"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalizeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    private func initalizeUI(){
        addSubview(headerBtn)
        headerBtn.makeConstraints(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil)
        headerBtn.makeCenterConstraints(toView: self, centerX_axis: false)
        headerBtn.sizeConstraints(width: 22, height: 22)
        
        addSubview(headerLabel)
        headerLabel.makeConstraints(top: nil, leading: leadingAnchor, trailing: headerBtn.leadingAnchor, bottom: nil)
        headerLabel.makeCenterConstraints(toView: self, centerX_axis: false)
        
        setupView()
    }
    private func setupView(){
        setupFont()
        setupTheme()
    }
    private func setupFont(){
        headerLabel.font = .customFont(style: .semiBold, size: 16)
    }
    private func setupTheme(){
        headerLabel.textColor = .TextPrimaryColor
        headerBtn.tintColor = .TextPrimaryColor
    }
    func setupConfigure(_ data: IntersetsType,isExpand: Bool){
        headerLabel.text = data.title
        headerBtn.setImage(UIImage(named: isExpand ? "up_arrow" : "down_arrow"), for: .normal)
    }
}

