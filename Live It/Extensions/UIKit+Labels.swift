//
//  UIKit+Labels.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

@IBDesignable class AttributedLabel: BaseLabel{
    
    @IBInspectable var titleText: String = ""{
        didSet{
            setupUI()
        }
    }
    @IBInspectable var titleFont: UIFont = .customFont(style: .semiBold, size: 28){
        didSet{
            setupUI()
        }
    }
    @IBInspectable var subTitleFont: UIFont = .customFont(style: .regular, size: 16){
        didSet{
            setupUI()
        }
    }
    @IBInspectable var subTitleText: String = ""{
        didSet{
            setupUI()
        }
    }
    @IBInspectable var seperatedText: String = "\n\n"{
        didSet{
            setupUI()
        }
    }
    @IBInspectable var titleColor: UIColor = .TextPrimaryColor{
        didSet{
            setupUI()
        }
    }
    @IBInspectable var subTitleColor: UIColor = .TextTeritaryColor{
        didSet{
            setupUI()
        }
    }
    var alignment: NSTextAlignment = .natural
    
    var isArabLang: Bool = false
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        numberOfLines = 0
        let titleText = titleText
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = alignment
        let titleAttributedString = NSAttributedString.styledString(text: titleText, style: titleFont, color: titleColor,paragraphStyle: paraStyle)
        
        let separatedText = ((!titleText.isEmpty && !subTitleText.isEmpty) ? seperatedText : "")
        let messageText = isArabLang ? (subTitleText + separatedText) : separatedText + subTitleText
        let messageAttributedString = NSAttributedString.styledString(text: messageText, style: subTitleFont, color: subTitleColor,paragraphStyle: paraStyle)
        
        let combinedAttributedString = NSMutableAttributedString()
        if isArabLang{
            if !messageText.isEmpty{
                combinedAttributedString.append(messageAttributedString)
            }
            if !titleText.isEmpty{
                combinedAttributedString.append(titleAttributedString)
            }
        }else{
            if !titleText.isEmpty{
                combinedAttributedString.append(titleAttributedString)
            }
            if !messageText.isEmpty{
                combinedAttributedString.append(messageAttributedString)
            }
        }
        attributedText = combinedAttributedString
    }
}

@IBDesignable class CustomizeLabel: BaseLabel{
    
    @IBInspectable var titleText: String = "Good"{ didSet{ setupUI() } }
    @IBInspectable var subTitleText: String = "Morning"{ didSet{ setupUI() } }
    
    var titleFont: UIFont = .customFont(style: .semiBold, size: 28)
    var subTitleFont: UIFont = .customFont(style: .regular, size: 16)
    
    var titleColor: UIColor = .label
    var subTitleColor: UIColor = .lightGray
    
    var lineSpacing: CGFloat = 2.0
    
    var separeatedString: String = "\n"
    var titleAlignment: NSTextAlignment = .justified
    var subTitleAlignment: NSTextAlignment = .justified
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        numberOfLines = 0
        
        separeatedString = (!titleText.isEmpty && !subTitleText.isEmpty) ? separeatedString : ""
        
        let fullText = titleText + separeatedString + subTitleText
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if !titleText.isEmpty{
            let titleAttributes = NSAttributedString.createAttributes(font: titleFont, color: titleColor, lineSpacing: lineSpacing,alignment: titleAlignment)
            let titleRange = NSRange(location: 0, length: titleText.count)
            attributedString.addAttributes(titleAttributes, range: titleRange)
        }
        
        if !subTitleText.isEmpty{
            let subTitleAttributes = NSAttributedString.createAttributes(font: subTitleFont, color: subTitleColor, lineSpacing: 0,alignment: subTitleAlignment)
            let subTitleRange = NSRange(location: (titleText+separeatedString).count, length: subTitleText.count)
            attributedString.addAttributes(subTitleAttributes, range: subTitleRange)
            
            
            
            // Create attributed string for subtitle
            let subtitleAttributedString = NSMutableAttributedString(string: subTitleText)
            
            // Apply different styles to specific parts of the subtitle
            let communityRange = (subTitleText as NSString).range(of: "community guidelines")
            let communityAttributes: [NSAttributedString.Key: Any] = [
                .font: subTitleFont, // Example different font
                .foregroundColor: UIColor.purple // Example different color
            ]
            
            subtitleAttributedString.addAttributes(subTitleAttributes, range: NSRange(location: 0, length: subTitleText.count))
            subtitleAttributedString.addAttributes(communityAttributes, range: communityRange)
            
            let subtitleParagraphStyle = NSMutableParagraphStyle()
            subtitleParagraphStyle.alignment = subTitleAlignment
            subtitleParagraphStyle.lineSpacing = 0
            
            // Find the correct range within the full text
            let subtitleRange = NSRange(location: (titleText + separeatedString).count, length: subTitleText.count)
            attributedString.addAttributes([.paragraphStyle: subtitleParagraphStyle], range: subtitleRange)
            attributedString.replaceCharacters(in: subtitleRange, with: subtitleAttributedString)
        
        }
        attributedText = attributedString
    }
}


class AdavanceLabel: BaseLabel{
    
    private var imagePostion: NSAttributedString.ImagePosititon = .before
    @IBInspectable var ErrorText: String = ""{ didSet { setupUI() } }
    var imageName: String = "error_icon"
    @IBInspectable var imageIndex: Int = 0{ didSet {
        imagePostion = NSAttributedString.ImagePosititon(rawValue: imageIndex) ?? .before
        setupUI()
    } }
    
    override func initalizeUI() {
        super.initalizeUI()
        numberOfLines = 0
        //setupUI()
    }
    private func setupUI(){
        numberOfLines = 0
        let attributedField = NSAttributedString.createdAttributedStringWithImage(imageName: imageName, imageColor: .Text_NegativeColor, imageYOffset: -8, text: ErrorText, font: .customFont(style: .regular, size: 12), textColor: .Text_NegativeColor, imagePosition: imagePostion)
        attributedText = attributedField
    }
}

class VerifiedUserNameLabel: BaseLabel{
    
    private var imagePostion: NSAttributedString.ImagePosititon = .after
    @IBInspectable var titleText: String = ""{ didSet { setupUI() } }
    @IBInspectable var isVerified: Bool = false{ didSet { setupUI() } }
    @IBInspectable var titleColor: UIColor = .TextPrimaryColor
    @IBInspectable var titleFont: UIFont = .customFont(style: .semiBold, size: 14)
    @IBInspectable var iconTintColor: UIColor = .PrimaryColor
    @IBInspectable var sepeatorString: String = ""
    var imageName: String = "verified_filled"
    @IBInspectable var imageIndex: Int = 1{ didSet {
        imagePostion = NSAttributedString.ImagePosititon(rawValue: imageIndex) ?? .after
        setupUI()
    } }
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        numberOfLines = 0
        let iconSize = isVerified ? CGSize(width: 16, height: 16) : .zero
        let attributedField = NSAttributedString.createdAttributedStringWithImage(imageName: imageName, imageColor: iconTintColor,imageSize: iconSize, imageYOffset: -3.5, text: titleText, font: titleFont, textColor: titleColor, imagePosition: imagePostion)
        attributedText = attributedField
    }
}
