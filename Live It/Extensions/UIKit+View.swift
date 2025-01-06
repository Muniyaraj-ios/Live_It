//
//  UIKit+View.swift
//  Live It
//
//  Created by Muniyaraj on 21/08/24.
//

import UIKit


@IBDesignable class SignupEmailView: BaseView{
    
    private var stackView = UIStackView()
    var headLabel = AttributedLabel()
    var textField = UITextField()
    private var bgView = UIView()
    var errorLabel = AdavanceLabel()
    lazy var errorBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "error_icon"), for: .normal)
        return button
    }()
    
    @IBInspectable var TitleText: String? {
        didSet { setupLabelUI() }
    }
    
    @IBInspectable var errorText: String? {
        didSet { setupLabelUI() }
    }
    @IBInspectable var throwError: Bool = false {
        didSet { isThrowError() }
    }
    
    @IBInspectable var stackViewSpacing: CGFloat = 14 {
        didSet {
            stackView.spacing = stackViewSpacing
        }
    } 
    @IBInspectable var textFieldFont: UIFont = .customFont(style: .regular, size: 16) {
        didSet {
            textField.font = textFieldFont
        }
    }
    
    @IBInspectable var textFieldHeight: CGFloat = 50 {
        didSet {
            textFieldHeightConstraint?.constant = textFieldHeight
        }
    }
    private var textFieldHeightConstraint: NSLayoutConstraint?
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        let stack =  UIStackView(arrangedSubViews: [textField,errorBtn], axis: .horizontal, spacing: 5, distribution: .fillProportionally)
        stack.alignment = .fill
        bgView.addSubview(stack)
        
        stackView = UIStackView(arrangedSubViews: [headLabel,bgView,errorLabel], axis: .vertical, spacing: stackViewSpacing, distribution: .fillProportionally)
        stackView.alignment = .fill
        addSubview(stackView)
        stackView.makeConstraints(toView: self)
        stack.makeConstraints(toView: bgView,edge: .init(top: 0, left: 12, bottom: 0, right: 8))
        errorBtn.makeConstraints(top: nil, leading: nil, trailing: nil, bottom: nil,width: 30)
        
        textField.font = textFieldFont
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textFieldHeightConstraint = textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        textFieldHeightConstraint?.isActive = true
        textField.tintColor = .PrimaryColor
        errorBtn.isHidden = !throwError
        errorLabel.isHidden = !throwError
        setupLabelUI()
    }
    private func isThrowError(){
        bgView.layer.borderColor = (throwError ? UIColor.Text_NegativeColor : UIColor.borderColor).cgColor
        bgView.layer.borderWidth = throwError ? 2 : 1
        bgView.layer.cornerRadius = 5.0
        errorLabel.isHidden = !throwError
        errorBtn.isHidden = !throwError
        if throwError{
            errorLabel.ErrorText = errorText ?? ""
        }
    }
    private func setupLabelUI(){
        headLabel.titleFont = .customFont(style: .regular, size: 14)
        headLabel.seperatedText = " "
        headLabel.titleText = TitleText ?? ""
        headLabel.subTitleText = ""
        
        errorLabel.ErrorText = errorText ?? ""
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.layer.borderColor = (throwError ? UIColor.Text_NegativeColor : UIColor.borderColor).cgColor
        bgView.layer.borderWidth = (throwError ? 2.0 : 0.6)
        bgView.layer.cornerRadius = 5.0
    }
}

@IBDesignable class DateofBirthView: BaseView{
    
    private var stackView = UIStackView()
    var headLabel = AttributedLabel()
    var textField = UITextField()
    private var bgView = UIView()
    private var lineView = UIView()
    private var errorLabel = AdavanceLabel()
    var subLabel = AttributedLabel()
    
    @IBInspectable var TitleText: String = " " {
        didSet { setupLabelUI() }
    } 
    @IBInspectable var SubTitleText: String? {
        didSet { setupLabelUI() }
    }
    @IBInspectable var placeHolderText: String = "" {
        didSet { setupPlaceHolder() }
    }
    @IBInspectable var errorText: String? {
        didSet { setupLabelUI() }
    }
    @IBInspectable var throwError: Bool = false {
        didSet { isThrowError() }
    }
    
