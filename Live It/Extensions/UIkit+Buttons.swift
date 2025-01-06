//
//  UIkit+Buttons.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

@IBDesignable class AppButton: BaseButton{
    
    @IBInspectable var title: String = ""{ didSet{ setupUI() } }
    @IBInspectable var titleColor: UIColor = .ButtonTextColor{ didSet{ setupUI() } }
    @IBInspectable var bgColor: UIColor = .ButtonColor{ didSet{ setupUI() } }
    @IBInspectable var titleFont: UIFont = .customFont(style: .semiBold, size: 16){ didSet{ setupUI() } }
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        backgroundColor = bgColor
        titleLabel?.font = titleFont
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    func disbleButton(){
        isEnabled = false
        setTitleColor(.disableTextColor, for: .normal)
        backgroundColor = UIColor.disableButtonColor
    }
    func EnableButton(){
        isEnabled = true
        setTitleColor(titleColor, for: .normal)
        backgroundColor = UIColor.PrimaryColor
    }
}


@IBDesignable class AttributedButton: BaseButton{
    
    @IBInspectable var titleText: String = ""{ didSet{ setupUI() } }
    @IBInspectable var subTitleText: String = ""{ didSet{ setupUI() } }
    
    @IBInspectable var sepeatedText: String = " "{ didSet{ setupUI() } }
    
    @IBInspectable var titleColor: UIColor = .label{ didSet{ setupUI() } }
    @IBInspectable var subTitleColor: UIColor = .PrimaryColor{ didSet{ setupUI() } }
    
    var titleFont: UIFont = .customFont(style: .regular, size: 16)
    var subTitleFont: UIFont = .customFont(style: .medium, size: 16)
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .left
        let titleTextAttribute = NSAttributedString.styledString(text: titleText, style: titleFont, color: titleColor,paragraphStyle: paraStyle)
        
        let subTitleTextAttribute = NSAttributedString.styledString(text: sepeatedText+subTitleText, style: subTitleFont, color: subTitleColor,paragraphStyle: paraStyle)
        let attributedText = NSMutableAttributedString()
        attributedText.append(titleTextAttribute)
        attributedText.append(subTitleTextAttribute)
        setAttributedTitle(attributedText, for: .normal)
    }
}

class LoadingButton: BaseButton {
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    @IBInspectable var buttonEnabled: Bool = false{
        didSet{
            if oldValue != buttonEnabled{ buttonEnabled ? EnableButton() : disbleButton() }
        }
    }
    @IBInspectable var titleFont: UIFont = .customFont(style: .semiBold, size: 16){
        didSet{ titleLabel?.font = titleFont }
    }
    @IBInspectable var enableTitle_Text: String = ""{
        didSet{ setTitle(enableTitle_Text, for: .normal) }
    }
    @IBInspectable var disbleTitle_Text: String = ""{
        didSet{ setTitle(disbleTitle_Text, for: .disabled) }
    }
    
    private func disbleButton(){
        isEnabled = false
        backgroundColor = UIColor.disableButtonColor
    }
    private func EnableButton(){
        isEnabled = true
        backgroundColor = UIColor.PrimaryColor
    }
    
    override func initalizeUI() {
        super.initalizeUI()
        setupButton()
    }
    
