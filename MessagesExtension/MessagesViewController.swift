//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Matt Amerige on 8/28/16.
//  Copyright © 2016 Build Things. All rights reserved.
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
      // Show a list of previously created drawings
      controller = instantitateDrawingsViewController()
    } else {
      controller = instantiateCanvasViewController(withSelectedMessage: conversation.selectedMessage)
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
    controller.delegate = self
    return controller
  }
  
  func instantiateCanvasViewController(withSelectedMessage message: MSMessage?) -> UIViewController {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: CanvasViewController.storyboardIdentifier) as? CanvasViewController else {
      fatalError("Unable to instantiate a CanvasViewController from the storyboard")
    }
    controller.delegate = self
    controller.imageID = message?.url?.absoluteString
    
    return controller
  }
  
  func instantiateCancasViewController(withDrawing drawing: Drawing) -> UIViewController {
    guard let controller = storyboard?.instantiateViewController(withIdentifier: CanvasViewController.storyboardIdentifier) as? CanvasViewController else {
      fatalError("Unable to instantiate a CanvasViewController from the storyboard")
    }
    controller.delegate = self
    controller.imageID = drawing.imageIdentifier
    
    return controller
  }
  

  
  // MARK: Convenience
  func composeMessage(with drawing: UIImage, imageID: String, session: MSSession? = nil) -> MSMessage {
    let layout = MSMessageTemplateLayout()
    layout.image = drawing
    let message = MSMessage(session: session ?? MSSession())
    message.layout = layout
    message.url = URL(string: imageID)
    
    
    return message
  }
}

// MARK: DrawingViewControllerDelegate
extension MessagesViewController: DrawingsViewControllerDelegate {
  func drawingsViewControllerDidSelectAdd(_ controller: DrawingsViewController) {
    // The use selected the add button, change presentation style to '.expanded'
    requestPresentationStyle(.expanded)
  }
  
  func drawingsViewControllerDidSelectDrawing(_ controller: DrawingsViewController, drawing: Drawing) {
    guard let conversation = activeConversation else { fatalError("Expected a conversation") }
    let message = composeMessage(with: drawing.image, imageID: drawing.imageIdentifier)
    
    conversation.insert(message) { (error) in
      if let error = error {
        print("Error inserting message:\(error.localizedDescription)")
      }
    }
    dismiss()
  }
}

extension MessagesViewController: CanvasViewControllerDelegate {
  func canvasViewController(_ controller: CanvasViewController, didFinish drawing: UIImage, imageID: String) {
    guard let conversation = activeConversation else { fatalError("Expected a conversation") }
    // The user completed a drawing, stage this image to be sent
    let message = composeMessage(with: drawing, imageID: imageID, session: conversation.selectedMessage?.session)
    
    conversation.insert(message) { (error) in
      if let error = error {
        print("Error inserting message: \(error.localizedDescription)")
      }
      
    }
    dismiss()
  }  
}



