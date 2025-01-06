//
//  UIVIew+Extension.swift
//  Live It
//
//  Created by Muniyaraj on 20/08/24.
//

import UIKit

extension UIView{
    func makeConstraints(toView parentView: UIView,edge const: UIEdgeInsets = .zero, isSafeArea: Bool = false){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: isSafeArea ? parentView.safeAreaLayoutGuide.topAnchor : parentView.topAnchor, constant: const.top).isActive = true
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: const.left).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -const.right).isActive = true
        bottomAnchor.constraint(equalTo: isSafeArea ? parentView.safeAreaLayoutGuide.bottomAnchor : parentView.bottomAnchor, constant: -const.bottom).isActive = true
    }
    func makeConstraints(top: NSLayoutYAxisAnchor?,leading: NSLayoutXAxisAnchor?,trailing: NSLayoutXAxisAnchor?,bottom: NSLayoutYAxisAnchor?,width: CGFloat? = nil,height: CGFloat? = nil,edge const: UIEdgeInsets = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        var anchors: AnchoredConstraints = AnchoredConstraints()
        if let top{
            anchors.top = topAnchor.constraint(equalTo: top, constant: const.top)
        }
        if let leading{
            anchors.leading = leadingAnchor.constraint(equalTo: leading, constant: const.left)
        }
        if let trailing{
            anchors.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -const.right)
        }
        if let bottom{
            anchors.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -const.bottom)
        }
        if let width{
            anchors.width = widthAnchor.constraint(equalToConstant: width)
        }
        if let height{
            anchors.height = heightAnchor.constraint(equalToConstant: height)
        }
        [anchors.top,anchors.leading,anchors.trailing,anchors.bottom,anchors.width,anchors.height].forEach{ $0?.isActive = true }
    }
    struct AnchoredConstraints{
        var top,leading,trailing,bottom,width,height: NSLayoutConstraint?
    }
    func sizeConstraints(toView: UIView,multipler: CGFloat = 0.4){
        widthAnchor.constraint(equalTo: toView.widthAnchor, multiplier: 0.4).isActive = true
        heightAnchor.constraint(equalTo: toView.heightAnchor, multiplier: 0.4).isActive = true
    }
    func sizeConstraints(width: CGFloat,height: CGFloat){
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    func widthConstraints(width: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    func heightConstraints(height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    func EqualsizeConstraints(size const: CGFloat){
        widthAnchor.constraint(equalToConstant: const).isActive = true
        heightAnchor.constraint(equalToConstant: const).isActive = true
    }
    func makeViewMultiplierWidth(toView view: UIView,width: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: width).isActive = true
    }
    func makeViewMultiplierHeight(toView view: UIView,height: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: height).isActive = true
    }
    func makeCenterConstraints(toView: UIView,centerX: CGFloat = 0,centerY: CGFloat = 0,centerX_axis: Bool = true,centerY_axis: Bool = true){
        translatesAutoresizingMaskIntoConstraints = false
        if centerX_axis{
            centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: centerX).isActive = true
        }
        if centerY_axis{
            centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: centerY).isActive = true
        }
    }
    func cornerRadiusWithBorder(isRound: Bool = false,corner radius: CGFloat = 4,borderwidth const: CGFloat = 0.6,borderColor color: UIColor = .lightGray){
        layer.cornerRadius = isRound ? (frame.height / 2) : radius
        layer.borderWidth = const
        layer.borderColor = color.cgColor
        clipsToBounds = true
    }
}

extension UIView{
    func addTap(count : Int = 1,action : @escaping() -> Void){
        let tap = MyGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = count
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    @objc func handleTap(_ sender: MyGestureRecognizer){
        sender.action?()
    }
    
    class MyGestureRecognizer : UITapGestureRecognizer{
        var action : (()->(Void))? = nil
    }
}



extension UITextField {
    func setPlaceholder(text: String, font: UIFont, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: color
            ]
        )
    }
}

extension UITabBar {
    func applyShadow(
        shadowColor: UIColor = .lightGray,
        shadowOffset: CGSize = CGSize(width: 0.0, height: 0.2),
        shadowRadius: CGFloat = 5,
        shadowOpacity: Float = 1,
        backgroundColor: UIColor = .white) {
        
        // Set background color and shadow image to make shadow visible
        clipsToBounds = true
        shadowImage = UIImage()
        backgroundImage = UIImage().withTintColor(backgroundColor)
        
        // Apply shadow properties
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
    }
}
