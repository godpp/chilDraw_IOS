//
//  VoiceVC.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 5. 24..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AMProgressBar

class VoiceVC : UIViewController, AVAudioRecorderDelegate, NetworkCallback{
    
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var goodjobImageView: UIImageView!
    @IBOutlet var retryImageView: UIImageView!
    @IBOutlet var recognizingLabel: UILabel!
    @IBOutlet var progressBar: AMProgressBar!
    @IBOutlet var clearPopupButton: UIButton!
    @IBOutlet var recognizingButton: UIButton!
    
    @IBOutlet var preventDupButton: UIButton!
    //MARK: 문제 세팅 변수들
    let user_token = UserDefaults.standard.string(forKey: "token")
    var wordData : String?
    var categoryNumData : Int?
    var arrNumData : Int?
    var wordArr : String?
    var word_idArr : String?
    var room_idData : Int?
    var word_idData : Int?
    var data : RandomMessageVO?
    
    //MARK: 녹음 변수들
    var recordingTime = 2.0
    var audioNum : Int = 1
    var voiceresult : Bool?
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGranted: Bool!
    var audioURL : URL!
    
    
    func networkResult(resultData: Any, code: String) {
        if code == "voice result"{
            voiceresult = resultData as? Bool
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.progressBar.setProgress(progress: 0, animated: true)
            }
            //정답
            if voiceresult == true{
                goodjobImageView.isHidden = false
                recognizingLabel.text = "정답이에요! 멍!"
                let model = MainModel(self)
                model.categoryChoiceModel(
                    category: categoryNumData!,
                    arrNum: arrNumData!,
                    wordArr:  wordArr!,
                    word_idArr: word_idArr!,
                    token: user_token!
                )
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
                    self.recognizingLabel.text = ""
                    self.goodjobImageView.isHidden = true
                    self.preventDupButton.isHidden = true
                }
            }
            //오답
            else{
                retryImageView.isHidden = false
                recognizingLabel.text = "다시 발음해보세요! 멍!"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
                    self.recognizingLabel.text = ""
                    self.retryImageView.isHidden = true
                    self.preventDupButton.isHidden = true
                }
            }
        }
        else if code == "success"{
            data = resultData as? RandomMessageVO
            room_idData = data?.room_id!
            wordData = data?.word!
            arrNumData = data?.arrNum!
            wordArr = data?.wordArr!
            word_idArr = data?.word_idArr!
            word_idData = data?.word_id!
            audioNum += 1
            
            wordLabel.text = gsno(wordData)
            goodjobImageView.isHidden = false
            
            //정답 표시
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
                self.goodjobImageView.isHidden = true
            }
            
        }
            //카테고리 종료
        else if code == "finish"{
            goodjobImageView.isHidden = false
            clearPopupButton.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0){
                self.clearPopupButton.isHidden = true
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인해주세요!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        audioRecorder = nil
    }
    
    //MARK: 녹음 버튼 액션
    @IBAction func recordingButtonAction(_ sender: Any) {
        preventDupButton.isHidden = false
        recognizingLabel.text = "3초간 발음해보세요!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.progressBar.setProgress(progress: 0.33, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.progressBar.setProgress(progress: 0.66, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.progressBar.setProgress(progress: 1, animated: true)
        }
        
        if isAudioRecordingGranted {
            
            //Create the session.
            let session = AVAudioSession.sharedInstance()
            
            do {
                //Configure the session for recording and playback.
                try session.setCategory(
                    AVAudioSessionCategoryPlayAndRecord,
                    with: .defaultToSpeaker
                )
                try session.setActive(true)
                //Set up a high-quality recording session.
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                //Create audio file name URL
                let audioFilename = getDocumentsDirectory().appendingPathComponent(
                    gsno(wordData)+"_"+gsno("\(gino(word_idData))")+"_"+gsno("\(gino(room_idData))")+".wav"
                )
                
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                //                audioRecorder.isMeteringEnabled = true
                audioRecorder.record()
                audioURL = try audioRecorder?.url
            }
            catch let error {
                print("Error for start audio recording: \(error.localizedDescription)")
            }
        }
        recordingAutoStop()
    }
    
    func recordingAutoStop(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + recordingTime){
            self.finishAudioRecording(success: true)
        }
    }
    
    func finishAudioRecording(success: Bool) {
        
        let model = MainModel(self)
        
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("Recording finished successfully.")
            //음성파일 보내기
            if let theUrl = audioURL {
                do {
                    let audioData = try Data(contentsOf: theUrl as URL)
                    let audioName = gsno(wordData)+"_"+gsno("\(gino(word_idData))")+"_"+gsno("\(gino(room_idData))")+".wav"
                    print(audioName)
                    model.recordModel(voice: audioData, token: gsno(user_token), fileName: audioName, word_id: gino(word_idData))
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
        } else {
            print("Recording failed :(")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK:- Audio recoder delegate methods
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if !flag {
            finishAudioRecording(success: false)
        }
    }
    
    @IBAction func exitButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        //문제 단어 설정
        wordLabel.text = gsno(wordData)
        recognizingLabel.text = "버튼을 눌러주세요!"
        
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
                }
            }
            break
        default:
            break
        }
    }
    
}
