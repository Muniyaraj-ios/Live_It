//
//  OnboardCollectionCell.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

final class OnboardCollectionCell: UICollectionViewCell,StoryboardCell {
    
    var bgView: UIView = UIView()
    var imageView: UIImageView = UIImageView()
    var label: CustomizeLabel = CustomizeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupView()
    }
    private func setupUI(){
        addSubview(bgView)
        bgView.addSubview(imageView)
        bgView.addSubview(label)
        
        bgView.makeConstraints(toView: self)
        
        imageView.makeConstraints(top: bgView.topAnchor, leading: nil, trailing: nil, bottom: nil)
        imageView.makeViewMultiplierWidth(toView: bgView, width: 0.8)
        imageView.makeViewMultiplierHeight(toView: bgView, height: 0.7)
        imageView.makeCenterConstraints(toView: self,centerY_axis: false)
        
        label.makeConstraints(top: imageView.bottomAnchor, leading: bgView.leadingAnchor, trailing: bgView.trailingAnchor, bottom: bgView.bottomAnchor,edge: .init(top: 6, left: 12, bottom: 0, right: 12))
    }
    private func setupView(){
        label.lineSpacing = 15.0
        label.titleAlignment = .center
        label.subTitleAlignment = .center
        imageView.contentMode = .scaleAspectFill
    }
    func setupConfigure(_ onboard: OnboardData,index: Int,localizeService: LocalizationService?){
        label.titleText = onboard.data.title.localized(using: localizeService)
        label.subTitleText = onboard.data.subTitle.localized(using: localizeService)
        let iconName = "\(onboard.image)\(index)"
        imageView.image = UIImage(named: iconName)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.clipsToBounds = true
    }
}
