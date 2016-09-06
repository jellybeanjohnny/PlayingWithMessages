//
//  DrawingsViewController.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 8/31/16.
//  Copyright © 2016 Build Things. All rights reserved.
//
/*
 Collection view showing a list of drawings done by the user
 */
import UIKit

class DrawingsViewController: UIViewController {
  
  // MARK: Types
  
  /// An enumeration that represents an item in the collection view.
  enum CollectionViewItem {
    case drawing(Drawing)
    case create
  }
  
  // MARK: - Properties
  static let storyboardIdentifier = "DrawingsViewController"
  static let drawingCellIdentifier = "DrawingCell"
  static let createDrawingCellIdenifier = "CreateCell"
  
  weak var delegate: DrawingsViewControllerDelegate?
  
  let items: [CollectionViewItem]
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Initialization
  required init?(coder aDecoder: NSCoder) {
  
    let reversedDrawings = DrawingHistory.load().reversed()
    var items: [CollectionViewItem] = reversedDrawings.map{ .drawing($0)}
    items.insert(.create, at: 0)
    self.items = items
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

//    loadDrawings()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
  }
  
//  private func loadDrawings() {
//    CloudKitInterface.fetchAllDrawings { [weak self] (drawings) in
//      if let drawings = drawings {
//        let reversedDrawings =  drawings.reversed()
//        var items: [CollectionViewItem] = reversedDrawings.map{ .drawing($0) }
//        items.insert(.create, at: 0)
//        self?.items = items
//        OperationQueue.main.addOperation {
//          self?.collectionView.reloadData()
//        }
//      } else {
//        print("Could not load drawings")
//      }
//    }
//  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    collectionView.reloadData()
  }

}

// MARK: - UICollectionViewDataSource
extension DrawingsViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let item = items[indexPath.row]
    
    switch item {
    case .drawing(let drawing):
      return dequeueDrawingCell(for: drawing, at: indexPath)
    case .create:
      return dequeueCreateDrawingCell(at: indexPath)
    }
    
  }
  
  private func dequeueDrawingCell(for drawing: Drawing, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawingsViewController.drawingCellIdentifier, for: indexPath) as! DrawingCollectionViewCell
    cell.displayImageView.image = drawing.image
    return cell
  }
  
  private func dequeueCreateDrawingCell(at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawingsViewController.createDrawingCellIdenifier, for: indexPath)
    return cell
  }
  

  
}

// MARK: - UICollectionViewDelegate
extension DrawingsViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    
    switch item {
    case .create:
      delegate?.drawingsViewControllerDidSelectAdd(self)
    case .drawing(let drawing):
      delegate?.drawingsViewControllerDidSelectDrawing(self, drawing: drawing)
    }
  }
  
}

// MARK: - DrawingsViewControllerDelegate 
protocol DrawingsViewControllerDelegate: class {
  /// Called when the user selects the add button
  func drawingsViewControllerDidSelectAdd(_ controller: DrawingsViewController)
  func drawingsViewControllerDidSelectDrawing(_ controller: DrawingsViewController, drawing: Drawing)
}





