//
//  BiteBuddy_RBCTests.swift
//  BiteBuddy_RBCTests
//
//  Created by MVijay on 26/10/23.
//

import XCTest
@testable import BiteBuddy_RBC

final class BiteBuddy_RBCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRestaurantListAPI() {
        guard let fileUrl = Bundle.main.url(forResource: "RestaurantList", withExtension: "json") else {
            return
        }
        do {
            let jsonData = try Data(contentsOf: fileUrl, options: .alwaysMapped)
            let dict = try JSONDecoder().decode(BusinessModel.self, from: jsonData)
            XCTAssertEqual(dict.businesses.first?.name, "Annapoorna" )
        } catch {
            XCTFail("Wrong error")
        }
    }
    
    func testRestaurantDetails() {
        guard let fileUrl = Bundle.main.url(forResource: "RestaurantDetails", withExtension: "json") else {
            return
        }
        do {
            let jsonData = try Data(contentsOf: fileUrl, options: .alwaysMapped)
            let dict = try JSONDecoder().decode(RestaurantDetailsModel.self, from: jsonData)
            XCTAssertTrue(dict.categories.map { $0.title }.contains("Indian") )
        } catch {
            XCTFail("Wrong error")
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
