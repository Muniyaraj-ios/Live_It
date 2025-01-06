//
//  FollowCreaterTableCell.swift
//  Live It
//
//  Created by Muniyaraj on 26/08/24.
//

import UIKit

final class FollowCreaterTableCell: UITableViewCell, StoryboardCell {
    
    @IBOutlet weak var followerIcon: UIImageView!
    @IBOutlet weak var createrUserNameLabel: VerifiedUserNameLabel!
    @IBOutlet weak var createrdetailNameLabel: AttributedLabel!
    @IBOutlet weak var followerBtn: FollowButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    private func setupUI(){
        selectionStyle = .none
        createrdetailNameLabel.titleFont = .customFont(style: .regular, size: 12)
        createrdetailNameLabel.subTitleFont = .customFont(style: .regular, size: 12)
        createrdetailNameLabel.titleColor = .TextTeritaryColor
        createrdetailNameLabel.subTitleColor = .TextTeritaryColor
        
        createrdetailNameLabel.seperatedText = "  •  "
        
        followerBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    @objc func buttonAction(){
        followerBtn.isFollowed.toggle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupConfigure(_ data: FollowersDataModel,localizeService: LocalizationService?){
        createrdetailNameLabel.isArabLang = localizeService?.currentLanguage == .arabic
        createrdetailNameLabel.titleText = data.profileName
        createrdetailNameLabel.subTitleText = data.totalFollowers
        createrUserNameLabel.titleText = data.userName
        createrUserNameLabel.isVerified = data.verifiedUser
        createrUserNameLabel.imageIndex = localizeService?.currentLanguage == .arabic ? 0 : 1
        followerBtn.title = "follow".localized(using: localizeService)
        followerBtn.selTitle = "unfollow".localized(using: localizeService)
        followerBtn.isFollowed = data.followingStatus
    }
}


struct FollowersDataModel{
    let userName: String
    let verifiedUser: Bool
    let profileName: String
    let totalFollowers: String
    let profileURL: String
    let followingStatus: Bool
}
extension FollowersDataModel{
    static var mockFollowers: [FollowersDataModel]{
        return [
            .init(userName: "the_hike_guide", verifiedUser: true, profileName: "Paul Berger", totalFollowers: "1099", profileURL: "", followingStatus: true),
            .init(userName: "mia_hairstylish", verifiedUser: false, profileName: "Mia Babus", totalFollowers: "1020", profileURL: "", followingStatus: false),
            .init(userName: "mari_marie", verifiedUser: false, profileName: "Marie", totalFollowers: "1001", profileURL: "", followingStatus: false),
            .init(userName: "travel_w_me", verifiedUser: true, profileName: "Mark Logan", totalFollowers: "1084", profileURL: "", followingStatus: false),
        ]
    }
}
