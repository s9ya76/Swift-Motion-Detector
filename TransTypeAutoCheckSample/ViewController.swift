//
//  ViewController.swift
//  TransTypeAutoCheckSample
//
//  Created by 關貿開發者 on 2016/12/2.
//  Copyright © 2016年 關貿網路股份有限公司. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var transTypeLabel: UILabel!
    
    private let clLocationManager = CLLocationManager()
    private let motionActivityManager = CMMotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Setup Location Manager
        setupLocationManager()
        
        // 避免螢幕自動關閉
        UIApplication.shared.isIdleTimerDisabled = true
        
        motionActivityManager
            .startActivityUpdates(to: OperationQueue.main) { (activity) in
                var types = ""
                if (activity?.automotive)! {
                    print("User using car")
                    types.append("Car\n")
                }
                if (activity?.cycling)! {
                    print("User is cycling")
                    types.append("Cycling\n")
                }
                if (activity?.running)! {
                    print("User is running")
                    types.append("Running\n")
                }
                if (activity?.walking)! {
                    print("User is walking")
                    types.append("Walking\n")
                }
                if (activity?.stationary)! {
                    print("User is standing")
                    types.append("Stationary\n")
                }
                if (activity?.unknown)! {
                    types.append("Unknown\n")
                }
                let confi = activity?.confidence.rawValue
                print("confi:\(confi!)")
                self.transTypeLabel.text = types
        }
    }
    
    // 需設置該function，location manager才會更新location
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        print("speed: \(locations[0].speed)")
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error) {
        print("\(error)")
    }
    
    // Setup Location Manager
    private func setupLocationManager() {
        clLocationManager.delegate = self
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //如果不加的話，會在背景執行20分鐘左右，就停止記錄了
        clLocationManager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 9.0, *){
            clLocationManager.allowsBackgroundLocationUpdates = true
        }
        clLocationManager.startUpdatingLocation()
    }
}

