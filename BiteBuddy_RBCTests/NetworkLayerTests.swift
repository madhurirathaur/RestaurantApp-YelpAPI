//
//  NetworkLayerTests.swift
//  BiteBuddy_RBCTests
//
//  Created by MVijay on 31/10/23.
//

import XCTest
@testable import BiteBuddy_RBC

let restaurantDetailsURL = "https://api.yelp.com/v3/businesses/4bIB83SCQvoKZ5Lzxv8J8Q"

final class NetworkLayerTests: XCTestCase {
    let sut_NetworkRequestor = MockNetworkRequestor()
    let imageURLString = "https://s3-media2.fl.yelpcdn.com/bphoto/oKB8RFiLJqAj3LSoBoh5ew/o.jpg"
   
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testNetworkRequestor() throws {
        XCTAssertEqual(sut_NetworkRequestor.request?.url?.absoluteString, restaurantDetailsURL)
    }
    
    func testNetworkSuccess() throws {
        let sut_NetworkSuccess = MockAPIServiceSuccessResult()
        sut_NetworkSuccess.sendRequest(expectedTypeObject: RestaurantDetailsModel.self, sut_NetworkRequestor) { result in
            switch result {
            case .failure( _ ):
                XCTFail()
            case .success(let details):
                XCTAssertEqual(details.review_count, 52)
            }
        }
    }
    
    func testNetworkFailure() throws {
        let sut_NetworkError = MockAPIServiceError()
        sut_NetworkError.sendRequest(expectedTypeObject: RestaurantDetailsModel.self, sut_NetworkRequestor) { result in
            switch result {
            case .failure( let error):
                XCTAssertEqual(error.localizedDescription, "Some Error" )
            case .success(_):
                XCTFail()
            }
        }
    }
    
    func testImageCacher() throws {
        guard let url = NSURL(string: imageURLString) else {
            return
        }
        ImageCache.shared.load(url: url) { _ in
           XCTAssertNotNil(ImageCache.shared.image(url: url)) 
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}




class MockNetworkRequestor : NetworkRequestor {
    var urlString: String {
        restaurantDetailsURL
    }
    
    var request: URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(yelpApiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}

class MockAPIServiceSuccessResult: NetworkHandler {
    typealias errorType = Error
    
    func sendRequest<T>(expectedTypeObject: T.Type, _ requestContainer: BiteBuddy_RBC.NetworkRequestor, completion: @escaping (BiteBuddy_RBC.ServiceResult<T, errorType>) -> Void) where T : Decodable {

        guard let fileUrl = Bundle.main.url(forResource: "RestaurantDetails", withExtension: "json") else {
            return
        }
        do {
            let jsonData = try Data(contentsOf: fileUrl, options: .alwaysMapped)
            let dict = try JSONDecoder().decode(T.self, from: jsonData)
            completion(.success(dict))
            return
        }
        catch {
            completion(.failure(error))
        }
    }
}

class MockAPIServiceError: NetworkHandler {
    typealias errorType = CommunicationError
    
    func sendRequest<T>(expectedTypeObject: T.Type, _ requestContainer: BiteBuddy_RBC.NetworkRequestor, completion: @escaping (BiteBuddy_RBC.ServiceResult<T, errorType>) -> Void) where T : Decodable {
        completion(.failure(.customError("Some Error")))
    }
}
