//
//  UIImage+CKAsset.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 9/2/16.
//  Copyright © 2016 Build Things. All rights reserved.
//
/*
 Borrowed from https://blog.frozenfirestudios.com/working-with-images-in-cloudkit-1e3579c67558#.g9rvgqvp4
 */

import UIKit
import CloudKit

enum ImageFileType {
  case JPG(compressionQuality: CGFloat)
  case PNG
  
  var fileExtension: String {
    switch self {
      case .JPG(_):
        return ".jpg"
      case .PNG:
        return ".png"
    }
  }
}

enum ImageError: Error {
  case UnableToConvertImageToData
}


extension UIImage {
  func saveToTempLocation(fileType: ImageFileType) throws -> URL {
    let imageData: Data?
    
    switch fileType {
    case .JPG(let quality):
      imageData = UIImageJPEGRepresentation(self, quality)
    case .PNG:
      imageData = UIImagePNGRepresentation(self)
    }
    
    guard let data = imageData else {
      throw ImageError.UnableToConvertImageToData
    }
    
    let filename = ProcessInfo.processInfo.globallyUniqueString + fileType.fileExtension
    let url = URL.init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
    try data.write(to: url, options: .atomicWrite)
    
    return url
  }
}

extension CKAsset {
  convenience init(image: UIImage, fileType: ImageFileType = .JPG(compressionQuality: 70)) throws {
    let url = try image.saveToTempLocation(fileType: fileType)
    self.init(fileURL: url)
  }
  
  var image: UIImage? {
    guard let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) else { return nil }
    return image
  }
}
