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
        //이메일 중복확인
        if code == "dup_email_ok"{
            emailChk.text = "이메일 중복입니다."
            emailChk.isHidden = true
        }
        else if code == "dup_email_fail"{
            emailChk.text = "이메일 중복입니다."
            emailChk.isHidden = false
        }
        else if code == "4"{
            simpleAlert(title: "중복확인 오류", msg: "개발자에게 문의하세요.")
        }
        //닉네임 중복확인
        if code == "dup_name_ok"{
            nameChk.text = "닉네임 중복입니다."
            nameChk.isHidden = true
        }
        else if code == "dup_name_fail"{
            nameChk.text = "닉네임 중복입니다."
            nameChk.isHidden = false
        }
        else if code == "3"{
            simpleAlert(title: "중복확인 오류", msg: "개발자에게 문의하세요.")
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인하세요.")
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTxt {
            emailTxt.becomeFirstResponder()
        } else if textField == emailTxt {
            pwdTxt.becomeFirstResponder()
        } else if textField == pwdTxt{
            confirmpwdTxt.becomeFirstResponder()
        } else if textField == confirmpwdTxt{
            textField.resignFirstResponder()
        }
        return true
    }
    
    //중복확인 모델
    @objc func duplicateCheck(_ sender: UITextField) {
        let model = JoinModel(self)
        if sender == usernameTxt {
            let name = gsno(usernameTxt.text)
            model.duplicateNickname(nickname: name)
        }
        else if sender == emailTxt{
            let email = gsno(emailTxt.text)
            
            if validateEmail(enteredEmail: email){
                model.duplicateEmail(email: email)
            }
            else{
                emailChk.text = "abc@abc.com 이메일 형식을 맞춰주세요!"
                emailChk.isHidden = false
                emailTxt.text = ""
            }
        }
        isValid()
    }
    
    //패스워드 일치 확인
    @objc func confirmCheck() {
        if pwdTxt.text == confirmpwdTxt.text {
            confpwdChk.isHidden = true
        }
        else {
            confpwdChk.isHidden = false
        }
        isValid()
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        username = gsno(usernameTxt.text)
        email = gsno(emailTxt.text)
        pwd = gsno(confirmpwdTxt.text)
        
        guard let joinVC2 = storyboard?.instantiateViewController(
            withIdentifier : "JoinVC2"
            ) as? JoinVC2
            else{return}
        
        joinVC2.emailData = email
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
        
        self.usernameTxt.delegate = self
        self.emailTxt.delegate = self
        self.pwdTxt.delegate = self
        self.confirmpwdTxt.delegate = self
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
        usernameTxt.addTarget(self, action: #selector(duplicateCheck), for: .editingDidEnd)
        emailTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        emailTxt.addTarget(self, action: #selector(duplicateCheck), for: .editingDidEnd)
        pwdTxt.addTarget(self, action: #selector(pwdCheck), for: .editingDidEnd)
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
    
    @objc func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    @objc func validatePwd(enteredPwd:String) -> Bool {
        
        let pwdFormat = "(?=.*[0-9])(?=.*[a-z]).{6,}"
        let pwdPredicate = NSPredicate(format:"SELF MATCHES %@", pwdFormat)
        return pwdPredicate.evaluate(with: enteredPwd)
    }
    
    @objc func isValid(){
        if !((usernameTxt.text?.isEmpty)! ||
            (emailTxt.text?.isEmpty)! ||
            (pwdTxt.text?.isEmpty)! ||
            (confirmpwdTxt.text?.isEmpty)! ||
            (nameChk.isHidden) == false ||
            (emailChk.isHidden) == false ||
            pwdChk.isHidden == false ||
            confpwdChk.isHidden == false
            ) {
            
            enablenextBtn()
        }
        else {
            unablenextBtn()
        }
    }
    @objc func pwdCheck(){
        let enterPwd = gsno(pwdTxt.text)
        
        if validatePwd(enteredPwd: enterPwd) == false{
            pwdChk.text = "6자리이상의 영문+숫자조합!"
            pwdChk.isHidden = false
            pwdTxt.text = ""
        }
        else{
            pwdChk.isHidden = true
        }
        isValid()
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
        ) -> Bool {
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
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillShow),
            name: .UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillHide),
            name: .UIKeyboardWillHide,
            object: nil
        )
    }
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if check {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
                as? NSValue)?.cgRectValue {
                centerConstraintY.constant = -130
                check = false
                logoLabel.isHidden = true
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            centerConstraintY.constant = 0
            check = true
            logoLabel.isHidden = false
            view.layoutIfNeeded()
        }
    }
    
    
}
