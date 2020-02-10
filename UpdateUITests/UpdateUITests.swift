//
//  UpdateUITests.swift
//  UpdateUITests
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import XCTest

class UpdateUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddFeed() {
        // UI tests must launch the application that they test.
        
        let app = XCUIApplication()
        app.launchArguments += ["UI-Testing"]
        app.launch()
        
        addFeed(with: app)

        let feedCell = app.tables.buttons["Swift Developer News - Hacking with Swift"]
        XCTAssertFalse(feedCell.exists)

        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: feedCell, handler: nil)

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(feedCell.exists)
    }
    
    func addFeed(with app: XCUIApplication) {
        app.navigationBars["Feeds"].buttons["New Feed"].tap()
        let urlTextField = app.textFields["URL"]
        urlTextField.tap()

        urlTextField.doubleTap()
        urlTextField.typeText("https://www.hackingwithswift.com/articles/rss")
        
        app.buttons["Add feed"].tap()
    }
    
    func testReadPost() {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.buttons["Swift Developer News - Hacking with Swift"].tap()
        tablesQuery.buttons.firstMatch.tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCTestCase {

  func wait(for duration: TimeInterval) {
    let waitExpectation = expectation(description: "Waiting")

    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
      waitExpectation.fulfill()
    }

    // We use a buffer here to avoid flakiness with Timer on CI
    waitForExpectations(timeout: duration + 0.5)
  }
}
