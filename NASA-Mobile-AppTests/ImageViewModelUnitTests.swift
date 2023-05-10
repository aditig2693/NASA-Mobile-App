//
//  ImageViewModelUnitTests.swift
//  NASA-Mobile-AppTests
//
//  Created by Aditi Patil on 10/05/2023.
//

import XCTest
import NASA_Mobile_App

final class ImageViewModelUnitTests: XCTestCase {
        
        var testSubject = ImageViewModel()
        
        override func setUp() {
            super.setUp()
        }
        
        override func tearDown() {
            super.tearDown()
        }
        
        func testGetNASAItemsReturnsSuccessWithValidSearchString() {
            let expectation = self.expectation(description: "API call completes successfully")
            var response: HTTPResponse?
            
            testSubject.getNASAItems(searchString: "Apollo", endPoint: APIConstants.search, completion: { result in
                response = result
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 10, handler: nil)
            
            XCTAssertNotNil(response)
            XCTAssertEqual(response, .success)
        }
        
        func testGetNASAItemsReturnsFailureWithInvalidSearchString() {
            let expectation = self.expectation(description: "API call fails with invalid search string")
            var response: HTTPResponse?
            testSubject.getNASAItems(searchString: "", endPoint: "", completion: { result in
                switch result {
                    
                case .success:
                    break
                case .failure(error: let err):
                    response = result
                    XCTAssertEqual(response,.failure(error: err))
                }
                XCTAssertNotNil(response)
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 10, handler: nil)
            
        }
        

}
