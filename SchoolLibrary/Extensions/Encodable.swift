//
//  Encodable.swift
//  SchoolLibrary
//
//  Created by Radi on 2.01.23.
//

import Foundation

extension Encodable {
    var toDictionnary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
