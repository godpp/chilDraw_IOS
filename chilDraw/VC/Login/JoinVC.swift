//
//  JoinVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 11. 28..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class JoinVC : UIViewController, NetworkCallback, UIGestureRecognizerDelegate{
    
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var pwdTxt: UITextField!
    @IBOutlet var confirmpwdTxt: UITextField!
    @IBOutlet var joinBtn: UIButton!
    
    @IBOutlet var nameChk: UILabel!
    @IBOutlet var emailChk: UILabel!
    @IBOutlet var pwdChk: UILabel!
    @IBOutlet var confpwdChk: UILabel!
    
    @IBOutlet var centerConstraintY: NSLayoutConstraint!
    @IBOutlet var logoLabel: UIImageView!
    @IBOutlet var joinStackView: UIStackView!
    
    var check = true
    var msg : String?
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        self.initAddTarget()
        nameChk.isHidden = true
        emailChk.isHidden = true
        pwdChk.isHidden = true
        confpwdChk.isHidden = true
        unablejoinBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    @IBAction func exitBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func initAddTarget(){
        joinBtn.addTarget(self, action: #selector(join), for: .touchUpInside)
        usernameTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        usernameTxt.addTarget(self, action: #selector(duplicateCheck), for: .editingChanged)
        emailTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        emailTxt.addTarget(self, action: #selector(duplicateCheck), for: .editingChanged)
        pwdTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        confirmpwdTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        confirmpwdTxt.addTarget(self, action: #selector(confirmCheck), for: .editingChanged)
    }
    
    @objc func join() {
        let model = JoinModel(self)
        let nickname = gsno(usernameTxt.text)
        let email = gsno(emailTxt.text)
        let password = gsno(pwdTxt.text)
        
        model.createMember(email: email, pwd: password, gender: "", nickname: nickname, image: "", age: 1)
    }
    
    func unablejoinBtn(){
        self.joinBtn.isEnabled = false
    }
    func enablejoinBtn(){
        self.joinBtn.isEnabled = true
    }
    
    @objc func isValid(){
        if !((usernameTxt.text?.isEmpty)! || (emailTxt.text?.isEmpty)! || (pwdTxt.text?.isEmpty)! || (confirmpwdTxt.text?.isEmpty)!) {
            enablejoinBtn()
        }
        else {
            unablejoinBtn()
        }
    }
    
    @objc func duplicateCheck(_ sender: UITextField) {
        let model = JoinModel(self)
        if sender == usernameTxt {
            let name = gsno(usernameTxt.text)
            //model.usernameCheck(nickname: name, flag: 1)
        }
        else if sender == emailTxt {
            let email = gsno(emailTxt.text)
            //model.emailCheck(email: email, flag: 2)
        }
        else if sender == emailTxt {
            let email = gsno(emailTxt.text)
            //model.emailCheck(email: email, flag: 2)
        }
        else if sender == pwdTxt {
            let email = gsno(pwdTxt.text)
            //model.emailCheck(email: email, flag: 2)
        }
    }
    @objc func confirmCheck() {
        if pwdTxt.text == confirmpwdTxt.text {
            confpwdChk.isHidden = true
        }
        else {
            confpwdChk.isHidden = false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: joinStackView))!{
            return false
        }
        return true
    }
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.joinStackView.becomeFirstResponder()
        self.joinStackView.resignFirstResponder()
        
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if check {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                centerConstraintY.constant = -130
                check = false
                logoLabel.isHidden = true
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            centerConstraintY.constant = 0
            check = true
            logoLabel.isHidden = false
            view.layoutIfNeeded()
        }
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "1"{
            guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
            self.present(loginVC, animated: true)
        }
        else if code == "2"{
            
        }
        else if code == "3"{
            
        }
        else if code == "4"{
            
        }
        else if code == "5"{
            
        }
        else if code == "6"{
            
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "오류", msg: "네트워크 연결 오류")
    }
    
    
}
