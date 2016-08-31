//
//  CanvasView.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 8/30/16.
//  Copyright © 2016 mogumogu. All rights reserved.
//

import UIKit

class CanvasView: UIView {
  
  // MARK: Properties
  
  static let lineWidth: CGFloat = 8.0
  static let maximumPoints = 100
  
  private let bezierPath = UIBezierPath()
  
  private var pointCounter = 0
  private var previousPoint = CGPoint()
  private var previousPreviousPoint = CGPoint()
  
  var incrementalImage: UIImage? {
    willSet {
      UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
      
      let rectPath = UIBezierPath(rect: self.bounds)
      UIColor.white.setFill()
      rectPath.fill()
      newValue?.draw(in: self.bounds)
      self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    }
  }
  
  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.bezierPath.lineCapStyle = .round
    self.bezierPath.lineWidth = CanvasView.lineWidth
    
  }
  
  // MARK: Touch Events
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let currentPoint = touches.first?.location(in: self) else {
      fatalError("Expected touch object")
    }
    
    self.bezierPath.move(to: currentPoint)
    self.previousPoint = currentPoint
    self.previousPreviousPoint = currentPoint
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let currentPoint = touches.first?.location(in: self) else {
      fatalError("Expected touch object")
    }
    
    let midPoint1 = self.previousPoint.midPoint(to: self.previousPreviousPoint)
    let midPoint2 = self.previousPoint.midPoint(to: currentPoint)
    
    self.bezierPath.move(to: midPoint1)
    self.bezierPath.addQuadCurve(to: midPoint2, controlPoint: self.previousPoint)
    
    self.pointCounter += 1
    
    if self.pointCounter > CanvasView.maximumPoints {
      self.addToBitmap()
    }
    
    self.previousPreviousPoint = self.previousPoint
    self.previousPoint = currentPoint
    
    self.setNeedsDisplay()
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.addToBitmap()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.touchesEnded(touches, with: event)
  }
  
  private func addToBitmap() {
    self.drawBitmap()
    self.bezierPath.removeAllPoints()
    self.pointCounter = 0
  }
  
  // MARK: Drawing
  
  private func drawBitmap() {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
    
    UIColor.black.setStroke()
    if self.incrementalImage == nil {
      let rectPath = UIBezierPath(rect: self.bounds)
      UIColor.white.setFill()
      rectPath.fill()
    }
    
    self.incrementalImage?.draw(at: CGPoint(x: 0, y: 0))
    self.bezierPath.stroke()
    print(self.bezierPath)
    
    
    self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  override func draw(_ rect: CGRect) {
    self.incrementalImage?.draw(in: rect)
    self.bezierPath.stroke()
  }
  
}
