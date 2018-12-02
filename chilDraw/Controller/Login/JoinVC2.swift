//
//  JoinVC2.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 3. 31..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import UIKit

class JoinVC2 : UIViewController, NetworkCallback, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var emailData : String?
    var pwdData : String?
    var usernameData : String?
    
    var check = true
    var gender = "unknown"
    var age = -1
    
    var boy_off : UIImage = UIImage(named: "sign_boy_off")!
    var boy_on : UIImage = UIImage(named: "sign_boy_on")!
    var girl_off : UIImage = UIImage(named: "sign_girl_off")!
    var girl_on : UIImage = UIImage(named: "sign_girl_on")!
    
    @IBOutlet var signupBtn: UIButton!
    @IBOutlet var boyBtn: UIButton!
    @IBOutlet var girlBtn: UIButton!
    @IBOutlet var ageLabel: UITextField!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var logoLabel: UIImageView!
    @IBOutlet var centerConstraintY: NSLayoutConstraint!
    
    var ageArray = [String]()
    
    override func viewDidLoad() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        signupBtn.isEnabled = false
        var pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        ageLabel.inputView = pickerView
        
        for i in 0..<14{
            ageArray.append("\(i)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    @IBAction func signupBtn(_ sender: Any) {
        let model = JoinModel(self)
        model.createMember(
            email: gsno(emailData),
            pwd: gsno(pwdData),
            gender: gender,
            nickname: gsno(usernameData),
            age: gino(age)
        )
    }
    
    
    @IBAction func girlBtn(_ sender: Any) {
        if gender == "male"{
            boyBtn.setImage(boy_off, for: .normal)
        }
        girlBtn.setImage(girl_on, for: .normal)
        gender = "female"
        isValid()
    }
    @IBAction func boyBtn(_ sender: Any) {
        if gender == "female"{
            girlBtn.setImage(girl_off, for: .normal)
        }
        boyBtn.setImage(boy_on, for: .normal)
        gender = "male"
        isValid()
    }
    
    //signup 활성화
    func isValid(){
        if gender != "unknown" && age != -1{
            signupBtn.isEnabled = true
        }
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        
        ageLabel.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        ageLabel.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 피커 뷰에서 구성 요소의 설정 번호
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //구성 요소의 행 수를 설정
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    
    //각 행에 대해 제목 설정
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
        ) -> String? {
        return ageArray[row]
    }
    
    //행이 선택 될 때 텍스트 필드에 텍스트를 업데이트
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int) {
        ageLabel.text = ageArray[row] + " 세"
        age = gino(Int(ageArray[row]))
        isValid()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func networkResult(resultData: Any, code: String) {
        if code == "1"{
            let msg = resultData as? String
            print(gsno(msg))
            
            guard let loginVC = storyboard?.instantiateViewController(
                withIdentifier: "LoginVC"
                ) as? LoginVC
                else {return}
            self.present(loginVC, animated: true)
        }
        else if code == "2"{
            let msg = resultData as? String
            simpleAlert(title: "오류", msg: gsno(msg))
        }
        else if code == "3"{
            let msg = resultData as? String
            simpleAlert(title: "오류", msg: gsno(msg))
        }
        else if code == "4"{
            let msg = resultData as? String
            simpleAlert(title: "오류", msg: gsno(msg))
        }
        else if code == "5"{
            let msg = resultData as? String
            simpleAlert(title: "오류", msg: gsno(msg))
        }
        else {
            let msg = resultData as? String
            simpleAlert(title: "오류", msg: gsno(msg))
        }
    }
    
    func networkFailed() {
        
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
        ) -> Bool {
        if(touch.view?.isDescendant(of: stackView))!{
            return false
        }
        return true
    }
    
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.stackView.becomeFirstResponder()
        self.stackView.resignFirstResponder()
        
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
