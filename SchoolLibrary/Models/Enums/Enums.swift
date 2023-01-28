//
//  Enums.swift
//  SchoolLibrary
//
//  Created by Radi on 10.12.22.
//

import Foundation

enum Category: String {
    case all = "All"
    case mathematics = "Mathematics"
    case biology = "Biology"
    case physics = "Physics"
    case english = "English"
    case french = "French"
    case programing = "Programming"
    case music = "Music"
    case novels = "Novels"
    case fantasy = "Fantasy"
    
    static func allCategories() -> [Category] {
        return [
            .all,
            .mathematics,
            .biology,
            .physics,
            .english,
            .french,
            .programing,
            .music,
            .novels,
            .fantasy
        ]
    }
}

enum MyBooksScreenType {
    case taken
    case provided
}

enum BookScreenType {
    case standartScreen
    case fromProvided
    case fromTaken
}

enum DefaultLanguage: String {
    case BG = "bg"
    case EN = "en"
}
