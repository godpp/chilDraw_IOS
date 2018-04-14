//
//  LoginVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 11. 28..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class LoginVC : UIViewController, NetworkCallback, UIGestureRecognizerDelegate{
    
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var pwdTxt: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var loginStackView: UIStackView!
    @IBOutlet var logoImgView: UIImageView!
    
    @IBOutlet var centerConstraintY: NSLayoutConstraint!
    
    var check = true
    var msg : String?
    let ud = UserDefaults.standard
    var userInfo : UserInfoVO?
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        self.initAddTarget()
        unableLoginBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    @IBAction func RegisterBtn(_ sender: Any) {
        guard let joinVC1 = storyboard?.instantiateViewController(withIdentifier: "JoinVC1") as? JoinVC1 else {return}
        self.present(joinVC1, animated: true)
    }
    
    func initAddTarget(){
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        emailTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
        pwdTxt.addTarget(self, action: #selector(isValid), for: .editingChanged)
    }
    
    func unableLoginBtn(){
        self.loginBtn.isEnabled = false
    }
    func enableLoginBtn(){
        self.loginBtn.isEnabled = true
    }
    
    @objc func login() {
        let model = LoginModel(self)
        let email = gsno(emailTxt.text)
        let password = gsno(pwdTxt.text)
        model.login(email: email, pwd: password)
    }
    
    @objc func isValid(){
        if !((emailTxt.text?.isEmpty)! || (pwdTxt.text?.isEmpty)!) {
            enableLoginBtn()
        }
        else {
            unableLoginBtn()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: loginStackView))!{
            return false
        }
        return true
    }
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.loginStackView.becomeFirstResponder()
        self.loginStackView.resignFirstResponder()
        
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
                centerConstraintY.constant = -150
                check = false
                logoImgView.isHidden = true
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            centerConstraintY.constant = 150
            check = true
            logoImgView.isHidden = false
            view.layoutIfNeeded()
        }
    }
    
    func networkResult(resultData: Any, code: String) {
        print(code)
        if code == "1"{
            userInfo = resultData as? UserInfoVO
            ud.setValue(gsno(userInfo?.token), forKey: "token")
            ud.synchronize()
            let main_storyboard = UIStoryboard(name: "Main", bundle: nil)
            //메인 뷰컨트롤러 접근
            guard let main = main_storyboard.instantiateViewController(withIdentifier: "MainVC") as? MainVC else {return}
            self.present(main, animated: true)
        }
        else{
            msg = resultData as? String
            simpleAlert(title: "로그인 실패", msg: msg!)
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 연결 오류", msg: "인터넷 연결을 확인하세요.")
    }
    
}
