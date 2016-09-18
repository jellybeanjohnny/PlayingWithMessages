//
//  LoadingViewController.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 9/13/16.
//  Copyright © 2016 Build Things. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
  
  var isAnimating = false
  let loadingLabel = UILabel()
  var loadingText: String? {
    willSet {
      clearLoadingText()
      setupLoadingText(withText: newValue)
    }
  }
  
  var iconSize: CGFloat {
    return UIScreen.main.bounds.size.width / 6.0
  }
  
  var activityIndicatorView: DGActivityIndicatorView!
  let dimmingView = UIView()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    self.activityIndicatorView = DGActivityIndicatorView(type: .cookieTerminator, tintColor: UIColor.white, size: self.iconSize)
    self.view.isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    setupDimingView()
    setupIndicatorView()
  }
  
  func setupIndicatorView() {
    
    debuggingOn(false)
    
    activityIndicatorView.center = view.center
    
    view.addSubview(activityIndicatorView)
    
    // Setting constraints to keep the view centered in its superview
    activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    activityIndicatorView.widthAnchor.constraint(equalToConstant: iconSize * 1.5).isActive = true
    activityIndicatorView.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
    
  }
  
  func setupLoadingText(withText text: String?) {
    loadingLabel.text = text
    loadingLabel.font = UIFont(name: "Futura-CondensedExtraBold", size: 20)
    loadingLabel.textColor = UIColor.white
    
    loadingLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(loadingLabel)
    
    loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    loadingLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor).isActive = true
  }
  
  func clearLoadingText() {
    loadingLabel.removeFromSuperview()
  }
  
  func setupDimingView() {
    dimmingView.frame = view.bounds
    dimmingView.alpha = 0.8
    dimmingView.backgroundColor = UIColor.darkGray
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(dimmingView)
    
    dimmingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    dimmingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    dimmingView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    dimmingView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
  }
  
  func startAnimating() {
    activityIndicatorView.startAnimating()
    view.isHidden = false
    isAnimating = true
  }
  
  func stopAnimating() {
    activityIndicatorView.stopAnimating()
    view.isHidden = true
    isAnimating = false
  }
  
  func debuggingOn(_ isOn: Bool) {
    if isOn {
      activityIndicatorView.backgroundColor = UIColor.red
    }
  }
  
  
  

}
