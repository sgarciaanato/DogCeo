//
//  Dog_CeoTests.swift
//  Dog CeoTests
//
//  Created by Samuel on 05-02-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import XCTest
@testable import Dog_Ceo

class Dog_CeoTests: XCTestCase {
    
    func testLoadAllBreeds() {
        
        let expectation = XCTestExpectation(description: "Download Breeds")
        
        let handler: (([Breed]?) -> Void) = { (breeds) in
            
            XCTAssertNotNil(breeds)
            XCTAssertNotEqual(breeds?.count,0)
            expectation.fulfill()
        }
        
        
        DogsApiManager().getBreeds(handler)
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testLoadSubBreedsByName() {
        
        let expectation = XCTestExpectation(description: "Download SubBreeds")
        
        let handler: (([Breed]?) -> Void) = { (breeds) in
            
            XCTAssertNotNil(breeds)
            XCTAssertNotEqual(breeds?.count,0)
            expectation.fulfill()
        }
        
        
        DogsApiManager().getSubBreeds("hound", completionHandler: handler)
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testLoadBreedGallery() {
        
        let expectation = XCTestExpectation(description: "Download Breeds Gallery")
        
        let handler: (([String]?) -> Void) = { (images) in
            
            XCTAssertNotNil(images)
            XCTAssertNotEqual(images?.count,0)
            expectation.fulfill()
            
        }
        
        DogsApiManager().getImagesBreeds("boxer",completionHandler: handler)
        
    
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testLoadSubBreedGallery() {
        
        let expectation = XCTestExpectation(description: "Download SubBreeds Gallery")
        
        let handler: (([String]?) -> Void) = { (images) in
            
            XCTAssertNotNil(images)
            XCTAssertNotEqual(images?.count,0)
            expectation.fulfill()
            
        }
        
        DogsApiManager().getImagesSubBreeds("bulldog",subBreedName: "boston",completionHandler: handler)
        
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    func testLoadImage(){
        
        let expectation = XCTestExpectation(description: "Download Breeds Image")
        
        let handler: ((UIImage?,String) -> Void) = { (image,identifier) in
            DispatchQueue.main.async {
                
                XCTAssertNotNil(image)
                XCTAssertNotNil(identifier)
                expectation.fulfill()
            }
        }
        
        DogsApiManager().getRandomBreedImage("eskimo", completionHandler: handler)
        wait(for: [expectation], timeout: 10.0)
    }
    
}
