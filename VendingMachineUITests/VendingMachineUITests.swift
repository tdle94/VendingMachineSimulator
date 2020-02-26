//
//  VendingMachineUITests.swift
//  VendingMachineUITests
//
//  Created by Tuyen Le on 2/24/20.
//  Copyright © 2020 Tuyen Le. All rights reserved.
//

import XCTest

class VendingMachineUITests: XCTestCase {
    
    let app = XCUIApplication()
    lazy var coinInputTextField = app.textFields["CoinInputTextField"]
    lazy var insertCoinButton = app.buttons["InsertCointButton"]
    lazy var displayMessage = app.staticTexts["DisplayMessage"]
    lazy var changesReturn = app.staticTexts["ChangeLabel"]
    lazy var buyCandyButton = app.buttons["BuyCandyButton"]
    lazy var buyColaButton = app.buttons["BuyColaButton"]
    lazy var buyChipButton = app.buttons["BuyChipButton"]
    lazy var returnCoinButton = app.buttons["ReturnCoinButton"]


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInsertCoin() {
        // valid coin
        coinInputTextField.tap()
        coinInputTextField.typeText("0.05")
        insertCoinButton.tap()
        XCTAssertEqual(displayMessage.label, "$0.05")
        
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        XCTAssertEqual(displayMessage.label, "$0.3")

        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()
        XCTAssertEqual(displayMessage.label, "$0.4")
        
        // invalid coin
        coinInputTextField.clearAndEnterText(text: "0.01")
        insertCoinButton.tap()
        XCTAssertEqual(displayMessage.label, "$0.4")
        XCTAssertEqual(changesReturn.label, "$0.01")
        
        coinInputTextField.clearAndEnterText(text: "10")
        insertCoinButton.tap()
        XCTAssertEqual(displayMessage.label, "$0.4")
        XCTAssertEqual(changesReturn.label, "$10.0")
    }
    
    func testReturnCoin() {
        coinInputTextField.typeText("0.05")
        coinInputTextField.typeText("0.25")
        coinInputTextField.typeText("0.05")
        coinInputTextField.typeText("0.1")
        
        XCTAssertEqual(displayMessage.label, "$0.45")
        returnCoinButton.tap()
        XCTAssertEqual(changesReturn.label, "$0.45")
        XCTAssertEqual(displayMessage.label, "INSERT COIN")
        
    }
    
    func testPurchase() {
        // purchase chip with exact change. Return $0.0 change
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()

        buyChipButton.tap()
        XCTAssertEqual(changesReturn.label, "$0.0")
        XCTAssertEqual(displayMessage.label, "THANK YOU")

        // purchase candy with $0.90. Return $0.25 change
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.10")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.05")
        insertCoinButton.tap()

        buyCandyButton.tap()
        XCTAssertEqual(changesReturn.label, "$0.25")
        XCTAssertEqual(displayMessage.label, "THANK YOU")

        // purchase chip with $0.55. return change $0.05
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()

        buyChipButton.tap()
        XCTAssertEqual(changesReturn.label, "$0.05")
        XCTAssertEqual(displayMessage.label, "THANK YOU")

        // purchase candy with $0.70. notify customer that they need exact changes b/c vending machine is out of $0.05
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()

        buyCandyButton.tap()
        XCTAssertEqual(displayMessage.label, "EXACT CHANGE ONLY")

        // customer continue to insert $0.20 to purchase candy. Return $0.20 change
        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()

        buyCandyButton.tap()
        XCTAssertEqual(changesReturn.label, "$0.25")
        XCTAssertEqual(displayMessage.label, "THANK YOU")
        
        returnCoinButton.tap() // customer wants to return coins

        // customer insert $0.10 -> Try to buy cola -> Display cola's price to customer b/c they don't put in enough coin.
        coinInputTextField.clearAndEnterText(text: "0.1")
        insertCoinButton.tap()

        buyColaButton.tap()
        XCTAssertEqual(displayMessage.label, "PRICE: $1.0")

        // customer want their changes back
        returnCoinButton.tap()
        XCTAssertEqual(changesReturn.label, "$0.1")
        XCTAssertEqual(displayMessage.label, "INSERT COIN")

        // customer insert $1.1 to purchase cola
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()
        coinInputTextField.clearAndEnterText(text: "0.25")
        insertCoinButton.tap()

        buyColaButton.tap()
        XCTAssertEqual(displayMessage.label, "THANK YOU")
    }
}

extension XCUIElement {
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
