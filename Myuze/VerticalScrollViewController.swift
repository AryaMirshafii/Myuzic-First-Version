//
//  MiddleScrollViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 12/14/15.
//  Copyright © 2015 Jake Spracher. All rights reserved.
//

//
//  MiddleScrollViewController.swift
//  SnapchatSwipeView
//
//  Created by Jake Spracher on 12/14/15.
//  Copyright © 2015 Jake Spracher. All rights reserved.
//

import UIKit
import CoreMotion

class VerticalScrollViewController: UIViewController, SnapContainerViewControllerDelegate {
    
    
    var topVc: UIViewController!
    var middleVc: UIViewController!
    var bottomVc: UIViewController!
    var scrollView: UIScrollView!
    var switchView: Bool?
    let motionManager: CMMotionManager = CMMotionManager()
    let activityManager:CMMotionActivityManager = CMMotionActivityManager()
    var isRunning = false
    var userInfo = dataController()
    class func verticalScrollVcWith(topVc: UIViewController?=nil, middleVc: UIViewController,bottomVc: UIViewController?=nil) -> VerticalScrollViewController {
        let middleScrollVc = VerticalScrollViewController()
        
        middleScrollVc.topVc = topVc
        middleScrollVc.middleVc = middleVc
        middleScrollVc.bottomVc = bottomVc
        
        return middleScrollVc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view:
        setupScrollView()
        scrollView.isPagingEnabled = true
        scrollView.touchesShouldCancel(in: topVc.view)
        
        
        
        
        
        
        //var timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.isMiddle), userInfo: nil, repeats: true)
        
        //var tiltTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.shouldSwitchView), userInfo: nil, repeats: true)
        //motionManager.deviceMotionUpdateInterval = 5
        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity) in
            if (activity?.running)!{
                self.isRunning = true
            } else {
                self.isRunning = false
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc func userDefaultsDidChange(){
        if(userInfo.fetchTilt() == "true"){
            self.shouldSwitchView()
        }
    }
    
    
    
    @objc func shouldSwitchView(){
        self.getTilt()
        if(switchView! && !isRunning){
            // performSegue(withIdentifier: "trans", sender: nil)
           scrollView.contentOffset.y = middleVc.view.frame.origin.y
        }
    }
    
    
    func getTilt(){
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates()
        var data = motionManager.deviceMotion
        var roll = data?.attitude.pitch
        if (roll == nil) {
            roll = 0
        }
        let currentPitch = degrees(radians: roll!)
        //print(currentPitch)
        if(currentPitch < -10){
            switchView = true
            
            
        }else {
            switchView = false
        }
        
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / Double.pi * radians
    }

    
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        
        
        
        let view = (
            x: CGFloat(0),
            y: CGFloat(0),
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        
        scrollView.frame = CGRect(x: view.x, y: view.y, width: view.width, height: view.height)
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = view.width
        var scrollHeight: CGFloat
        
        
        scrollHeight  = 3 * view.height
        
        topVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        middleVc.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)
        bottomVc.view.frame = CGRect(x: 0, y: 2 * view.height, width: view.width, height: view.height)
        
        
        
        
        addChildViewController(topVc)
        addChildViewController(middleVc)
        addChildViewController(bottomVc)
        
        scrollView.addSubview(topVc.view)
        scrollView.addSubview(middleVc.view)
        scrollView.addSubview(bottomVc.view)
        
        topVc.didMove(toParentViewController: self)
        middleVc.didMove(toParentViewController: self)
        bottomVc.didMove(toParentViewController: self)
        
        
        scrollView.contentOffset.y = middleVc.view.frame.origin.y
        //scrollView.contentOffset.y = topVc.view.frame.origin.y
        
        
        
        
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        scrollView.delaysContentTouches = false
        
    }
    
    // MARK: - SnapContainerViewControllerDelegate Methods
    /**
     
     */
    
    @objc func isMiddle() -> Bool {
       
        return scrollView.contentOffset.y == middleVc.view.frame.origin.y || scrollView.contentOffset.y == bottomVc.view.frame.origin.y
        
    }
    func outerScrollViewShouldScroll() -> Bool {
        
        
        
        return scrollView.contentOffset.y == topVc.view.frame.origin.y
        
        
    }
    
}
