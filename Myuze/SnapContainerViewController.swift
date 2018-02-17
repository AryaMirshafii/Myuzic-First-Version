

import UIKit
import MediaPlayer
import CoreMotion

protocol SnapContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
    func isMiddle() -> Bool
}

class SnapContainerViewController: UIViewController, UIScrollViewDelegate,UIGestureRecognizerDelegate {
    
    var topVc: UIViewController?
    var leftVc: UIViewController!
    var middleVc: UIViewController!
    var rightVc: UIViewController!
    var bottomVc: UIViewController?
    
    var directionLockDisabled: Bool!
    
    var horizontalViews = [UIViewController]()
    var veritcalViews = [UIViewController]()
    
    var initialContentOffset = CGPoint() // scrollView initial offset
    var middleVertScrollVc: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: SnapContainerViewControllerDelegate?
    
    
    var switchView: Bool?
    let motionManager: CMMotionManager = CMMotionManager()
    
    let player = MPMusicPlayerController.applicationMusicPlayer
    var pitch: Double!
    var data: CMDeviceMotion!
    class func containerViewWith(_ leftVC: UIViewController,
                                 middleVC: UIViewController,
                                 rightVC: UIViewController,
                                 topVC: UIViewController?=nil,
                                 bottomVC: UIViewController?=nil,
                                 directionLockDisabled: Bool?=false) -> SnapContainerViewController {
        let container = SnapContainerViewController()
        
        container.directionLockDisabled = directionLockDisabled
        
        container.topVc = topVC
        container.leftVc = leftVC
        container.middleVc = middleVC
        container.rightVc = rightVC
        container.bottomVc = bottomVC
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVerticalScrollView()
        setupHorizontalScrollView()
        scrollView.delaysContentTouches = false
        scrollView.bounces = false
        
        
        scrollView.isPagingEnabled = true
        
        var timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkMiddle), userInfo: nil, repeats: true)
        
        
        
        var tiltTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.shouldSwitchView), userInfo: nil, repeats: true)
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func shouldSwitchView(){
        self.getTilt()
        if(switchView)!{
            // performSegue(withIdentifier: "trans", sender: nil)
            //print("hi")
            scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
            
        }
    }
    
    
    func getTilt(){
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates()
        data = motionManager.deviceMotion
        pitch = data?.attitude.pitch
        if (pitch == nil) {
            pitch = 5
        }
        var currentPitch = degrees(radians: pitch!)
        //print(currentPitch)
        if(currentPitch < -10){
            switchView = true
            
            
        }else {
            switchView = false
        }
        
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / M_PI * radians
    }
    
    
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setupVerticalScrollView() {
        middleVertScrollVc = VerticalScrollViewController.verticalScrollVcWith(topVc: topVc,
                                                                               middleVc: middleVc,
                                                                               bottomVc: bottomVc)
        delegate = middleVertScrollVc
        
        
    }
    
    func setupHorizontalScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        //scrollView.canCancelContentTouches = false
        
        scrollView.touchesShouldCancel(in: middleVertScrollVc.topVc.view)
        
        
        
        
        //self.view.bounds.origin.x
        let view = (
            x: CGFloat(0) ,
            y: CGFloat(0),
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        
        scrollView.frame = CGRect(x: view.x,
                                  y: view.y,
                                  width: view.width,
                                  height: view.height
        )
        
        self.view.addSubview(scrollView)
        
        let scrollWidth  = 3 * view.width
        let scrollHeight  = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        leftVc.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.width,
                                   height: view.height
        )
        
        middleVertScrollVc.view.frame = CGRect(x: view.width,
                                               y: 0,
                                               width: view.width,
                                               height: view.height
        )
        
        rightVc.view.frame = CGRect(x: 2 * view.width,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )
        
        addChildViewController(leftVc)
        addChildViewController(middleVertScrollVc)
        addChildViewController(rightVc)
        
        scrollView.addSubview(leftVc.view)
        scrollView.addSubview(middleVertScrollVc.view)
        scrollView.addSubview(rightVc.view)
        
        leftVc.didMove(toParentViewController: self)
        middleVertScrollVc.didMove(toParentViewController: self)
        rightVc.didMove(toParentViewController: self)
        
        scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        //scrollView.contentOffset.y = (topVc?.view.frame.origin.y)!
        scrollView.delegate = self
    }
    
    
    
    @objc func checkMiddle(){
        
        if(delegate?.isMiddle())!{
            scrollView.canCancelContentTouches = false
            
        } else {
            scrollView.canCancelContentTouches = true
            
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.initialContentOffset = scrollView.contentOffset
        
        
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print("are we scrolling" + String(scrollView.isDragging))
        if delegate != nil && !delegate!.outerScrollViewShouldScroll() && !directionLockDisabled {
            //
            
            let newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
            
            
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            self.scrollView!.setContentOffset(newOffset, animated:  false)
            
            
            
            
            
        }
        
        
    }
    
}
