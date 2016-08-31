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
  
  
  @IBAction func doneButtonPressed() {
    saveImage()
    dismiss(animated: true, completion: nil)
  }
  
  func saveImage() {
    if let drawing = canvasView.incrementalImage {
      DrawingHistory.save(drawing: drawing)
      
    }
    
  }
  
}
