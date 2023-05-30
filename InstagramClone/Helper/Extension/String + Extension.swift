//
//  String + Extension.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

extension String {
    func height(constrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
}


extension NSMutableAttributedString {
    func appendAttributedString(_ str: String,
                                font: UIFont? = nil,
                                color: UIColor? = nil) -> NSMutableAttributedString {
        
        var attributes = [NSAttributedString.Key: Any]()
        
        if let font = font {
            attributes[.font] = font
        }
        if let color = color {
            attributes[.foregroundColor] = color
        }
        
        let str = NSMutableAttributedString(string: str, attributes: attributes)
        self.append(str)
        return self
    }
}
