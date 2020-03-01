//
//  VendingMachineTests.swift
//  VendingMachineTests
//
//  Created by Tuyen Le on 2/24/20.
//  Copyright © 2020 Tuyen Le. All rights reserved.
//

import XCTest
@testable import VendingMachine

class VendingMachineTests: XCTestCase {

    var presenter = VendingMachinePresenter()
    var vendingMachineViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VendingMachine") as! VendingMachineViewController
    
    override func setUp() {
        vendingMachineViewController.loadView()
        presenter.delegate = vendingMachineViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfCoinInsert() {
        // insert valid coin
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.05")
        XCTAssertEqual(presenter.vendingMachine.quarterInserted, 2)
        XCTAssertEqual(presenter.vendingMachine.dimeInserted, 1)
        XCTAssertEqual(presenter.vendingMachine.nickleInserted, 1)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, "$\(Converter.twoDecimal(value: presenter.vendingMachine.coinInserted))")
        
        // insert invalid coin
        presenter.insert(coin: "0.01") // penny
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.01")
    }
    
    func testRequestReturnCoin() {
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.05")
        presenter.requestReturnCoins()
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.65")
    }
    
    func testPurchaseProduct() {
        // buy chip with exact change
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.25")

        XCTAssertEqual(presenter.vendingMachine.quarterInserted, 2)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, "$\(Converter.twoDecimal(value: presenter.vendingMachine.coinInserted))")

        presenter.dispense(product: .chip)

        XCTAssertEqual(presenter.vendingMachine.quarterInserted, 0)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.thankyou)
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.0")
        
        // buy chip with $0.60
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.1")
        
        XCTAssertEqual(presenter.vendingMachine.dimeInserted, 1)
        XCTAssertEqual(presenter.vendingMachine.quarterInserted, 2)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, "$\(Converter.twoDecimal(value: presenter.vendingMachine.coinInserted))")
        
        presenter.dispense(product: .chip)
        
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.exactChange) // need exact change since vending machine doesn't have $0.10
        presenter.requestReturnCoins() // customer request inserted coins
        
        // cutomer try again with $0.75 this time
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.25")
        presenter.insert(coin: "0.25")

        presenter.dispense(product: .chip)
        
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.thankyou)
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.25")
        
        // buy cola with just $0.25. Price of item will display since it's not enough coin. Cola costs $1.00
        presenter.insert(coin: "0.25")
        
        XCTAssertEqual(presenter.vendingMachine.quarterInserted, 1)
        presenter.dispense(product: .cola)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.price + ": $\(Product.cola.rawValue)")
        
        // insert $0.5 more to buy chip
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")

        presenter.dispense(product: .chip)

        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.thankyou)
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.25")
        
        // verify number of quarter, dime and nickle in vending machine
        XCTAssertEqual(presenter.vendingMachine.numberOfQuarter, 4)
        XCTAssertEqual(presenter.vendingMachine.numberOfDime, 5)
        XCTAssertEqual(presenter.vendingMachine.numberOfNickle, 0)

        // buy candy with $0.70
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")
        
        presenter.dispense(product: .candy)

        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.exactChange)

        // return coins
        presenter.requestReturnCoins()
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.7")
        
        // verify number of quarter, dime and nickle in vending machine
        XCTAssertEqual(presenter.vendingMachine.numberOfQuarter, 4)
        XCTAssertEqual(presenter.vendingMachine.numberOfDime, 5)
        XCTAssertEqual(presenter.vendingMachine.numberOfNickle, 0)
        
        // buy candy with $0.65
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.05")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")
        presenter.insert(coin: "0.1")
        
        presenter.dispense(product: .candy)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.thankyou)
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.0")
        
        XCTAssertEqual(presenter.vendingMachine.numberOfQuarter, 4)
        XCTAssertEqual(presenter.vendingMachine.numberOfDime, 8)
        XCTAssertEqual(presenter.vendingMachine.numberOfNickle, 7)
        
    }

}
