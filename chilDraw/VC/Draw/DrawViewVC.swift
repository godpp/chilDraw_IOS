//
//  DrawViewVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension Notification.Name{
    static let finish = Notification.Name("finish")
    static let refreshFileName = Notification.Name("refreshFileName")
}


class DrawViewVC : UIViewController, AVAudioRecorderDelegate, NetworkCallback{
    
    @IBOutlet var goodjob_ImgView: UIImageView!
    @IBOutlet var drawView: DrawVC!
    @IBOutlet var helpPageImgView: UIImageView!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var clearImageView: UIImageView!
    
    var delayInSeconds = 2.0
    var recordingTime = 4.0

    let user_token = UserDefaults.standard.string(forKey: "token")
    var wordData : String?
    var categoryNumData : Int?
    var arrNumData : Int?
    var wordArr : String?
    var word_idArr : String?
    var room_idData : Int?
    var word_idData : Int?
    
    var audioNum : Int = 1
    
    // 카테고리 종료 Notification 알림
    @objc func ParentDismiss(notification: NSNotification){
        clearImageView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 오디오 파일 이름 Notification 변경 알림
    @objc func audioFileNameRefresh(_ notification: Notification){
        if let audioDict = notification.object as? [String: Any]{
            if let word_id = audioDict["word_id"] as? Int{
                word_idData = word_id
            }
            if let word = audioDict["word"] as? String{
                wordData = word
            }
            if let audioN = audioDict["audioNum"] as? Int{
                audioNum = audioN
            }
        }
    }
    
    func simpleAlert1(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        present(alert, animated: true)
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }

    func autoDown() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
            self.helpPageImgView.isHidden = true
        }
    }
    
    func recordingAutoStop(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + recordingTime){
            self.finishAudioRecording(success: true)
        }
    }
    
    @IBAction func exitBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onEraseTapped(_ sender: Any) {
        drawView.erase()
    }
    
    func networkFailed() {
        
    }
    
    func networkResult(resultData: Any, code: String) {
        
    }
    
    //Variables
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var audioURL : URL!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        audioRecorder = nil
    }
    
    //MARK:- Audio recorder buttons action.
    @IBAction func audioRecorderAction(_ sender: UIButton) {
        simpleAlert1(title: "녹음중", msg: "4초간 녹음됩니다.")
        if isAudioRecordingGranted {
            
            //Create the session.
            let session = AVAudioSession.sharedInstance()
            
            do {
                //Configure the session for recording and playback.
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                try session.setActive(true)
                //Set up a high-quality recording session.
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                //Create audio file name URL
                let audioFilename = getDocumentsDirectory().appendingPathComponent(gsno(wordData)+"_"+gsno("\(gino(word_idData))")+"_"+gsno("\(gino(audioNum))")+".wav")

                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.record()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                print(audioFilename)
                audioURL =  try audioRecorder?.url
            }
            catch let error {
                print("Error for start audio recording: \(error.localizedDescription)")
            }
        }
        recordingAutoStop()
    }
    
    func finishAudioRecording(success: Bool) {
        
        let model = MainModel(self)
        
        audioRecorder.stop()
        audioRecorder = nil
        meterTimer.invalidate()
        
        if success {
            print("Recording finished successfully.")
            //음성파일 보내기
            if let theUrl = audioURL {
                do {
                    let audioData = try Data(contentsOf: theUrl as URL)
                    let audioName = gsno(wordData)+"_"+gsno("\(gino(word_idData))")+"_"+gsno("\(gino(audioNum))")+".wav"
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
    
    @objc func updateAudioMeter(timer: Timer) {
        
        if audioRecorder.isRecording {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            audioRecorder.updateMeters()
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카테고리 종료 알림
        NotificationCenter.default.addObserver(self, selector: #selector(ParentDismiss(notification:)), name: .finish, object: nil)
        
        // 음성파일명 변경 알림
        NotificationCenter.default.addObserver(self, selector: #selector(audioFileNameRefresh(_:)), name: .refreshFileName, object: nil)
        
        //문제 단어 설정
        wordLabel.text = gsno(wordData)
        
        //DrawVC로 값 전달
        drawView.room_id = gino(room_idData)
        drawView.word = gsno(wordData)
        drawView.category = gino(categoryNumData)
        drawView.arrNum = gino(arrNumData)
        drawView.wordArr = gsno(wordArr)
        drawView.word_idArr = gsno(word_idArr)
        
        autoDown()
        
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
