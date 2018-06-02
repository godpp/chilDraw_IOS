//
//  MypageVC.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 27..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import UIKit
import SwiftCharts

class MypageVC : UIViewController {
    

    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var mypageView: UIView!
    @IBOutlet var chartView: UIView!
    
    var chartV : BarsChart!
    
    let ud = UserDefaults.standard
    let user_token = UserDefaults.standard.string(forKey: "token")
    var result : [Double] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(result)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        mypageView.layer.cornerRadius = 20
        
        let chartConfig = BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0, to: 110, by: 10))
        let frame = CGRect(x: 0, y: 0, width: self.chartView.frame.width, height: self.chartView.frame.height)
        
        let chart = BarsChart(frame: frame, chartConfig: chartConfig, xTitle: "성장률" , yTitle: "카테고리", bars:
            [
                ("과일", Double(result[0]*20)),("사물", Double(result[1]*20)),("옷", Double(result[2]*20)),("자연", Double(result[3]*20)),("도형", Double(result[4]*20))
            ], color: UIColor.darkGray, barWidth: 30)
        self.chartView.addSubview(chart.view)
        self.chartV = chart
    }
    override func viewWillAppear(_ animated: Bool) {
    }

    
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
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingpageButton(_ sender: Any) {
        guard let settingpageVC = storyboard?.instantiateViewController(
            withIdentifier: "SettingPageVC"
            ) as? SettingPageVC
            else {return}
        self.present(settingpageVC, animated: true)
    }
    
    
}
