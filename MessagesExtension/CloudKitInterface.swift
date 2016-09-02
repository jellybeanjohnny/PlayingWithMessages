//
//  CloudKitInterface.swift
//  PlayingWithMessages
//
//  Created by Matt Amerige on 9/2/16.
//  Copyright © 2016 Build Things. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitInterface {
  
  private static let publicDatabase = CKContainer.default().publicCloudDatabase
  
  class func save(drawing: UIImage, completion:@escaping (String?, Error?) -> ()) {
    
    let newRecord = CKRecord(recordType: "image")
    do {
      newRecord["fullsize"] = try CKAsset(image: drawing)
      
      CloudKitInterface.publicDatabase.save(newRecord, completionHandler: { (record, error) in
        if let recordID = record?.recordID.recordName {
          completion(recordID, nil)
        } else {
          completion(nil, error)
        }
      })
    } catch {
      completion(nil, error)
    }
  }
  
  class func fetchImage(withIdentifier imageIdentifier: String, completion:@escaping (UIImage?, Error?) -> ()) {
    let imageRecordID = CKRecordID(recordName: imageIdentifier)
    let fetchOperation = CKFetchRecordsOperation(recordIDs: [imageRecordID])
    fetchOperation.desiredKeys = ["fullsize"]
    fetchOperation.fetchRecordsCompletionBlock = { (records, error) in
      if let imageRecord = records?[imageRecordID], let asset = imageRecord["fullsize"] as? CKAsset, let image = asset.image {
        completion(image, nil)
      } else {
        completion(nil, error)
      }
    }
    CloudKitInterface.publicDatabase.add(fetchOperation)
  }
  
  
}
