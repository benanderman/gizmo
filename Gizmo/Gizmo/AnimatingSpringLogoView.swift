//
//  AnimatingSpringLogoView.swift
//  Gizmo
//
//  Created by Glen DeBiasa on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import UIKit

class AnimatingSpringLogoView: UIView {

  private var imageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "logoCookie"))
  private var cancelAnimation: Bool = false
  
  override init(frame: CGRect) {
   super.init(frame: frame)
   setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    imageView.contentMode = UIViewContentMode.scaleAspectFit
    imageView.backgroundColor = UIColor.clear
    
    translatesAutoresizingMaskIntoConstraints = false
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(imageView)
    
    imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }
  
  func resetAnimation() {
    cancelAnimation = false
  }
  
  func startAnimation() {
    guard !cancelAnimation else {
      return
    }
    
    let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.imageView.transform = strongSelf.imageView.transform.rotated(by: CGFloat.pi)
    }
    
    animator.addCompletion { [weak self] position in
      if position == .end {
        guard let strongSelf = self else {
          return
        }
        
        guard !strongSelf.cancelAnimation else {
          return
        }
        
        strongSelf.startAnimation()
      }
    }
    
    animator.startAnimation()
  }
  
  func stopAnimation() {
    cancelAnimation = true
  }
  
  /*
  - (void)startAnimation {
  if (self.cancelAnimation) {
  return;
  }
  __weak BCAnimatingSpringLogoView *weakSelf = self;
  
  [UIView animateWithDuration:0.5
  delay:0
  usingSpringWithDamping:1
  initialSpringVelocity:0
  options:UIViewAnimationOptionCurveEaseOut
  animations:^{
  BCAnimatingSpringLogoView *strongSelf = weakSelf;
  strongSelf.imageView.transform = CGAffineTransformRotate(strongSelf.imageView.transform, M_PI);
  }
  completion:^(BOOL finished) {
  BCAnimatingSpringLogoView *strongSelf = weakSelf;
  if (finished && !strongSelf.cancelAnimation) {
  [strongSelf startAnimation];
  }
  }];
  }
  
  - (void)stopAnimation {
  self.cancelAnimation = YES;
  }*/
}