    private func setupButton() {
        setTitle(enableTitle_Text, for: .normal)
        setTitle(disbleTitle_Text, for: .disabled)
        setTitleColor(.disableTextColor, for: .disabled)
        setTitleColor(.ButtonTextColor, for: .normal)
        titleLabel?.font = titleFont
        buttonEnabled ? EnableButton() : disbleButton()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .disableTextColor
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: titleLabel!.trailingAnchor, constant: 8)
        ])
        
        addTarget(self, action: #selector(buttonPressed), for: [.touchDown,.touchDragInside,.touchDragOutside])
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // Function to handle button tap
    @objc private func buttonPressed() {
        backgroundColor = .surfaceButtonColor
        layer.borderWidth = 4
        layer.borderColor = UIColor.focus_borderColor.cgColor
    }
    
    @objc private func buttonReleased() {
        backgroundColor = .PrimaryColor
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    // Function to handle button tap
    func startLoading() {
        buttonEnabled = false
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        buttonEnabled = true
        activityIndicator.stopAnimating()
    }
}

class DefaultButton: BaseButton{
    
    var title: String = ""{
        didSet{ setTitle(title, for: .normal) }
    }
    var titleFont: UIFont = .customFont(style: .semiBold, size: 16){
        didSet{ titleLabel?.font = titleFont }
    }
     var titleColor: UIColor = .PrimaryColor{
        didSet{ setTitleColor(titleColor, for: .normal) }
    }
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        setTitleColor(titleColor, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = .customFont(style: .semiBold, size: 16)
    }
    
    override var intrinsicContentSize: CGSize {
        // Get the intrinsic content size of the title label
        let titleSize = titleLabel?.intrinsicContentSize ?? CGSize.zero
        
        // Add extra padding
        let width = titleSize.width + 10
        let height = titleSize.height
        
        return CGSize(width: width, height: height)
    }
}


class PaddedButton: UIButton {
    
    // Extra width and height you want to add
    var extraWidth: CGFloat = 20
    var extraHeight: CGFloat = 0

    override var intrinsicContentSize: CGSize {
        // Get the intrinsic content size of the title label
        let titleSize = titleLabel?.intrinsicContentSize ?? CGSize.zero
        
        // Add extra padding
        let width = titleSize.width + extraWidth
        let height = titleSize.height + extraHeight
        
        return CGSize(width: width, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.size = intrinsicContentSize
    }
}


class FollowButton: BaseButton{
    
    var title: String = "Follow"{
        didSet{ setTitle(title, for: .normal) }
    }
    var selTitle: String = "Unfollow"{
        didSet{ setTitle(title, for: .normal) }
    }
    var titleColor: UIColor = .PrimaryColor{
        didSet{ setTitleColor(titleColor, for: .normal) }
    }
    var titleFont: UIFont = .customFont(style: .medium, size: 16){
        didSet{ titleLabel?.font = titleFont }
    }
    var isFollowed: Bool = false{
        didSet { updateButtonAppearance() }
    }
    
    var bgColor: UIColor = .clear{
        didSet{ updateButtonAppearance() }
    }
    
    var borderColor: UIColor = .PrimaryColor{
        didSet{ addborderView() }
    }
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        updateButtonAppearance()
        titleLabel?.font = titleFont
        addTarget(self, action: #selector(buttonPressed), for: [.touchDown,.touchDragInside,.touchDragOutside])
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    private func updateButtonAppearance() {
        if isFollowed{
            setTitle(selTitle, for: .normal)
            setTitleColor(titleColor, for: .normal)
        }else{
            setTitle(title, for: .normal)
            setTitleColor(titleColor, for: .normal)
        }
        backgroundColor = bgColor
        
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    @objc private func buttonPressed() {
        titleColor = .white
        backgroundColor = .surfaceButtonColor
        layer.borderWidth = 4
        layer.borderColor = UIColor.focus_borderColor.cgColor
    }
    
    @objc private func buttonReleased() {
        titleColor = .PrimaryColor
        backgroundColor = bgColor
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addborderView()
    }
    private func addborderView(){
        cornerRadiusWithBorder(corner: 6, borderwidth: 2, borderColor: borderColor)
    }

    override var intrinsicContentSize: CGSize {
        let labelWidth = titleLabel?.intrinsicContentSize.width ?? 0
        let labelHeight = titleLabel?.intrinsicContentSize.height ?? 0
        let width = labelWidth + 36
        let height = labelHeight + 14
        return CGSize(width: width, height: height)
    }

}



@IBDesignable class WatchLiveButton: BaseButton{
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "soundwave")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .ButtonTextColor
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Tap to watch Live"
        label.font = .customFont(style: .semiBold, size: 14)
        label.textColor = .ButtonTextColor
        return label
    }()
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        let stack = UIStackView(arrangedSubViews: [icon, label], axis: .horizontal, spacing: 8, distribution: .fill)
        stack.alignment = .fill
        addSubview(stack)
        stack.makeConstraints(toView: self, edge: .init(top: 4, left: 12, bottom: 4, right: 12))
        icon.sizeConstraints(width: 24, height: 24)
        
        setTitle("", for: .normal)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadiusWithBorder(isRound: false, corner: 8, borderwidth: 2, borderColor: .ButtonTextColor)
    }
}


@IBDesignable class LiveButton: BaseButton{
    
    var title: String = "Live"{
        didSet{ label.text = title }
    }
    
    private var liveView: UIView = {
        let view = UIView()
        view.backgroundColor = .ButtonTextColor
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .customFont(style: .semiBold, size: 12)
        label.textColor = .ButtonTextColor
        return label
    }()
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        let stack = UIStackView(arrangedSubViews: [liveView, label], axis: .horizontal, spacing: 5, distribution: .fill)
        stack.alignment = .fill
        addSubview(stack)
        stack.makeConstraints(toView: self,edge: .init(top: 8, left: 10, bottom: 8, right: 10))
        stack.makeCenterConstraints(toView: self)
        liveView.sizeConstraints(width: 8, height: 8)
        
        label.text = title
        setTitle("", for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeGradientColor()
        liveView.layer.cornerRadius = 4
        cornerRadiusWithBorder(isRound: true, corner: 0, borderwidth: 0, borderColor: .clear)
    }

    override var intrinsicContentSize: CGSize {
        let labelWidth = titleLabel?.intrinsicContentSize.width ?? 0
        let labelHeight = titleLabel?.intrinsicContentSize.height ?? 0
        let width = labelWidth + 36
        let height = labelHeight + 14
        return CGSize(width: width, height: height)
    }

}

@IBDesignable class CustomStreamBtn: BaseButton{
    
    @IBInspectable var title: String = "Schedule a livestream"{ didSet{ label.text = title } }
    @IBInspectable var imageName: String = "schedule_calender"{ didSet{ icon.image = UIImage(named: imageName) } }
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .ButtonTextColor
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .customFont(style: .semiBold, size: 10)
        label.textColor = .ButtonTextColor
        return label
    }()
    
    var stackView = UIStackView()
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        stackView = UIStackView(arrangedSubViews: [icon, label], axis: .horizontal, spacing: 8, distribution: .fill)
        stackView.alignment = .center
        addSubview(stackView)
        stackView.makeConstraints(toView: self, edge: .init(top: 6, left: 0, bottom: 6, right: 0))
        icon.sizeConstraints(width: 30, height: 30)
        
        label.text = title
        icon.image = UIImage(named: imageName)
        setTitle("", for: .normal)
    }
    func updatePostition(icon_first: Bool = true){
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Add subviews in the desired order based on verification
        if icon_first {
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(icon)
            stackView.alignment = .center
            label.textAlignment = .right
        } else {
            stackView.addArrangedSubview(icon)
            stackView.addArrangedSubview(label)
            stackView.alignment = .center
            label.textAlignment = .left
        }
    }
}
@IBDesignable class CustomCameraStreamBtn: BaseButton{
    
