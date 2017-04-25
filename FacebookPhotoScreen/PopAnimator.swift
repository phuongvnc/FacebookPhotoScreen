//
//  PopAnimator.swift
//  Test
//
//  Created by PhuongVNC on 11/11/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//
import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  let duration:TimeInterval    = 0.5
  var presenting  = true
  var originFrame = CGRect.zero
  var presentCompletionAnimation: ((Bool) -> Void)?
  var dismissCompletionAnimation: ((Bool) -> Void)?

  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)-> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let containerView = transitionContext.containerView

    let herbView = presenting ? transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view! : transitionContext.view(forKey: UITransitionContextViewKey.from)!.viewWithTag(100)!

    herbView.frame =  presenting ? UIScreen.main.bounds :  herbView.frame
    
    let initialFrame = presenting ? originFrame : UIScreen.main.bounds
    let finalFrame = presenting ? UIScreen.main.bounds : originFrame
    
    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width
    
    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if presenting {
      herbView.transform = scaleTransform
      herbView.center = CGPoint(
        x: initialFrame.midX,
        y: initialFrame.midY)
      herbView.clipsToBounds = true
    }
    if presenting {
        containerView.addSubview(transitionContext.view(forKey: UITransitionContextViewKey.to)!)
    }

    containerView.bringSubview(toFront: herbView)

    UIView.animate(withDuration: duration, delay:0.0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.5,
      options: [],
      animations: {
        if self.presenting {
            herbView.transform = self.presenting ? CGAffineTransform(scaleX: 1, y: 1) : scaleTransform
        } else {
            herbView.frame = finalFrame
        }
        herbView.center = CGPoint(x: finalFrame.midX,y: finalFrame.midY)

      }, completion:{_ in
        transitionContext.completeTransition(true)
        if self.presenting {
            herbView.frame = UIScreen.main.bounds
        }
        self.presenting ? self.presentCompletionAnimation?(true) : self.dismissCompletionAnimation?(true)
    })

  }

}


