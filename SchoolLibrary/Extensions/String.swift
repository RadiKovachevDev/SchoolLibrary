//
//  String.swift
//  SchoolLibrary
//
//  Created by Radi on 27.01.23.
//

import Foundation

extension String {
    var localized: String {
        
        let path = Bundle.main.path(forResource: UserData.selectedLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)!
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
