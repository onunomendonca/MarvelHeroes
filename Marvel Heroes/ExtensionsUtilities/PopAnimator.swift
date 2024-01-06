//
//  RevealAnimator.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 14/12/2021.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    let duration = 1.0
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Set-up transition
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .systemBackground
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let initalFrame = originFrame
        let finalFrame = toView.frame

        toView.transform = CGAffineTransform(scaleX: initalFrame.width / finalFrame.width, y: initalFrame.height / finalFrame.height)
        toView.center = CGPoint(x: initalFrame.midX, y: initalFrame.midY)
        containerView.addSubview(toView)
        // Animate
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            animations: {
                toView.transform = .identity
                toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }
        )

        // Complete Trransition
        transitionContext.completeTransition(true)
    }


}
