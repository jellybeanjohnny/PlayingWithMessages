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
  
  var imageID: String?
  
  @IBOutlet weak var canvasView: CanvasView!
  
  weak var delegate: CanvasViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadImage(forIdentifier: imageID)
  }
  
  @IBAction func doneButtonPressed() {
    saveImage()
  }
  
  func saveImage() {
    if let drawing = canvasView.incrementalImage {
      DrawingHistory.save(drawing: drawing)
      print("Saving image to CloudKit...")
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
  
  func loadImage(forIdentifier identifier: String?) {
    guard let identifier = identifier else {
      print("No valid identifier")
      return
    }
    print("Fetching image from CloudKit...")
    CloudKitInterface.fetchImage(withIdentifier: identifier) { (image, error) in
      if let error = error {
        print("Error fetching drawing: \(error.localizedDescription)")
      } else if let image = image {
        print("Fetch completed!")
        OperationQueue.main.addOperation {
          self.canvasView.incrementalImage = image
        }
      }
    }
  }
  
}

protocol CanvasViewControllerDelegate: class {
  func canvasViewController(_ controller: CanvasViewController, didFinish drawing: UIImage, imageID: String)
  func canvasViewController(_ controller: CanvasViewController, didFailToSaveDrawingWithError error: Error)
}
