//
//  JoinVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 11. 28..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class JoinVC1 : UIViewController, UIGestureRecognizerDelegate, NetworkCallback{
    
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var pwdTxt: UITextField!
    @IBOutlet var confirmpwdTxt: UITextField!
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet var nameChk: UILabel!
    @IBOutlet var emailChk: UILabel!
    @IBOutlet var pwdChk: UILabel!
    @IBOutlet var confpwdChk: UILabel!
    
    @IBOutlet var centerConstraintY: NSLayoutConstraint!
    @IBOutlet var logoLabel: UIImageView!
    @IBOutlet var joinStackView: UIStackView!
    
    var check = true
    var msg : String?
    
    var username : String?
    var email : String?
    var pwd : String?
    
    func networkResult(resultData: Any, code: String) {
        if code == "dup_email_ok"{
            emailChk.isHidden = true
        }
        else if code == "dup_email_fail"{
            emailChk.isHidden = false
        }
        else{
            simpleAlert(title: "중복확인 오류", msg: "개발자에게 문의하세요.")
        }
        
        if code == "dup_name_ok"{
            nameChk.isHidden = true
        }
        else if code == "dup_name_fail"{
            nameChk.isHidden = false
        }
        else{
            simpleAlert(title: "중복확인 오류", msg: "개발자에게 문의하세요.")
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인하세요.")
    }
    
    //중복확인
    @objc func duplicateCheck(_ sender: UITextField) {
        let model = JoinModel(self)
        if sender == usernameTxt {
            let name = gsno(usernameTxt.text)
            model.duplicateNickname(nickname: name)
        }
        else if sender == emailTxt{
            let email = gsno(emailTxt.text)
            model.duplicateEmail(email: email)
        }
    }
    
    //패스워드 일치 확인
    @objc func confirmCheck() {
        if pwdTxt.text == confirmpwdTxt.text {
            confpwdChk.isHidden = true
        }
        else {
            confpwdChk.isHidden = false
        }
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        username = gsno(usernameTxt.text)
        email = gsno(emailTxt.text)
        pwd = gsno(confirmpwdTxt.text)
        
        guard let joinVC2 = storyboard?.instantiateViewController(withIdentifier : "JoinVC2") as? JoinVC2
            else{return}
        
        joinVC2.emailData = username
        joinVC2.pwdData = pwd
        joinVC2.usernameData = username
        self.present(joinVC2, animated: true)
        
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        self.initAddTarget()
        nameChk.isHidden = true
        emailChk.isHidden = true
        pwdChk.isHidden = true
        confpwdChk.isHidden = true
        unablenextBtn()
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
        usernameTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        usernameTxt.addTarget(self, action: #selector(duplicateCheck), for: .editingChanged)
        emailTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        emailTxt.addTarget(self, action: #selector(duplicateCheck), for: .editingChanged)
        pwdTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        confirmpwdTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        confirmpwdTxt.addTarget(self, action: #selector(confirmCheck), for: .editingChanged)
    }
    
    
    func unablenextBtn(){
        self.nextBtn.isEnabled = false
    }
    func enablenextBtn(){
        self.nextBtn.isEnabled = true
    }
    
    @objc func isValid(){
        if !((usernameTxt.text?.isEmpty)! || (emailTxt.text?.isEmpty)! || (pwdTxt.text?.isEmpty)! || (confirmpwdTxt.text?.isEmpty)!) {
            enablenextBtn()
        }
        else {
            unablenextBtn()
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
    
    
}
