//
//  ViewController.swift
//  DynamicsPlayground
//
//  Created by Andre Faruolo on 16/05/17.
//  Copyright © 2017 Andre Faruolo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var updateCount = 0
    var square: UIView!
    var snap: UISnapBehavior!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
         square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = UIColor.gray
        view.addSubview(square)
        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)
        
        animator = UIDynamicAnimator(referenceView : view)
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)
        collision = UICollisionBehavior(items: [square])
        collision.collisionDelegate = self
       collision.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        
        collision.action = {
            
            if(self.updateCount % 3 == 0) {
                
                let outline = UIView(frame: self.square.bounds)
                outline.transform = self.square.transform
                outline.center = self.square.center
                
                outline.alpha = 0.5
                outline.backgroundColor = UIColor.clear
                outline.layer.borderColor = self.square.layer.presentation()?.backgroundColor
                outline.layer.borderWidth = 1.0
                self.view.addSubview(outline)
                
            }
            
            
            self.updateCount += 1
            print("\(NSStringFromCGAffineTransform(self.square.transform)) \(NSStringFromCGPoint(self.square.center))")
        
        }
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior!, beganContactFor item: UIDynamicItem!, withBoundaryIdentifier identifier: NSCopying!, at p: CGPoint) {
        print("Boundary contact occurred - \(identifier)")
        let collidingView = item as! UIView
        collidingView.backgroundColor = UIColor.yellow
        UIView.animate(withDuration: 0.3) {
            collidingView.backgroundColor = UIColor.gray
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (snap != nil) {
            
            animator.removeBehavior(snap)
            
        }
        
        let touch = touches.first!
        snap = UISnapBehavior(item: square, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
    }


}

