//
//  CanvasViewController.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 8/30/16.
//  Copyright © 2016 mogumogu. All rights reserved.
//

import UIKit
//import DGActivityIndicatorView

class CanvasViewController: UIViewController {
  
  // MARK: - Properties
  static let storyboardIdentifier = "CanvasViewController"
  
  let loadingVC = LoadingViewController()
  
  
  var imageID: String?
  
  @IBOutlet weak var canvasView: CanvasView!
  
  weak var delegate: CanvasViewControllerDelegate?
  
  var shouldSaveDrawing: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLoadingView()
    
    loadImage(forIdentifier: imageID)
    
  }
  
  @IBAction func doneButtonPressed() {
    storeInCloud()
  }
  @IBAction func saveButtonPressed() {
    save()
  }
  
  @IBAction func undoButtonPressed() {
    canvasView.undo()
  }
  
  func setupLoadingView() {
    loadingVC.view.bounds = view.bounds
    
    view.addSubview(loadingVC.view)
    
    loadingVC.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    loadingVC.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    loadingVC.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    loadingVC.view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
  }
  
  func toggleLoadingAnimation() {
    if loadingVC.isAnimating {
      loadingVC.stopAnimating()
    } else {
      loadingVC.startAnimating()
    }
  }
  
  func storeInCloud() {
    if let drawing = canvasView.incrementalImage {
      print("Saving image to CloudKit...")
      toggleLoadingAnimation()
      CloudKitInterface.save(drawing: drawing, completion: { (imageID, error) in
        self.toggleLoadingAnimation()
        if let error = error {
          self.delegate?.canvasViewController(self, didFailToSaveDrawingWithError: error)
        } else if let imageID = imageID {
          print("Successfully saved drawing with ID: \(imageID)")
          
          // Storing a drawing in the cloud is necessary for sending messages. Saving the history of a drawing will make it available for the user to view and send again later on.
          if self.shouldSaveDrawing {
            let savedDrawing = Drawing(imageIdentifier: imageID, image: drawing)
            DrawingHistory.save(drawing: savedDrawing)
          }
          self.delegate?.canvasViewController(self, didFinish: drawing, imageID: imageID)
        }
      })
    }
  }
  
  func save() {
    shouldSaveDrawing = true
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
          self.canvasView.addIncrementalImage(image)
        }
      }
    }
  }
  
  
}

protocol CanvasViewControllerDelegate: class {
  func canvasViewController(_ controller: CanvasViewController, didFinish drawing: UIImage, imageID: String)
  func canvasViewController(_ controller: CanvasViewController, didFailToSaveDrawingWithError error: Error)
}