    @IBInspectable var stackViewSpacing: CGFloat = 12 {
        didSet {
            stackView.spacing = stackViewSpacing
        }
    }
    
    @IBInspectable var textFieldFont: UIFont = .customFont(style: .regular, size: 16) {
        didSet {
            textField.font = textFieldFont
        }
    }
    
    @IBInspectable var textFieldHeight: CGFloat = 35 {
        didSet {
            textFieldHeightConstraint?.constant = textFieldHeight
        }
    }
    private var textFieldHeightConstraint: NSLayoutConstraint?
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        
        let dobStack = UIStackView(arrangedSubViews: [headLabel, textField], axis: .vertical, spacing: 0, distribution: .fillProportionally)
        dobStack.layoutMargins = .init(top: 0, left: 15, bottom: 0, right: 15)
        dobStack.isLayoutMarginsRelativeArrangement = true
        dobStack.alignment = .fill
        
        let labelStack = UIStackView(arrangedSubViews: [errorLabel, subLabel], axis: .vertical, spacing: 20, distribution: .fillProportionally)
        labelStack.layoutMargins = .init(top: 0, left: 15, bottom: 0, right: 15)
        labelStack.isLayoutMarginsRelativeArrangement = true
        labelStack.alignment = .leading
        
        stackView = UIStackView(arrangedSubViews: [dobStack,lineView,labelStack], axis: .vertical, spacing: stackViewSpacing, distribution: .fill)
        stackView.alignment = .fill
        addSubview(stackView)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.makeConstraints(toView: self,edge: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        lineView.heightConstraints(height: 0.6)
        
        textFieldHeightConstraint = textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        textFieldHeightConstraint?.isActive = true
        
        lineView.backgroundColor = .borderColor
        
        textField.keyboardType = .default
        textField.font = textFieldFont
        textField.textColor = .PrimaryDarkColor
        setupPlaceHolder()
        errorLabel.isHidden = !throwError
        setupLabelUI()
    }
    private func setupPlaceHolder(){
        textField.setPlaceholder(text: placeHolderText, font: .customFont(style: .regular, size: 16), color: .placeholderText)
    }
    private func isThrowError(){
        bgView.layer.borderColor = (throwError ? UIColor.Text_NegativeColor : UIColor.borderColor).cgColor
        bgView.layer.borderWidth = throwError ? 2 : 1
        bgView.layer.cornerRadius = 5.0
        errorLabel.isHidden = !throwError
        if throwError{
            errorLabel.ErrorText = errorText ?? ""
        }
    }
    private func setupLabelUI(){
        headLabel.titleColor = .TextTeritaryColor
        headLabel.titleFont = .customFont(style: .regular, size: 14)
        headLabel.seperatedText = " "
        headLabel.titleText = TitleText
        headLabel.subTitleText = ""
        
        errorLabel.ErrorText = errorText ?? ""
        subLabel.titleText = SubTitleText ?? ""
        subLabel.titleFont = .customFont(style: .regular, size: 14)
        subLabel.titleColor = .TextTeritaryColor
        subLabel.seperatedText = ""
        subLabel.subTitleText = ""
    }
}

@IBDesignable class TextNameView: BaseView{
    
