//
//  CGPoint+MidPoint.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 8/30/16.
//  Copyright © 2016 mogumogu. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
  func midPoint(to point: CGPoint) -> CGPoint {
    
    let x = (self.x + point.x) / 2.0
    let y = (self.y + point.y) / 2.0
    
    return CGPoint(x: x, y: y)
  }
}
