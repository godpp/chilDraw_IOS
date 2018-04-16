# # CHILDRAW

신경망 학습을 이용한 유아 영어 교육 애플리케이션

Blog : <https://godpp.github.io/2018/03/31/chilDraw-IOS-IPAD-App/>

## # 개요

IT를 접목한 유아 영어 교육인 에듀테크, 재미와 반복학습의 특징을 가지고 있는 그림 그리기를 접목시켜, 
아이들의 영어 발음을 인식하는 음성인식 (Deep Neural Network), 실시간으로 서버와 통신해 아이들의 그림 
특징을 추출할 수 있는 이미지 인식 (Conveontional Neural Network)으로 구성된 영어 교육 애플리케이션

## # 주요기능

* 로그인 & 회원가입
  - 회원가입시 TextField .editingChanged로 중복확인, 이메일 형식 확인, 비밀번호 형식 확인
  ```
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
    ```

* 메인화면
  - 아이들이 쉽게 이용할 수 있도록 영어단어 카테고리 클릭후 START 버튼으로 시작할 수 있습니다.
  - 좌측 상단 마이페이지와 우측 상단 도움말을 배치 했습니다.
  
* 그림그리기
  - 단어 카테고리별 랜덤으로 제시되는 단어에 맞추어 그림을 그릴 수 있습니다.
  - 그림 한 획당 서버와 통신하여 추론된 그림이 맞으면 정답 표시 이후 다음 문제로 넘어갑니다.
  - 발음을 요구하는 단어는 녹음 버튼을 통하여 4초간 음성 녹음 뒤 서버로 전송 됩니다.
  
## # Issue

* 카테고리 값 호출
  - CollectionView에서 개체 클릭시 어떤 개체인지 인식해야하는 이슈 발생.
  - cell 마다 0부터 번호를 매겨 해결
  
  ```
      // 카테고리 클릭시 해당 값 호출
    func categoryBtnPressed(cell: categoryCell) {
        let indexPath = self.categoryView.indexPath(for: cell)
        choiceCategoryNum = gino(indexPath?.row)
        print(choiceCategoryNum)
    }
  ```
  
* 그림 좌표 저장
  - 그림 한획 당 서버와 통신값 주고 받아야 하는 상황에서 좌표값이 중첩되는 문제 발생.
  - touchesEnded 함수 안에 drawingArray에 각각 x, y 좌표 append 시켜주고, 통신 후엔 배열 초기화로 해결.
  
```
  // 손을 떼는 순간
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawing else { return }
        isDrawing = false
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        let stroke = Stroke(startPoint: lastPoint, endPoint: currentPoint, color: strokeColor)
        strokes.append(stroke)
        lastPoint = nil
        drawingArray.append(drawX)
        drawingArray.append(drawY)
        
        let model = MainModel(self)
        model.drawModel(draw: "\(drawingArray)", word: word!, room_id: room_id!, token: user_token!)
        print("\(drawingArray)")
        
        
        drawingArray.removeAll()
        
        setNeedsDisplay()
        
  } 
```

## # 워크플로우

<img src = "/image/chilDraw_워크플로우.jpg">