    private var stackView = UIStackView()
    var headLabel = AttributedLabel()
    var textField = UITextField()
    private var bgView = UIView()
    private var lineView = UIView()
    private var errorLabel = AdavanceLabel()
    var subLabel = AttributedLabel()
    lazy var errorBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "check"), for: .normal)
        button.setImage(UIImage(named: "uncheck"), for: .selected)
        button.tintColor = .PrimaryDarkColor
        return button
    }()
    
    @IBInspectable var TitleText: String? = " " {
        didSet { headLabel.titleText = TitleText ?? "" }
    }
    
    var current_TextCount: String = ""
    var exp_TextCount: String = ""
    
    var errorText: String? = ""
    
    @IBInspectable var throwError: Bool = false {
        didSet { isThrowError() }
    }
    @IBInspectable var placeholderText: String = "" {
        didSet { textField.setPlaceholder(text: placeholderText, font: .customFont(style: .regular, size: 16), color: .placeholderText) }
    }
    
    @IBInspectable var stackViewSpacing: CGFloat = 12 {
        didSet {
            stackView.spacing = stackViewSpacing
        }
    }
    
    @IBInspectable var textFieldFont: UIFont = .customFont(style: .regular, size: 16) {
        didSet {
            textField.font = textFieldFont
        }
    }
    
    @IBInspectable var textFieldHeight: CGFloat = 35 {
        didSet {
            textFieldHeightConstraint?.constant = textFieldHeight
        }
    }
    private var textFieldHeightConstraint: NSLayoutConstraint?
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        
        let textFieldls = UIStackView(arrangedSubViews: [textField,errorBtn], axis: .horizontal, spacing: 0, distribution: .fillProportionally)
        textFieldls.alignment = .fill
        
        let dobStack = UIStackView(arrangedSubViews: [headLabel, textFieldls], axis: .vertical, spacing: 0, distribution: .fillProportionally)
        dobStack.layoutMargins = .init(top: 0, left: 15, bottom: 0, right: 15)
        dobStack.isLayoutMarginsRelativeArrangement = true
        dobStack.alignment = .fill
        
        let labelStack = UIStackView(arrangedSubViews: [errorLabel ,subLabel], axis: .horizontal, spacing: 5, distribution: .fillProportionally)
        labelStack.layoutMargins = .init(top: 0, left: 15, bottom: 0, right: 15)
        labelStack.isLayoutMarginsRelativeArrangement = true
        labelStack.alignment = .fill
        
        stackView = UIStackView(arrangedSubViews: [dobStack,lineView,labelStack], axis: .vertical, spacing: stackViewSpacing, distribution: .fill)
        stackView.alignment = .fill
        addSubview(stackView)
        
//        addSubview(subLabel)
//        addSubview(errorLabel)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        errorBtn.translatesAutoresizingMaskIntoConstraints = false
        textFieldls.translatesAutoresizingMaskIntoConstraints = false
        dobStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.makeConstraints(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor,edge: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        errorBtn.makeConstraints(top: nil, leading: nil, trailing: nil, bottom: nil,width: 30)
        errorBtn.isHidden = true
        
        lineView.heightConstraints(height: 0.8)
        
//        subLabel.makeConstraints(top: nil, leading: nil, trailing: stackView.trailingAnchor, bottom: nil,edge: .init(top: 0, left: 0, bottom: 0, right: 15))
//        errorLabel.makeConstraints(top: stackView.bottomAnchor, leading: stackView.leadingAnchor, trailing: subLabel.leadingAnchor, bottom: bottomAnchor,edge: .init(top: 15, left: 10, bottom: 20, right: 8))
        
        subLabel.widthConstraints(width: 50)
                
//        subLabel.makeCenterConstraints(toView: errorLabel,centerX_axis: false)
                
        textFieldHeightConstraint = textField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        textFieldHeightConstraint?.isActive = true
        
        lineView.backgroundColor = .borderColor
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.smartQuotesType = .no
        textField.smartDashesType = .no
        textField.smartDashesType = .no
        textField.returnKeyType = .search
        
        textField.keyboardType = .default
        
        textField.font = textFieldFont
        textField.textColor = .PrimaryDarkColor
        textField.setPlaceholder(text: placeholderText, font: .customFont(style: .regular, size: 16), color: .placeholderText)
        
        textField.tintColor = .PrimaryColor
        
        errorLabel.isHidden = !throwError
        setupHeadLabel()
        setupErrorLabel()
    }
    private func isThrowError(){
        errorBtn.isHidden = false
        errorLabel.isHidden = !throwError
        
        errorBtn.isSelected = throwError
        
        subLabel.titleText = current_TextCount
        subLabel.subTitleText = exp_TextCount.isEmpty ? "" : ("/" + exp_TextCount)
        
        errorLabel.ErrorText = errorText ?? ""
    }
    private func setupHeadLabel(){
        headLabel.titleColor = .TextTeritaryColor
        headLabel.titleFont = .customFont(style: .regular, size: 16)
        headLabel.seperatedText = " "
        headLabel.subTitleText = ""
        headLabel.titleText = TitleText ?? "" 
    }
    private func setupErrorLabel(){
        subLabel.titleFont = .customFont(style: .regular, size: 14)
        subLabel.subTitleFont = .customFont(style: .regular, size: 14)
        subLabel.titleColor = .Text_NegativeColor
        subLabel.subTitleColor = .TextTeritaryColor
        subLabel.seperatedText = ""
    }
}

