//
//  DrawingHistory.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 8/31/16.
//  Copyright © 2016 Build Things. All rights reserved.
//

/**
 Abstract: A class that persists drawings to disk
 */
import UIKit

class DrawingHistory {
  
  struct PathRouter {
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let pathSuffix = ".png"
  }
  
  static let drawingCountKey = "DrawingCount"
  
  // MARK: Properties
  private static var drawingCount: Int {
    return UserDefaults.standard.integer(forKey: DrawingHistory.drawingCountKey)
  }
  
  // MARK: Loading
  static func load() -> [UIImage] {
    var drawings = [UIImage]()
    for index in 0..<DrawingHistory.drawingCount {
      let filename = "Drawing\(index)".appending(PathRouter.pathSuffix)
      let archiveURL = PathRouter.documentsDirectory.appendingPathComponent(filename)
      
      if let data = NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? Data, let image = UIImage(data: data) {
        drawings.append(image)
      }

    }
    return drawings
  }
  
  // MARK: Saving
  static func save(drawing: UIImage) {
    let saveQueue = OperationQueue()
    saveQueue.addOperation { 
      guard let data = UIImagePNGRepresentation(drawing) else { fatalError("Unable to convert image to PNG data") }
      let filename = "Drawing\(DrawingHistory.drawingCount)".appending(PathRouter.pathSuffix)
      let archiveURL = PathRouter.documentsDirectory.appendingPathComponent(filename)
      
      let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(data, toFile: archiveURL.path)
      if !isSuccessfulSave {
        print("Failed to save drawing")
      }
      DrawingHistory.updateDrawingCount()
    }
  }
  
  private static func updateDrawingCount() {
    var currentCount = DrawingHistory.drawingCount
    currentCount += 1
    UserDefaults.standard.set(currentCount, forKey: DrawingHistory.drawingCountKey)
  }
  
  
  
}
