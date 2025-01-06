//
//  PickInterestCollectionCell.swift
//  Live It
//
//  Created by Muniyaraj on 27/08/24.
//

import UIKit

final class PickInterestCollectionCell: UICollectionViewCell, StoryboardCell {
    
    let interestView: PickInterestView = PickInterestView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    private func setupUI(){
        addSubview(interestView)
        interestView.makeConstraints(toView: self,edge: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
    func setupConfigure(_ childdata: CategoryChildData,localizeService: LocalizationService?){
        let sementriAttribute: UISemanticContentAttribute = localizeService?.currentLanguage == .arabic ? .forceRightToLeft : .forceLeftToRight
        interestView.selected_ = childdata.isChoosed
        interestView.imageView.image = UIImage(named: "popcorn")
        interestView.interestLabel.text = childdata.image
        interestView.semanticContentAttribute = sementriAttribute
    }
}

class PickInterestView: BaseView{
    
    private var stackView = UIStackView()
    
    var imageView: UIImageView = {
       let imageView = UIImageView()
       return imageView
    }()
    
    var interestLabel: UILabel = {
       let label = UILabel()
       return label
    }()
    
    var selected_: Bool = false{
        didSet{
            guard oldValue != selected_ else{ return }
            setupSelected()
        }
    }
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        stackView = UIStackView(arrangedSubViews: [imageView, interestLabel], axis: .horizontal, spacing: 8, distribution: .fill)
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        addSubview(stackView)
        stackView.makeConstraints(toView: self)
        imageView.sizeConstraints(width: 24, height: 24)
        
        interestLabel.font = .customFont(style: .semiBold, size: 14)
        
        setupSelected()
    }
    func setupSelected(){
        backgroundColor = selected_ ? .focus_borderColor : .disableButtonColor
        interestLabel.textColor = selected_ ? .brandColor : .Text_SecondaryColor
        
        imageView.image?.withTintColor(selected_ ? .brandColor : .Text_SecondaryColor)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadiusWithBorder(corner: 8, borderwidth: 0, borderColor: .clear)
    }
}
