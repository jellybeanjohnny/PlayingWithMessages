//
//  DrawingsViewController.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 8/31/16.
//  Copyright © 2016 mogumogu. All rights reserved.
//
/*
 Collection view showing a list of drawings done by the user
 */
import UIKit

class DrawingsViewController: UIViewController {
  
  // MARK: Types
  
  /// An enumeration that represents an item in the collection view.
  enum CollectionViewItem {
    case drawing(UIImage)
    case create
  }
  
  // MARK: - Properties
  static let storyboardIdentifier = "DrawingsViewController"
  static let drawingCellIdentifier = "DrawingCell"
  static let createDrawingCellIdenifier = "CreateCell"
  
  let items: [CollectionViewItem]
  
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Initialization
  required init?(coder aDecoder: NSCoder) {
    
    let reversedHistory = DrawingHistory.load().reversed()
    var items: [CollectionViewItem] = reversedHistory.map{ .drawing($0) }
    
    items.insert(.create, at: 0)
    
    self.items = items
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
  }
  
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
  
  private func dequeueDrawingCell(for drawing: UIImage, at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawingsViewController.drawingCellIdentifier, for: indexPath) as! DrawingCollectionViewCell
    cell.displayImageView.image = drawing
    return cell
  }
  
  private func dequeueCreateDrawingCell(at indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawingsViewController.createDrawingCellIdenifier, for: indexPath)
    return cell
  }
  

  
}

// MARK: - UICollectionViewDelegate
extension DrawingsViewController: UICollectionViewDelegate {
  
}
