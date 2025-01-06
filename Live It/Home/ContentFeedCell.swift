//
//  ContentFeedCell.swift
//  Live It
//
//  Created by Muniyaraj on 09/09/24.
//

import UIKit
import ActiveLabel

final class ContentFeedCell: UICollectionViewCell, StoryboardCell {
    
    @IBOutlet weak var feedUserName: UILabel!
    @IBOutlet weak var feedDesc: ActiveLabel!
    
    @IBOutlet weak var liveBtn: LiveButton!
    
    @IBOutlet weak var watchLiveBtn: WatchLiveButton!
    @IBOutlet weak var subscriberBtn: FollowButton!
    
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    var tabBarHeight: CGFloat = 20 {
        didSet {
            updateLayout()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    private func setupUI(){
        feedUserName.font = .customFont(style: .semiBold, size: 14)
        feedUserName.textColor = .ButtonTextColor
        feedDesc.font = .customFont(style: .regular, size: 14)
        feedDesc.textColor = .ButtonTextColor
        feedDesc.hashtagColor = .ButtonTextColor
        feedDesc.mentionColor = .ButtonTextColor
        feedDesc.URLColor = .ButtonTextColor
        feedDesc.numberOfLines = 6
        
        subscriberBtn.bgColor = .ButtonTextColor
        subscriberBtn.titleFont = .customFont(style: .semiBold, size: 14)
        subscriberBtn.borderColor = .clear
        subscriberBtn.title = "Subscribe"
        subscriberBtn.selTitle = "Subscribe"
        
        liveBtn.title = "Live"
        feedDesc.isUserInteractionEnabled = true
    }
    func setupConfigure(){
        let textDescription = "My Autumn Collection 🍁 #foryou #trending #fashion #getreadywithme #fashion #style #love #instagood #like #photography #beautiful #photooftheday #follow #instagram #picoftheday #model #bhfyp #art #beauty #instadaily #me #likeforlikes #smile #ootd #followme #moda #fashionblogger #happy #cute #instalike #myself #fashionstyle #photo"
        feedUserName.text = "Muniyaraj"
        feedDesc.text = textDescription
        
        feedDesc.handleHashtagTap { hahtag in
            debugPrint("hahtag : \(hahtag)")
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    private func updateLayout(){
        bottomConst?.constant = tabBarHeight
    }
}
