//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Matt Amerige on 8/28/16.
//  Copyright © 2016 mogumogu. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
  
  override func willBecomeActive(with conversation: MSConversation) {
    super.willBecomeActive(with: conversation)
    presentViewController(for: conversation, with: presentationStyle)
  }
  
  override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
    guard let conversation = activeConversation else { fatalError("Expected an active conversation") }
    
    presentViewController(for: conversation, with: presentationStyle)
  }
  
  private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
    
    // Determine the controller to present.
    let controller: UIViewController
    if presentationStyle == .compact {
      controller = instantitateDrawingsViewController()
    }
    else {
      controller = instantiateCanvasViewController()
    }
    
    // Remove any existing child controllers
    for child in childViewControllers {
      child.willMove(toParentViewController: nil)
      child.view.removeFromSuperview()
      child.removeFromParentViewController()
    }
    
    // Embed the new controller
    addChildViewController(controller)
    
    controller.view.frame = view.bounds
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(controller.view)
    
    controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    controller.didMove(toParentViewController: self)
  }
  
  func instantitateDrawingsViewController() -> UIViewController {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: DrawingsViewController.storyboardIdentifier) as? DrawingsViewController else {
      fatalError("Unable to instantiate a DrawingsViewController from the storyboard")
    }
    
    return controller
  }
  
  func instantiateCanvasViewController() -> UIViewController {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: CanvasViewController.storyboardIdentifier) as? CanvasViewController else {
      fatalError("Unable to instantiate a CanvasViewController from the storyboard")
    }
    return controller
  }


}
