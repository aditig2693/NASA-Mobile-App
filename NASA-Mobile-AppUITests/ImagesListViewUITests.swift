//
//  ImagesListViewUITests.swift
//  NASA-Mobile-AppUITests
//
//  Created by Aditi Patil on 10/05/2023.
//

import XCTest

final class ImagesListViewUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        app.launch()
        let listScreen = app.navigationBars["NASA Images"]
            let listScreenExists = NSPredicate(format: "exists == true")
            expectation(for: listScreenExists, evaluatedWith: listScreen, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testValidateUI() {
        
        let window = app.windows.element(boundBy: 0)
        let tableView = window.tables.element(matching: .table, identifier: "imageListTableView")
        XCTAssert(tableView.exists)
        XCTAssert(window.cells.element(matching: .cell, identifier: "listViewCell").firstMatch.exists)
        XCTAssert(window.searchFields["Search for...(e.g Apollo)"].exists)
    
    }
    
    func testDetailScreen() {
        let window = app.windows.element(boundBy: 0)
        window.cells.element(matching: .cell, identifier: "listViewCell").firstMatch.tap()
        XCTAssert(window.images.matching(identifier: "detailsImageView").element.exists)
        XCTAssert(window.staticTexts.matching(identifier: "dateLabel").element.exists)
        XCTAssert(window.textViews.matching(identifier: "detailsTextField").element.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
