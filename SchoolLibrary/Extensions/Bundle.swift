//
//  Bundle.swift
//  SchoolLibrary
//
//  Created by Radi on 12.02.23.
//

import Foundation
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "\(releaseVersionNumber ?? "1.0.0")(\(buildVersionNumber ?? "1"))"
    }
}
