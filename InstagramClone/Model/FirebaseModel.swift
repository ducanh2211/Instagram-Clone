//
//  ModelSerializable.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation

typealias FirebaseModel = ModelSerializable & ModelDescriptionable

protocol ModelSerializable {
  init?(dictionary: [String: Any])
}

protocol ModelDescriptionable {
  var description: [String: Any] { get }
}
