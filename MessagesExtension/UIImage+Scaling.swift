//
//  UIImage+Scaling.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 9/2/16.
//  Copyright © 2016 Build Things. All rights reserved.
//

import UIKit

extension UIImage {
  func scaleTo(size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    
    self.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
    
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
  }
  
  func scaleToFit(size: CGSize) -> UIImage? {
    let aspect = self.size.width / self.size.height
    if size.width / aspect <= size.height {
      return scaleTo(size: CGSize(width: size.width, height: size.width / aspect))
    } else {
      return scaleTo(size: CGSize(width: size.height * aspect, height: size.height))
    }
  }
}
