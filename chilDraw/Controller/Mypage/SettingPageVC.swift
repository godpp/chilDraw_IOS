//
//  SettingPageVC.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 27..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import UIKit

class SettingPageVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NetworkCallback, UIGestureRecognizerDelegate{
    
    @IBOutlet var drawnCollectionView: UICollectionView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    
    // popupview outlet
    @IBOutlet var popupViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var popupViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var popupView: UIView!
    @IBOutlet var changingTextField: UITextField!
    @IBOutlet var dupNicknameLabel: UILabel!
    @IBOutlet var graybackgroundImageView: UIImageView!
    @IBOutlet var logoutButton: UIButton!
    
    var resultList: SettingResultVO?
    var drawnList: [DrawnResultVO] = []
    let ud = UserDefaults.standard
    let user_token = UserDefaults.standard.string(forKey: "token")
    let imagePicker = UIImagePickerController()
    
    var check = true
    
    @objc func logout(){
        ud.setValue("", forKey: "token")
        ud.synchronize()
        
        let alert = UIAlertController(
            title: "로그아웃",
            message: "로그아웃 하시겠습니까?",
            preferredStyle: .alert
        )
        let OKAction = UIAlertAction(
            title: "네!",
            style: UIAlertActionStyle.default,
            handler: {
                (_)in
                let appsDelegate = UIApplication.shared.delegate
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                guard let splashVC: SplashVC = storyboard.instantiateInitialViewController()
                    as? SplashVC
                    else {return}
                appsDelegate?.window!!.rootViewController = splashVC
        })
        let cancleAction = UIAlertAction(title: "아니요!", style: .cancel)
        
        alert.addAction(OKAction)
        alert.addAction(cancleAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap_mainview(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        popupView.layer.shadowColor = UIColor.darkGray.cgColor
        popupView.layer.shadowRadius = 20
        popupView.layer.shadowOpacity = 1.0
        popupView.layer.shadowOffset = CGSize(width: 0, height: 0)
        graybackgroundImageView.isHidden = true
        dupNicknameLabel.isHidden = true
        changingTextField.addTarget(self, action: #selector(nicknameChangingEditing), for: .editingChanged)
        
        drawnCollectionView.delegate = self
        drawnCollectionView.dataSource = self
        drawnCollectionView.tintColor = UIColor.clear
        drawnCollectionView.backgroundColor = UIColor.clear
        
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        
        let model = SettingModel(self)
        model.drawnLoadingModel(token: gsno(user_token))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    // 키보드 제스처
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
        ) -> Bool {
        if(touch.view?.isDescendant(of: popupView))!{
            return false
        }
        return true
    }
    @objc func handleTap_mainview(_ sender: UITapGestureRecognizer?){
        self.popupView.becomeFirstResponder()
        self.popupView.resignFirstResponder()
        
    }

    // 네트워킹 메소드
    func networkResult(resultData: Any, code: String) {
        if code == "1"{
            resultList = resultData as? SettingResultVO
            nicknameLabel.text = resultList?.nickname!
            profileImageView.imageFromUrl(gsno(resultList?.image), defaultImgPath: "setting_button_profile")
            drawnList = (resultList?.drawArr!)!
            drawnCollectionView.reloadData()
            print("sss")
        }
        else if code == "5"{
            let errormsg = resultData as? String
            simpleAlert(title: gsno(errormsg), msg: "관리자에게 문의하세요.")
        }
        else if code == "new nickname"{
            popupViewCenterXConstraint.constant = 1000
            UIView.animate(withDuration: 0.5, animations: {
                let model = SettingModel(self)
                model.drawnLoadingModel(token: self.user_token!)
                self.graybackgroundImageView.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
        else if code == "duplicate nickname"{
            dupNicknameLabel.isHidden = false
            changingTextField.text = ""
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인하세요.")
    }
    
    // 닉네임 변경 메소드
    @IBAction func nicknameChangingButton(_ sender: Any) {
        changingTextField.text = ""
        graybackgroundImageView.isHidden = false
        popupViewCenterXConstraint.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }   )
    }
    @IBAction func popupviewCancelButton(_ sender: Any) {
        graybackgroundImageView.isHidden = true
        popupViewCenterXConstraint.constant = 1000
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func popupviewOKButton(_ sender: Any) {
        let newNickname = changingTextField.text
        let model = SettingModel(self)
        model.nicknamechanginggModel(nickname: gsno(newNickname), token: gsno(user_token))
    }
    
    @objc func nicknameChangingEditing(){
        dupNicknameLabel.isHidden = true
    }
    
    // 프로필 사진 변경 메소드
    @IBAction func profileImageChangingButton(_ sender: Any) {
        let alert = UIAlertController(title: "프로필 사진 변경", message: nil, preferredStyle: .actionSheet)
        let pickOnGallery = UIAlertAction(title: "앨범에서 사진 선택", style: .default){
            (_) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let changeDefault = UIAlertAction(title: "기본이미지로 변경", style: .default){
            (_) in
            let defaultImg = UIImage(named: "setting_button_profile")
            self.profileImageView.image = defaultImg
            let model = SettingModel(self)
            let image = UIImageJPEGRepresentation(defaultImg!, 0.5)
            model.profileImageChangingModel(image: image!, token: self.user_token!)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(pickOnGallery)
        alert.addAction(changeDefault)
        alert.addAction(cancelAction)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = (sender as AnyObject).bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 아이가 그린 그림 콜렉션뷰 메소드
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = drawnCollectionView.dequeueReusableCell(
            withReuseIdentifier: "drawnCell",
            for: indexPath
            ) as! drawnCell
        let row = drawnList[indexPath.row]
        cell.drawnImageView.imageFromUrl(gsno(row.draw), defaultImgPath: "")
        cell.layoutIfNeeded()
        cell.layer.cornerRadius = 15
        cell.drawnImageView.clipsToBounds = true
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        
        return drawnList.count
    }
    
    // 키보드 메소드
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
        NotificationCenter.default.removeObserver(
            self,
            name:.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name:.UIKeyboardWillHide,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if check {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
                as? NSValue)?.cgRectValue {
                popupViewCenterYConstraint.constant = -150
                check = false
                view.layoutIfNeeded()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            popupViewCenterYConstraint.constant = 0
            check = true
            view.layoutIfNeeded()
        }
    }
}

// 사진첩 익스텐션
extension SettingPageVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]
        ) {
        var newImage: UIImage
        
       picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            
            return
        }
        profileImageView.image = newImage
        let model = SettingModel(self)
        let image = UIImageJPEGRepresentation(newImage, 0.5)
        model.profileImageChangingModel(image: image!, token: user_token!)
        dismiss(animated: true, completion: nil)
    }
}
