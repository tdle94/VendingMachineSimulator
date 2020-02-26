//
//  ViewController.swift
//  VendingMachine
//
//  Created by Tuyen Le on 2/24/20.
//  Copyright © 2020 Tuyen Le. All rights reserved.
//

import UIKit

class VendingMachineViewController: UIViewController {

    var presenter = VendingMachinePresenter()

    // MARK: - ui components

    @IBOutlet weak var insertCoinTextField: UITextField!
    @IBOutlet weak var vendingMachineMessageLabel: UILabel!
    @IBOutlet weak var returnChangeLabel: UILabel!
    @IBOutlet weak var amountInsertedLabel: UILabel!

    // MARK: - override

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
    }

    // MARK: - user action

    @IBAction func buyChip() {
        presenter.dispense(product: .chip)
    }

    @IBAction func buyCola() {
        presenter.dispense(product: .cola)
    }

    @IBAction func buyCandy() {
        presenter.dispense(product: .candy)
    }

    @IBAction func returnCoin() {
        presenter.requestReturnCoins()
    }

    @IBAction func insertCoin() {
        presenter.insert(coin: insertCoinTextField.text)
    }
}


