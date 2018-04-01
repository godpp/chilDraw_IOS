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
    var gender = -1
    
    var boy_off : UIImage = UIImage(named: "sign_boy_off")!
    var boy_on : UIImage = UIImage(named: "sign_boy_on")!
    var girl_off : UIImage = UIImage(named: "sign_girl_off")!
    var girl_on : UIImage = UIImage(named: "sign_girl_on")!
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    @IBAction func girlBtn(_ sender: Any) {
        if gender == 2{
            boyBtn.setImage(boy_off, for: .normal)
        }
        girlBtn.setImage(girl_on, for: .normal)
        gender = 1
    }
    @IBAction func boyBtn(_ sender: Any) {
        if gender == 1{
            girlBtn.setImage(girl_off, for: .normal)
        }
        boyBtn.setImage(boy_on, for: .normal)
        gender = 2
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageArray[row]
    }
    
    //행이 선택 될 때 텍스트 필드에 텍스트를 업데이트
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageLabel.text = ageArray[row] + " 세"
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func networkResult(resultData: Any, code: String) {
        
    }
    
    func networkFailed() {
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
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
