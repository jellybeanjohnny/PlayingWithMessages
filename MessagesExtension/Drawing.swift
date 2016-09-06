//
//  Drawing.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 9/6/16.
//  Copyright © 2016 Build Things. All rights reserved.
//

import UIKit

class Drawing: NSObject, NSCoding {
  
  let imageIdentifier: String
  let image: UIImage
  
  init(imageIdentifier: String, image: UIImage) {
    self.imageIdentifier = imageIdentifier
    self.image = image
    super.init()
  }
 
  //MARK: NSCoding
  required convenience init?(coder aDecoder: NSCoder) {
    let image = aDecoder.decodeObject(forKey: "image") as! UIImage
    let imageIdentifier = aDecoder.decodeObject(forKey: "imageIdentifer") as! String
    
    self.init(imageIdentifier: imageIdentifier, image: image)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(imageIdentifier, forKey: "imageIdentifer")
    aCoder.encode(image, forKey: "image")
  }
}

