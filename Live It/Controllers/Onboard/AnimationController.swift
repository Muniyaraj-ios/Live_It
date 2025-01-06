//
//  AnimationController.swift
//  Live It
//
//  Created by Muniyaraj on 22/08/24.
//

import UIKit

final class AnimationController: BaseController {

    private let currentView = UIView()
    private let nextView = UIView()
    private let continueButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupButtons()
    }
    
    private func setupViews() {
        // Setup current view
        currentView.backgroundColor = .systemPink
        currentView.frame = view.bounds
        view.addSubview(currentView)
        
        // Setup next view (initially hidden)
        nextView.backgroundColor = .systemBlue
        nextView.frame = view.bounds
        nextView.isHidden = true
        view.addSubview(nextView)
    }
    
    private func setupButtons() {
        // Setup continue button
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        continueButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        continueButton.center = currentView.center
        currentView.addSubview(continueButton)
        continueButton.backgroundColor = .orange
        
        // Setup back button
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        backButton.center = nextView.center
        nextView.addSubview(backButton)
        backButton.backgroundColor = .green
    }
    
//    @objc private func didTapContinue() {
//        // Animate transition from currentView to nextView with push animation
//        nextView.isHidden = false
//        nextView.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
//        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.currentView.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//            self.nextView.frame = self.view.bounds
//        }) { _ in
//            self.currentView.isHidden = true
//        }
//    }
//    
//    @objc private func didTapBack() {
//        // Animate transition from nextView to currentView with pop animation
//        currentView.isHidden = false
//        currentView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
//        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.currentView.frame = self.view.bounds
//            self.nextView.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//        }) { _ in
//            self.nextView.isHidden = true
//        }
//    }
}
extension AnimationController{
    @objc private func didTapContinue() {
        // Ensure nextView is visible before the animation starts
        nextView.isHidden = false

        // Set the initial position of nextView off-screen to the right
        nextView.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        // Animate both views: currentView slides to the left and nextView slides in
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.currentView.frame = CGRect(x: -self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.nextView.frame = self.view.bounds
        }, completion: { _ in
            // After the animation is complete, hide the currentView
            self.currentView.isHidden = true
        })
    }

    @objc private func didTapBack() {
        // Ensure currentView is visible before the animation starts
        currentView.isHidden = false
        
        // Set the initial position of currentView off-screen to the left
        currentView.frame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        // Animate both views: currentView slides in and nextView slides to the right
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.currentView.frame = self.view.bounds
            self.nextView.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: { _ in
            // After the animation is complete, hide the nextView
            self.nextView.isHidden = true
        })
    }

}