@IBDesignable class ProfileImagePickerView:  BaseView{
    
    private var imageView: UIImageView = UIImageView()
    
    @IBInspectable var picture: UIImage? = UIImage(named: "placeholder_user"){
        didSet{
            guard let image = picture else{
                profile_picked = .notpicked
                updateBorders()
                return
            }
            profile_picked = .picked
            imageView.image = image
            updateBorders()
        }
    }
    
    var profile_picked: ProfilePicked = .notpicked
    
    @IBInspectable var Content: UIView.ContentMode = .scaleAspectFit{
        didSet{ if oldValue != Content { imageView.contentMode = Content } }
    }
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.makeConstraints(toView: self,edge: .init(top: 5, left: 5, bottom: 5, right: 5))
        imageView.makeCenterConstraints(toView: self)
        imageView.image = picture
        imageView.contentMode = Content
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorders()
    }
    private func updateBorders(){
        let pic_Pick = profile_picked == .picked
        imageView.cornerRadiusWithBorder(corner: (imageView.frame.height / 2), borderwidth: pic_Pick ? 2 : 0, borderColor: pic_Pick ? .TextColor : .clear)
        cornerRadiusWithBorder(corner: (frame.height / 2), borderwidth: pic_Pick ? 4 : 0, borderColor: pic_Pick ? .PrimaryColor : .clear)
    }
}

class ToasterActionView: BaseView{
    
    var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "cancelIcon"), for: .normal)
        button.tintColor = .TextColor_Black
        return button
    }()
    var titleText: UILabel = {
        let label = UILabel()
        label.text = "Verification code sent"
        label.textColor = .TextColor_Black
        label.textAlignment = .center
        label.font = .customFont(style: .regular, size: 16)
        return label
    }()
    
    override func initalizeUI() {
        super.initalizeUI()
        let stackView = UIStackView(arrangedSubViews: [titleText, cancelButton], axis: .horizontal, spacing: 15, distribution: .fill)
        stackView.alignment = .center
        addSubview(stackView)
        stackView.makeConstraints(toView: self,edge: .init(top: 15, left: 15, bottom: 15, right: 15))
        cancelButton.sizeConstraints(width: 25, height: 25)
        backgroundColor = .TextPrimaryColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 6
    }
}

class SegmentedProgressLoaderView: UIView {
    
    private var aPath: UIBezierPath = UIBezierPath()
        
    let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(red: 41/255, green: 35/255, blue: 101/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        return shapeLayer
    }()
    
    let trackLayer: CAShapeLayer = {
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor(red: 41/255, green: 35/255, blue: 101/255, alpha: 0.1).cgColor
        trackLayer.lineWidth = 6
        trackLayer.strokeEnd = 1
        trackLayer.lineCap = .round
        return trackLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayers() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        aPath = UIBezierPath()
        
        if semanticContentAttribute == .forceRightToLeft {
            aPath.move(to: CGPoint(x: bounds.width, y: bounds.midY))
            aPath.addLine(to: CGPoint(x: 0.0, y: bounds.midY))
        }else{
            aPath.move(to: CGPoint(x: 0.0, y: bounds.midY))
            aPath.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        }
        
        trackLayer.path = aPath.cgPath
        shapeLayer.path = aPath.cgPath
        
        shapeLayer.lineCap = .round
        trackLayer.lineCap = .round
    }
    
    func setProgress(_ progress: CGFloat) {
        shapeLayer.strokeEnd = progress
    }
}


class TextFieldView: BaseView{
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    
    private func setupUI(){
        
    }
}
