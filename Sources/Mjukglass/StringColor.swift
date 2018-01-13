//
//  StringColor.swift
//  Mjukglass
//
//  Created by Anton Roslund on 2017-10-23.
//  Copyright © 2017 Anton Roslund. All rights reserved.
//

import Foundation

public enum StringColor: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case boldRed = "\u{001B}[1;31m"
    case green = "\u{001B}[0;32m"
    case boldGreen = "\u{001B}[1;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case boldBlue = "\u{001B}[1;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
}

public func + (left: StringColor, right: String) -> String {
    return left.rawValue + right
}
public func + (left: String, right: StringColor) -> String {
    return left + right.rawValue
}
