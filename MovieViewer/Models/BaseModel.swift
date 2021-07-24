//
//  BaseModel.swift
//  MovieViewer
//
//  Created by builes on 21/07/21.
//

import UIKit

enum JSONSerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

class BaseModel: NSObject {

    // MARK: - Properties
    var externalID: String = ""
    
    // MARK: - Initializers
    override init() { super.init() }
    
    init(JSON:[String: Any]) throws {
        guard let externalID = JSON["id"] as? Int else {
            print("Unable to obtain object external ID for response data: \(JSON)")
            throw JSONSerializationError.missing("id")
        }
        self.externalID = String(externalID);
    }
}
