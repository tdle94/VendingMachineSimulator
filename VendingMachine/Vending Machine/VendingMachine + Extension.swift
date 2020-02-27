//
//  VendingMachine + Extension.swift
//  VendingMachine
//
//  Created by Tuyen Le on 2/24/20.
//  Copyright © 2020 Tuyen Le. All rights reserved.
//

import Foundation

extension VendingMachineViewController: VendingMachinePresenterDelegate {
    func notEnoughCoinInsert(for product: Product) {
        vendingMachineMessageLabel.text = Constant.price + ": $\(product.rawValue)"
    }
    
    func noCoinInsert() {
        vendingMachineMessageLabel.text = Constant.insertCoin
    }
    
    func updateInserted(coin: Double) {
        vendingMachineMessageLabel.text = "$\(Converter.twoDecimal(value: coin))"
    }

    func soldOut(display insertedCoins: Double) {
        vendingMachineMessageLabel.text = Constant.soldOut
    }

    func returnInvalid(coin: Double) {
        returnChangeLabel.text = "$\(Converter.twoDecimal(value: coin))"
    }

    func make(changes: Double) {
        returnChangeLabel.text = "$\(Converter.twoDecimal(value: changes))"
        vendingMachineMessageLabel.text = Constant.thankyou
        
    }

    func requestReturn(coin: Double) {
        returnChangeLabel.text = "$\(Converter.twoDecimal(value: coin))"
        vendingMachineMessageLabel.text = Constant.insertCoin
    }

    func requireExact(changes: Double) {
        vendingMachineMessageLabel.text = Constant.exactChange
    }
}
