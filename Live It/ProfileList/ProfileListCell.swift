//
//  ProfileListCell.swift
//  Live It
//
//  Created by Muniyaraj on 05/09/24.
//

import UIKit

final class ProfileListCell: UICollectionViewCell, StoryboardCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var nextArrowBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    fileprivate func setupUI(){
        titleLabel.font = .customFont(style: .semiBold, size: 16)
        subTitleLabel.font = .customFont(style: .regular, size: 16)
        titleLabel.textColor = .TextPrimaryColor
        subTitleLabel.textColor = .TextTeritaryColor
        nextArrowBtn.tintColor = .PrimaryDarkColor
        lineView.backgroundColor = .quaternaryLight
        
        nextArrowBtn.setTitle("", for: .normal)
        nextArrowBtn.setImage(UIImage(named: "backIconFlip"), for: .normal)
        
        nextArrowBtn.semanticContentAttribute = .forceRightToLeft
    }
    func setupConfigure(_ menu: UserProfileMenu,localizationService: LocalizationService?){
        titleLabel.text = menu.name
        subTitleLabel.text = menu.description
        let isRTL = localizationService?.currentLanguage == .arabic
        print("cell lang : \(localizationService?.currentLanguage.rawValue ?? "-")")
        let semanticAttribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        nextArrowBtn.transform = isRTL ? CGAffineTransform(scaleX: -1, y: 1) : .identity
        semanticContentAttribute = semanticAttribute
    }
}
