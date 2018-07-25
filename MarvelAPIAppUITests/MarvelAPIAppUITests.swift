//
//  MarvelAPIAppUITests.swift
//  MarvelAPIAppUITests
//
//  Created by Luciano Sclovsky on 25/06/2018.
//

import XCTest
@testable import MarvelAPIApp

class MarvelAPIAppUITests: XCTestCase {
        
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIApplication().collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        //let t3dMan = CharacterViewModel.shared.
        //XCTAssert(<#T##expression: Bool##Bool#>)
    }
    
}
