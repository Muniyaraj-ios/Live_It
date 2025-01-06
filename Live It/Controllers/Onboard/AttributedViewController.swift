//
//  AttributedViewController.swift
//  Live It
//
//  Created by Muniyaraj on 09/09/24.
//

import UIKit

//class ViewController: BaseController {
//
//    let postDesc = "My Autumn Collection 🍁 #foryou #trending #fashion #getreadywithme #fashion #style #love #instagood #like #photography #beautiful #photooftheday #follow #instagram #picoftheday #model #bhfyp #art #beauty #instadaily #me #likeforlikes #smile #ootd #followme #moda #fashionblogger #happy #cute #instalike #myself #fashionstyle #photo https://google.com"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let attributedString = NSMutableAttributedString(string: postDesc)
//        
//        // Regular expressions for hashtags and URLs
//        let hashtagPattern = "#\\w+"
//        let urlPattern = "https?://[\\w./]+"
//        
//        // Apply bold formatting to hashtags
//        if let hashtagRegex = try? NSRegularExpression(pattern: hashtagPattern, options: []) {
//            let hashtags = hashtagRegex.matches(in: postDesc, options: [], range: NSRange(location: 0, length: postDesc.utf16.count))
//            for match in hashtags {
//                let range = match.range
//                attributedString.addAttribute(.font, value: UIFont.customFont(style: .semiBold, size: 16), range: range)
//            }
//        }
//        
//        // Apply blue color and underline to URLs and replace URL with descriptive text
//        if let urlRegex = try? NSRegularExpression(pattern: urlPattern, options: []) {
//            let urls = urlRegex.matches(in: postDesc, options: [], range: NSRange(location: 0, length: postDesc.utf16.count))
//            for match in urls {
//                let range = match.range
//                attributedString.replaceCharacters(in: range, with: "google")
//                
//                // Reapply attributes to the new range
//                let googleRange = NSRange(location: range.location, length: "google".utf16.count)
//                attributedString.addAttribute(.foregroundColor, value: UIColor.link, range: googleRange)
//                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: googleRange)
//            }
//        }
//        
//        // Create and configure a UILabel to display the attributed text
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.attributedText = attributedString
//        label.frame = view.bounds
//        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        view.addSubview(label)
//    }
//}

class ViewController: BaseController {

    private let fullText = "My Autumn Collection 🍁 #foryou #trending #fashion #getreadywithme #fashion #style #love #instagood #like #photography #beautiful #photooftheday #follow #instagram #picoftheday #model #bhfyp #art #beauty #instadaily #me #likeforlikes #smile #ootd #followme #moda #fashionblogger #happy #cute #instalike #myself #fashionstyle #photo https://google.com"
    private let previewText = "My Autumn Collection 🍁 #foryou #trending #fashion ... #instalike #myself #fashionstyle #photo"
    private let readMoreText = "..."
    private let readLessText = "Read less"
    
    private var isExpanded = false
    
    private lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lbl.addGestureRecognizer(tapGesture)
        return lbl
    }()
    
    private var circleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        createCircleView()
        animateCircleZoomInAndOut()
        updateLabelText()
    }
    
    private func setupConstraints() {
        let button = UIButton(type: .system)
        button.setTitle("Live", for: .normal)
        button.setTitleColor(.ButtonTextColor, for: .normal)
        button.titleLabel?.font = .customFont(style: .semiBold, size: 20)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
        
        
        button.makeGradientColor()
        view.addSubview(button)
    }
    // Create a circular UIView
        private func createCircleView() {
            let circleSize: CGFloat = 100
            circleView = UIView(frame: CGRect(x: (view.frame.size.width - circleSize) / 2,
                                              y: (view.frame.size.height - circleSize) / 2,
                                              width: circleSize, height: circleSize))
            circleView.layer.cornerRadius = circleSize / 2
            circleView.backgroundColor = UIColor.systemPink
            view.addSubview(circleView)
        }

        // Zoom In and Out animation
        private func animateCircleZoomInAndOut() {
            // Zoom in animation (scaling up)
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           options: [.autoreverse, .repeat],
                           animations: {
                self.circleView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { _ in
                // Optional completion code if you want to do something after
            })
        }
    
    private func updateLabelText() {
        let text = isExpanded ? fullText : previewText + " \(readMoreText)"
        let attributedString = NSMutableAttributedString(string: text)
        
        // Regular expressions for hashtags and URLs
        let hashtagPattern = "#\\w+"
        let urlPattern = "https?://[\\w./]+"
        
        // Apply bold formatting to hashtags
        if let hashtagRegex = try? NSRegularExpression(pattern: hashtagPattern, options: []) {
            let hashtags = hashtagRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            for match in hashtags {
                let range = match.range
                attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
            }
        }
        
        // Apply blue color and underline to URLs
        if let urlRegex = try? NSRegularExpression(pattern: urlPattern, options: []) {
            let urls = urlRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            for match in urls {
                let range = match.range
                attributedString.replaceCharacters(in: range, with: "google")
                
                // Reapply attributes to the new range
                let googleRange = NSRange(location: range.location, length: "google".utf16.count)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: googleRange)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: googleRange)
            }
        }
        
        // Apply a different font to the remaining text
//        let remainingRange = NSRange(location: 0, length: text.utf16.count)
//        attributedString.addAttribute(.font, value: UIFont.customFont(style: .regular, size: 15), range: remainingRange)

        
        // Handle "Read more" and "Read less"
        let readMoreRange = (text as NSString).range(of: readMoreText)
        let readLessRange = (text as NSString).range(of: readLessText)
        
        if readMoreRange.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: readMoreRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: readMoreRange)
        }
        
        if readLessRange.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: readLessRange)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: readLessRange)
        }
        
        label.attributedText = attributedString
    }
    
    @objc private func labelTapped() {
        isExpanded.toggle()
        updateLabelText()
    }
}
