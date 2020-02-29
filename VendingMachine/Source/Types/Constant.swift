//
//  Constant.swift
//  VendingMachine
//
//  Created by Tuyen Le on 2/24/20.
//  Copyright © 2020 Tuyen Le. All rights reserved.
//

import Foundation

struct Constant {
    static let soldOut = "SOLD OUT"
    static let insertCoin = "INSERT COIN"
    static let exactChange = "EXACT CHANGE ONLY"
    static let thankyou = "THANK YOU"
    static let price = "PRICE"
}

struct Converter {
    static func twoDecimal(value: Double) -> Double {
        return Double(round(100*value)/100)
    }
}
