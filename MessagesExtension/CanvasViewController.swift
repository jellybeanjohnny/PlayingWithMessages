//
//  CanvasViewController.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 8/30/16.
//  Copyright © 2016 mogumogu. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
  
  // MARK: - Properties
  static let storyboardIdentifier = "CanvasViewController"
  
  
  @IBOutlet weak var canvasView: CanvasView!
  
  weak var delegate: CanvasViewControllerDelegate?
  
  @IBAction func doneButtonPressed() {
    saveImage()
  }
  
  func saveImage() {
    if let drawing = canvasView.incrementalImage {
      DrawingHistory.save(drawing: drawing)
      CloudKitInterface.save(drawing: drawing, completion: { (imageID, error) in
        if let error = error {
          self.delegate?.canvasViewController(self, didFailToSaveDrawingWithError: error)
        } else if let imageID = imageID {
          print("Successfully saved drawing with ID: \(imageID)")
          self.delegate?.canvasViewController(self, didFinish: drawing, imageID: imageID)
        }
      })
    }
  }
  
}

protocol CanvasViewControllerDelegate: class {
  func canvasViewController(_ controller: CanvasViewController, didFinish drawing: UIImage, imageID: String)
  func canvasViewController(_ controller: CanvasViewController, didFailToSaveDrawingWithError error: Error)
}
