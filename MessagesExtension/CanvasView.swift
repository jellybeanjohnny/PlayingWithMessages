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
      UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
      
      let rectPath = UIBezierPath(rect: bounds)
      UIColor.white.setFill()
      rectPath.fill()
      newValue?.draw(in: bounds)
      self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    }
  }
  
  // MARK: Initialization
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.bezierPath.lineCapStyle = .round
    self.bezierPath.lineWidth = CanvasView.lineWidth
    
    // Add a gesture to handle a single tap
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(tapGesture:)))
    addGestureRecognizer(tapGesture)
    
  }
  
  // MARK: Touch Events
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let currentPoint = touches.first?.location(in: self) else {
      fatalError("Expected touch object")
    }
    
    bezierPath.move(to: currentPoint)
    previousPoint = currentPoint
    previousPreviousPoint = currentPoint
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let currentPoint = touches.first?.location(in: self) else {
      fatalError("Expected touch object")
    }
    
    let midPoint1 = previousPoint.midPoint(to: previousPreviousPoint)
    let midPoint2 = previousPoint.midPoint(to: currentPoint)
    
    bezierPath.move(to: midPoint1)
    bezierPath.addQuadCurve(to: midPoint2, controlPoint: previousPoint)
    
    pointCounter += 1
    
    if pointCounter > CanvasView.maximumPoints {
      addToBitmap()
    }
    
    previousPreviousPoint = previousPoint
    previousPoint = currentPoint
    
    setNeedsDisplay()
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    addToBitmap()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    touchesEnded(touches, with: event)
  }
  
  private func addToBitmap() {
    drawBitmap()
    bezierPath.removeAllPoints()
    pointCounter = 0
  }
  
  // MARK: Drawing
  
  private func drawBitmap() {
    UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
    
    UIColor.black.setStroke()
    if incrementalImage == nil {
      let rectPath = UIBezierPath(rect: bounds)
      UIColor.white.setFill()
      rectPath.fill()
    }
    
    incrementalImage?.draw(at: CGPoint(x: 0, y: 0))
    bezierPath.stroke()
    
    
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  override func draw(_ rect: CGRect) {
    incrementalImage?.draw(in: rect)
    bezierPath.stroke()
  }
  
  // MARK: - Tap Gesture
  func handleTap(tapGesture: UITapGestureRecognizer) {
    let currentPoint = tapGesture.location(in: self)
    bezierPath.move(to: currentPoint)
    bezierPath.addLine(to: currentPoint)
    
    drawBitmap()
    setNeedsDisplay()
    bezierPath.removeAllPoints()
  }
  
}
