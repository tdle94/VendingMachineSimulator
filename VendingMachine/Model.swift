//
//  Model.swift
//  VendingMachine
//
//  Created by Tuyen Le on 2/24/20.
//  Copyright © 2020 Tuyen Le. All rights reserved.
//

import Foundation

struct Model {
    /** Return the total amount of coin inserted */
    var coinInserted: Double {
        return Double(quarterInserted) * 0.25 + Double(dimeInserted) * 0.1 + Double(nickleInserted) * 0.05
    }

    /**
     Number of quarters, dimes and nickles in the vending machine.
     They are used to return changes back to customers.
     */
    private(set) var numberOfQuarter: Int = 0
    private(set) var numberOfDime: Int = 0
    private(set) var numberOfNickle: Int = 0

    /**
     Keep track of the number of quarters, dimes and nickles customer insert.
     They will be clear once a successful purchase is made.
     */
    private(set) var quarterInserted: Int = 0
    private(set) var dimeInserted: Int = 0
    private(set) var nickleInserted: Int = 0
    
    /**
     Number of candy, cola and chip available
     */
    private(set) var candy: Int = 12
    private(set) var cola: Int = 12
    private(set) var chip: Int = 12

    mutating func insert(coin: Coin) {
        switch coin {
        case .quarter:
            quarterInserted += 1
            break
        case .dime:
            dimeInserted += 1
            break
        case .nickle:
            nickleInserted += 1
        }
    }
    
    mutating func subtractNumberOf(quarter by: Int) {
        numberOfQuarter -= by
    }
    
    mutating func subtractNumberOf(dime by: Int) {
        numberOfDime -= by
    }
    
    mutating func subtractNumberOf(nickle by: Int) {
        numberOfNickle -= by
    }
    
    mutating func canBuy(product: Product) -> Bool {
        var canBeBought = false

        switch product {
        case .candy:
            if candy > 0 {
                canBeBought = true
            }
            break
        case .chip:
            if chip > 0 {
                canBeBought = true
            }
            break
        case .cola:
            if cola > 0 {
                canBeBought = true
            }
        }

        return canBeBought
    }
    
    mutating func buy(product: Product) {
        guard canBuy(product: product) else {
            return
        }

        switch product {
        case .candy:
            candy -= 1
            break
        case .chip:
            chip -= 1
            break
        case .cola:
            cola -= 1
        }

        numberOfQuarter += quarterInserted
        numberOfDime += dimeInserted
        numberOfNickle += nickleInserted

        resetCoinInserted()
    }
    
    mutating func resetCoinInserted() {
        quarterInserted = 0
        dimeInserted = 0
        nickleInserted = 0
    }
}
