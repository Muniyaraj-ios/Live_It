//
//  ProfileHeaderView.swift
//  Live It
//
//  Created by Muniyaraj on 05/09/24.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView, StoryboardCell {

    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var profilePictureIcon: UIImageView!
    @IBOutlet weak var changeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    fileprivate func setupUI(){
        changeProfileButton.setTitle("", for: .normal)
        changeProfileButton.setImage(UIImage(named: "cameraIcon"), for: .normal)
        changeProfileButton.tintColor = .white
        changeProfileButton.backgroundColor = .clear
        
        changeProfileButton.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        profileBackgroundView.backgroundColor = .quaternaryLight
        
        profilePictureIcon.image = UIImage(named: "avatar_girl")
        
        changeLable.textColor = .TextTeritaryColor
        changeLable.font = .customFont(style: .semiBold, size: 10)
    }
    func setupConfigure(localizeService: LocalizationService?){
        
        changeLable.text = "Change photo"
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureIcon.cornerRadiusWithBorder(isRound: true, borderwidth: 3, borderColor: .white)
        changeProfileButton.cornerRadiusWithBorder(isRound: true,borderwidth: 0,borderColor: .clear)
    }
}
