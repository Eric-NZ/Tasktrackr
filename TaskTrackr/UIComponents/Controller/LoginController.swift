//
//  AuthViewController.swift
//  TaskTrackr
//
//  Created by Eric Ho on 9/11/18.
//  Copyright © 2018 LomoStudio. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var loginView: UIView!
    var userNameField: UnderlineTextField!
    var passwordField: UnderlineTextField!
    var backgroundColor: UIColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    
    private var loginRequest: ((_ userName: String, _ password: String)->Void)?
    
    // handle event that user taps the login button
    public func handleLoginRequest(handler: @escaping ((String, String)->Void)) {
        self.loginRequest = handler
    }
    
    // login error remind with animation
    public func loginErrorWarning() {
        UIView.animate(withDuration: 5) {
            self.userNameField.setBottomBorder(backGroundColor: Static.getComplementaryForColor(color: self.backgroundColor), borderColor: self.backgroundColor)
            self.passwordField.setBottomBorder(backGroundColor: Static.getComplementaryForColor(color: self.backgroundColor), borderColor: self.backgroundColor)
        }
        self.userNameField.shake()
        self.passwordField.shake()
        UIView.animate(withDuration: 1) {
            self.userNameField.setBottomBorder(backGroundColor: self.backgroundColor, borderColor: Static.getComplementaryForColor(color: self.backgroundColor))
            self.passwordField.setBottomBorder(backGroundColor: self.backgroundColor, borderColor: Static.getComplementaryForColor(color: self.backgroundColor))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // set background
        view.backgroundColor = backgroundColor
        
        setupLoginForm()
    }
    
    private func setupLoginForm() {
        /*------------ Login Form -----------------*/
        let biggerSpace: CGFloat = 32
        let smallerSpace: CGFloat = 8
        let mediumSpace: CGFloat = 16
        let xLoginOrigin: CGFloat = 0
        let yLoginOrigin: CGFloat = view.bounds.height / 3
        let loginBounds = CGRect(x: xLoginOrigin, y: yLoginOrigin, width: view.bounds.width - xLoginOrigin, height: view.bounds.height - yLoginOrigin)
        loginView = UIView(frame: loginBounds)
        view.addSubview(loginView)
        /*------------ username field -----------------*/
        let userIconView = UIImageView(image: UIImage(named: "user"))
        userNameField = UnderlineTextField()
        userNameField.placeholder = "User Name"
        userNameField.setBottomBorder(backGroundColor: backgroundColor, borderColor: Static.getComplementaryForColor(color: backgroundColor))
        let userStackView = UIStackView(arrangedSubviews: [userIconView, userNameField])
        userStackView.axis = .horizontal
        userIconView.translatesAutoresizingMaskIntoConstraints = false
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userStackView.translatesAutoresizingMaskIntoConstraints = false
        userStackView.spacing = smallerSpace
        loginView.addSubview(userStackView)
        /*------------ password field -----------------*/
        let passwordIconView = UIImageView(image: UIImage(named: "password"))
        passwordField = UnderlineTextField()
        passwordField.placeholder = "Password"
        passwordField.setBottomBorder(backGroundColor: backgroundColor, borderColor: Static.getComplementaryForColor(color: backgroundColor))
        let passwordStackView = UIStackView(arrangedSubviews: [passwordIconView, passwordField])
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordIconView.translatesAutoresizingMaskIntoConstraints = false
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordStackView.spacing = smallerSpace
        loginView.addSubview(passwordStackView)
        /*------------ Login Button -----------------*/
        let loginButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setTitle("Log In", for: .normal)
            button.layer.cornerRadius = 5
            button.backgroundColor = Static.getComplementaryForColor(color: backgroundColor)
            button.showsTouchWhenHighlighted = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(loginTapped(_:)), for: .touchUpInside)
            return button
        }()
        let buttonStackView = UIStackView(arrangedSubviews: [loginButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.spacing = smallerSpace
        loginView.addSubview(buttonStackView)
        /*--------------signUp Entry----------------*/
        let signUpEntryButton: UIButton = {
            let button = UIButton(type: .system)
            let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [
                .foregroundColor : Static.getComplementaryForColor(color: backgroundColor),
                .font: UIFont.systemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "Sign Up", attributes: [
                .foregroundColor: Static.getComplementaryForColor(color: backgroundColor),
                .font: UIFont.systemFont(ofSize: 16)]))
            button.setAttributedTitle(attributedText, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        loginView.addSubview(signUpEntryButton)
        /*------------ set up constraints -----------------*/
        let formViews: [String: UIView] = ["userIconView": userIconView,
                                           "userNameField": userNameField,
                                           "userStackView": userStackView,
                                           "passwordIconView": passwordIconView,
                                           "passwordField": passwordField,
                                           "passwordStackView": passwordStackView,
                                           "loginButton": loginButton,
                                           "buttonStackView": buttonStackView,
                                           "signUpEntryButton": signUpEntryButton]
        let metrics: [String: CGFloat] = ["height": 30,
                                          "width": 30,
                                          "biggerSpace": biggerSpace,
                                          "mediumSpace": mediumSpace,
                                          "smallerSpace": smallerSpace]
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[userStackView(height)]", options: [], metrics: metrics, views: formViews).map {
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "H:|-mediumSpace-[userStackView]-biggerSpace-|", options: [], metrics: metrics, views: formViews).map {
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "H:[userIconView(width)]", options: [], metrics: metrics, views: formViews).map {
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "V:[userStackView]-mediumSpace-[passwordStackView(height)]", options: [], metrics: metrics, views: formViews).map{
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "H:|-mediumSpace-[passwordStackView]-biggerSpace-|", options: [], metrics: metrics, views: formViews).map{
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "H:[passwordIconView(width)]", options: [], metrics: metrics, views: formViews).map{
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "V:[passwordStackView]-biggerSpace-[buttonStackView]", options: [], metrics: metrics, views: formViews).map{
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "H:|-biggerSpace-[buttonStackView]-biggerSpace-|", options: [], metrics: metrics, views: formViews).map{
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "V:[signUpEntryButton(height)]-biggerSpace-|", options: [], metrics: metrics, views: formViews).map{
            return $0.isActive = true
        }
        let _ = NSLayoutConstraint.constraints(withVisualFormat: "H:|-smallerSpace-[signUpEntryButton]-smallerSpace-|", options: [], metrics: metrics, views: formViews).map{
            return $0.isActive = true
        }
    }
    
    @objc func loginTapped(_ sender: UIButton) {
        loginRequest?(userNameField.text ?? "", passwordField.text ?? "")
    }
}
