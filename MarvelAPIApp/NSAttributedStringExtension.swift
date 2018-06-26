//
//  NSAttributedStringExtension.swift
//  MarvelAPIApp
//
//  Created by SoftDesign on 26/06/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {

    class func fromString(string: String, lineHeightMultiple: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.baselineOffset: -1], range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
}
