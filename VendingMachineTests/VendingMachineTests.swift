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

    var vendingMachinePresenter = VendingMachinePresenter()
    var vendingMachineViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VendingMachine") as! VendingMachineViewController
    
    override func setUp() {
        vendingMachineViewController.loadView()
        vendingMachinePresenter.delegate = vendingMachineViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfCoinInsert() {
        // insert valid coin
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.05")
        XCTAssertEqual(vendingMachinePresenter.model.quarterInserted, 2)
        XCTAssertEqual(vendingMachinePresenter.model.dimeInserted, 1)
        XCTAssertEqual(vendingMachinePresenter.model.nickleInserted, 1)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, "$\(Converter.twoDecimal(value: vendingMachinePresenter.model.coinInserted))")
        
        // insert invalid coin
        vendingMachinePresenter.insert(coin: "0.01") // penny
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.01")
    }
    
    func testRequestReturnCoin() {
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.requestReturnCoins()
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.65")
    }
    
    func testPurchaseProduct() {
        // buy chip with exact change
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.25")

        XCTAssertEqual(vendingMachinePresenter.model.quarterInserted, 2)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, "$\(Converter.twoDecimal(value: vendingMachinePresenter.model.coinInserted))")

        vendingMachinePresenter.dispense(product: .chip)

        XCTAssertEqual(vendingMachinePresenter.model.quarterInserted, 0)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.thankyou)
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.0")
        
        // buy chip with $0.60
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.1")
        
        XCTAssertEqual(vendingMachinePresenter.model.dimeInserted, 1)
        XCTAssertEqual(vendingMachinePresenter.model.quarterInserted, 2)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, "$\(Converter.twoDecimal(value: vendingMachinePresenter.model.coinInserted))")
        
        vendingMachinePresenter.dispense(product: .chip)
        
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.exactChange) // need exact change since vending machine doesn't have $0.10
        vendingMachinePresenter.requestReturnCoins() // customer request inserted coins
        
        // cutomer try again with $0.75 this time
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.25")
        vendingMachinePresenter.insert(coin: "0.25")

        vendingMachinePresenter.dispense(product: .chip)
        
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.thankyou)
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.25")
        
        // buy cola with just $0.25. Price of item will display since it's not enough coin. Cola costs $1.00
        vendingMachinePresenter.insert(coin: "0.25")
        
        XCTAssertEqual(vendingMachinePresenter.model.quarterInserted, 1)
        vendingMachinePresenter.dispense(product: .cola)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.price + ": $\(Product.cola.rawValue)")
        
        // insert $0.5 more to buy chip
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")

        vendingMachinePresenter.dispense(product: .chip)

        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.thankyou)
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.25")
        
        // verify number of quarter, dime and nickle in vending machine
        XCTAssertEqual(vendingMachinePresenter.model.numberOfQuarter, 4)
        XCTAssertEqual(vendingMachinePresenter.model.numberOfDime, 5)
        XCTAssertEqual(vendingMachinePresenter.model.numberOfNickle, 0)

        // buy candy with $0.70
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")
        
        vendingMachinePresenter.dispense(product: .candy)

        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.exactChange)

        // return coins
        vendingMachinePresenter.requestReturnCoins()
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.7")
        
        // verify number of quarter, dime and nickle in vending machine
        XCTAssertEqual(vendingMachinePresenter.model.numberOfQuarter, 4)
        XCTAssertEqual(vendingMachinePresenter.model.numberOfDime, 5)
        XCTAssertEqual(vendingMachinePresenter.model.numberOfNickle, 0)
        
        // buy candy with $0.65
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.05")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")
        vendingMachinePresenter.insert(coin: "0.1")
        
        vendingMachinePresenter.dispense(product: .candy)
        XCTAssertEqual(vendingMachineViewController.vendingMachineMessageLabel.text, Constant.thankyou)
        XCTAssertEqual(vendingMachineViewController.returnChangeLabel.text, "$0.0")
        
        XCTAssertEqual(vendingMachinePresenter.model.numberOfQuarter, 4)
        XCTAssertEqual(vendingMachinePresenter.model.numberOfDime, 8)
        XCTAssertEqual(vendingMachinePresenter.model.numberOfNickle, 7)
        
    }

}
