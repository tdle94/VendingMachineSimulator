# VendingMachineSimulator [![Build Status](https://travis-ci.com/tdle94/VendingMachineSimulator.svg?branch=master)](https://travis-ci.com/tdle94/VendingMachineSimulator)

Initially the vending machine has 0 ``quarter``, 0 ``dime`` and 0 ``nickle`` but you can manually change the value in ```Model.swift``` file

```swift
struct Model {
  ...
 
  private(set) var numberOfQuarter: Int = 0
  private(set) var numberOfDime: Int = 0
  private(set) var numberOfNickle: Int = 0
 
  ...
}
```

## How to use
  - Insert coin
  - Select a product (if not enough coin then repeat step 1 or return changes)
  - Return changes to customers (vending machine might or might not have the appropriate changes. If it does not have the appropriate changes. Return changes to yourself and repeat step one)
  
## How vending machine works
  More on how vending machine [works](https://github.com/guyroyse/vending-machine-kata).
