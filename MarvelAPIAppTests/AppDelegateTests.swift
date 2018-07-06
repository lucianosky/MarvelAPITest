//
//  AppDelegateTests.swift
//  MarvelAPIAppTests
//
//  Created by SoftDesign on 06/07/2018.
//  Copyright © 2018 SoftDesign. All rights reserved.
//

import XCTest
import UIKit

@testable import MarvelAPIApp

class AppDelegateTests: XCTestCase {
    
    var appDelegate: AppDelegate!

    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
        UIApplication.shared.delegate = appDelegate
    }

    override func tearDown() {
        super.tearDown()
        appDelegate = nil
        UIApplication.shared.delegate = nil
    }

    func testExample() {
        XCTAssertNotNil(appDelegate)
        XCTAssertTrue(appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: [:]))
    }
    
}