    @IBInspectable var title: String = "Schedule a livestream"{ didSet{ label.text = title } }
    @IBInspectable var imageName: String = "schedule_calender"{ didSet{
        guard !imageName.isEmpty else{ return }
        icon.image = UIImage(named: imageName)
    } }
    
    var isSelectedCamera: Bool = false{
        didSet{
            changeSelected()
        }
    }
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .customFont(style: .medium, size: 12)
        return label
    }()
    
    var stackView = UIStackView()
    
    override func initalizeUI() {
        super.initalizeUI()
        setupUI()
    }
    private func setupUI(){
        stackView = UIStackView(arrangedSubViews: [icon, label], axis: .horizontal, spacing: 4, distribution: .fill)
        stackView.alignment = .center
        addSubview(stackView)
        stackView.makeConstraints(toView: self, edge: .init(top: 6, left: 0, bottom: 6, right: 0))
        icon.sizeConstraints(width: 24, height: 24)
        
        label.text = title
        icon.image = UIImage(named: imageName)
        changeSelected()
        setTitle("", for: .normal)
    }
    private func changeSelected(){
        icon.tintColor = isSelectedCamera ? .ButtonTextColor : .TextTeritaryColor
        label.textColor = isSelectedCamera ? .ButtonTextColor : .TextTeritaryColor
    }
}
