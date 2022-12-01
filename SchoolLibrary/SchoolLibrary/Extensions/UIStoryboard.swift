//
//  UIStoryboard.swift
//  SchoolLibrary
//
//  Created by Radi on 1.12.22.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    static var library: UIStoryboard {
        return UIStoryboard.init(name: "Library", bundle: nil)
    }
    
    static var taken: UIStoryboard {
        return UIStoryboard.init(name: "Taken", bundle: nil)
    }
    
    static var provided: UIStoryboard {
        return UIStoryboard.init(name: "Provided", bundle: nil)
    }
    
    static var settings: UIStoryboard {
        return UIStoryboard.init(name: "Settings", bundle: nil)
    }
}
