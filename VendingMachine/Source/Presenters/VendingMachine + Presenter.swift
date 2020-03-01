//
//  VendingMachineViewModel.swift
//  VendingMachine
//
//  Created by Tuyen Le on 2/24/20.
//  Copyright © 2020 Tuyen Le. All rights reserved.
//

import Foundation


protocol VendingMachinePresenterDelegate: AnyObject {
    func requestReturn(coin: Double)
    func requireExact(changes: Double)
    func make(changes: Double)
    func returnInvalid(coin: Double)
    func soldOut(return insertedCoins: Double)
    func updateInserted(coin: Double)
    func notEnoughCoinInsert(for product: Product)
    func noCoinInsert()
}

struct VendingMachinePresenter {

    private(set) var vendingMachine = Model()
    
    weak var delegate: VendingMachinePresenterDelegate?

    mutating func insert(coin text: String?) {
        guard let text = text, let value = Double(text) else {
            return
        }

        if let coin = Coin(rawValue: value) {
            vendingMachine.insert(coin: coin)
            delegate?.updateInserted(coin: vendingMachine.coinInserted)
        } else {
            delegate?.returnInvalid(coin: value)      // return invalid coin to customer
        }
    }

    mutating func dispense(product: Product) {
        /// Make sure product is still available
        guard vendingMachine.canBuy(product: product) else {
            delegate?.soldOut(return: vendingMachine.coinInserted)
            return
        }

        guard vendingMachine.coinInserted >= product.rawValue else {
            if vendingMachine.coinInserted == 0.0 {
                delegate?.noCoinInsert()
            } else {
                delegate?.notEnoughCoinInsert(for: product)
            }
            return
        }

        var changesNeed = vendingMachine.coinInserted - product.rawValue
        let changesReturnToCustomer = changesNeed

        let quartersNeed = Int(changesNeed / 0.25)
        changesNeed = Converter.twoDecimal(value: changesNeed - Double(quartersNeed) * 0.25)
        
        let dimesNeed = Int(changesNeed / 0.10)
        changesNeed = Converter.twoDecimal(value: changesNeed - Double(dimesNeed) * 0.10)
        
        let nicklesNeed = Int(changesNeed / 0.05)
        changesNeed = Converter.twoDecimal(value: changesNeed - Double(nicklesNeed) * 0.05)

        if vendingMachine.numberOfQuarter < quartersNeed || vendingMachine.numberOfDime < dimesNeed || vendingMachine.numberOfNickle < nicklesNeed {
            delegate?.requireExact(changes: product.rawValue)
            return
        }

        vendingMachine.subtractNumberOf(quarter: quartersNeed)
        vendingMachine.subtractNumberOf(dime: dimesNeed)
        vendingMachine.subtractNumberOf(nickle: nicklesNeed)

        delegate?.make(changes: changesReturnToCustomer)
        vendingMachine.buy(product: product)
    }

    mutating func requestReturnCoins() {
        delegate?.requestReturn(coin: vendingMachine.coinInserted) // customer request inserted amount back
        vendingMachine.resetCoinInserted()
    }
}
