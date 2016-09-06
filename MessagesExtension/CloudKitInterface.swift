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
  
  class func update(drawing: UIImage, withIdentifer imageIdentifer: String, completion: @escaping (Bool, Error?) -> ()) {
    let recordID = CKRecordID(recordName: imageIdentifer)
    CloudKitInterface.publicDatabase.fetch(withRecordID: recordID) { (record, error) in
      if let error = error {
        print("Error updating record: \(error.localizedDescription)")
        completion(false, error)
      } else if let record = record {
        CloudKitInterface.update(record: record, withDrawing: drawing, completion: { (isSuccessful, error) in
          completion(isSuccessful, error)
        })
      }
    }
    
  }
  
 private class func update(record: CKRecord, withDrawing drawing: UIImage, completion: @escaping (Bool, Error?) -> ()) {
    
    // creating an asset with the desired image
    do {
      record["fullsize"] = try CKAsset(image: drawing)
    } catch {
      print("Error creating an asset from the desired image: \(error.localizedDescription)")
      completion(false, error)
    }
    
    CloudKitInterface.publicDatabase.save(record) { (savedRecord, error) in
      if let error = error {
        print("Error saving record to the public database")
        completion(false, error)
      } else {
        print("Successfully saved image")
        completion(true, nil)
      }
    }
    
  }
  
}
