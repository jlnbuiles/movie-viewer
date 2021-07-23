//
//  MovieTests.swift
//  MovieViewerTests
//
//  Created by builes on 22/07/21.
//

import XCTest

@testable import MovieViewer

let movie1Popularity = 120.3
let movie2Popularity = 20.3
let movie1Title = "The Jungle book"
let movie2Title = "Cinderella"
let movie1ID = 1234
let movie2ID = 4456
let movie1Overview = "this is a story of a wise young man"
let movie2Overview = "this is a story about a poor girl"
let movie1Path = "/uXDfjJbdP4ijW5hWSBrPrlKpxab.jpg"
let movie2Path = "/bdP4ijW5hWSBrPrlKpxfdsa34324b.jpg"
let movie1releaseDate = "1942-12-21"
let movie2releaseDate = "2004-04-21"


class MovieTests: XCTestCase {

    // MARK: - Properties
    private var validJSONResponse1: [String : Any]!
    private var validJSONResponse2: [String : Any]!
    private var movie1: Movie!
    private var movie2: Movie!
    
    // MARK: - Tests Configuration
    override func setUpWithError() throws {
        super.setUp()
        
        validJSONResponse1 = [
            "name": movie1Title,
            "id": movie1ID,
            "popularity": movie1Popularity,
            "overview": movie1Overview,
            "poster_path": movie1Path,
            "release_date": movie1releaseDate
        ] as [String: Any]
        
        validJSONResponse2 = [
            "name": movie2Title,
            "id": movie2ID,
            "popularity": movie2Popularity,
            "overview": movie2Overview,
            "poster_path": movie2Path,
            "release_date": movie2releaseDate
        ] as [String: Any]
        
        try movie1 = Movie(JSON: validJSONResponse1)
        try movie2 = Movie(JSON: validJSONResponse2)
    }
    
    override func tearDownWithError() throws {
        validJSONResponse1 = nil
        movie1 = nil
        movie2 = nil
    }

    // MARK: - Tests
    func testCorrectInitialization() throws {
        let movie = try Movie(JSON: validJSONResponse1)
        XCTAssertEqual(movie.externalID, movie1.externalID)
        XCTAssertEqual(movie.imageURL, movie1.imageURL)
        XCTAssertEqual(movie.imageURL?.absoluteString, MID_IMG_BASE_URL + movie1Path)
        XCTAssertEqual(movie.popularity, movie1.popularity)
        XCTAssertEqual(movie.title, movie1.title)
        XCTAssertEqual(movie.releaseDate, movie1.releaseDate)
        XCTAssertEqual(movie.overview, movie1.overview)
        XCTAssertNotEqual(movie, movie1)
        XCTAssertNotEqual(movie, movie2)
        XCTAssertNotEqual(movie2, movie1)
    }
    
    func testEmptyJSONThrows() throws {
        let emptyJSON = [String: Any]()
        XCTAssertThrowsError(try Movie(JSON: emptyJSON))
    }
    
    func testInvalidJSONThrows() throws {
        let emptyJSON = ["baby boy": [3,4,6]]
        XCTAssertThrowsError(try Movie(JSON: emptyJSON))
    }
    
    func testValidJSONNoThrows() throws {
        XCTAssertNoThrow(try Movie(JSON: validJSONResponse1))
    }
    
    func testIDMissingInJSONThrows() throws {
        
        let JSONResponseWithNoID = [
            "name": movie1Title,
            "popularity": movie1Popularity,
            "overview": movie1Overview,
            "poster_path": movie1Path,
            "release_date": movie1releaseDate
        ] as [String : Any]
        
        XCTAssertThrowsError(try Movie(JSON: JSONResponseWithNoID))
    }
    
    func testNameMissingInJSONThrows() throws {
        
        let JSONResponseWithNameMissing = [
            "id": movie1ID,
            "popularity": movie1Popularity,
            "overview": movie1Overview,
            "poster_path": movie1Path,
            "release_date": movie1releaseDate
        ] as [String : Any]
        
        XCTAssertThrowsError(try Movie(JSON: JSONResponseWithNameMissing))
    }

    func testOptionalFieldsMissingInJSONNoThrows() throws {
        
        let JSONResponseWithOptionalFieldsMissing = [
            "id": movie1ID,
            "name": movie1Title,
            "title": movie1Title
        ] as [String : Any]
        
        XCTAssertNoThrow(try Movie(JSON: JSONResponseWithOptionalFieldsMissing))
    }
    
    func testInvalidTypesOptionalFieldsInJSONNoThrows() throws {
        
        let JSONResponseWithInvalidOptionalTypes = [
            "id": movie1ID,
            "name": movie1Title,
            "popularity": "abcvd",
            "overview": 123,
            "poster_path": 234,
        ] as [String : Any]
        
        XCTAssertNoThrow(try Movie(JSON: JSONResponseWithInvalidOptionalTypes))
    }
    
    func testEmptyOptionalFieldsInJSONNoThrows() throws {
        
        let JSONResponseWithNoEmptyOptionalFields = [
            "id": movie1ID,
            "name": movie1Title,
            "popularity": "",
            "overview": "",
            "poster_path": ""
        ] as [String : Any]
        
        XCTAssertNoThrow(try Movie(JSON: JSONResponseWithNoEmptyOptionalFields))
    }
    
    func testBothNameAndTitleInJSONNoThrows() throws {
        
        let JSONResponseWithTitleAndName = [
            "id": movie1ID,
            "name": movie1Title,
            "popularity": movie1Popularity,
            "overview": movie1Overview,
            "poster_path": movie1Path,
            "title": movie1Title
        ] as [String : Any]
        
        XCTAssertNoThrow(try Movie(JSON: JSONResponseWithTitleAndName))
    }
    
    func testBothTitleAndNameSetTheSameValue() throws {
        
        let JSONResponseWithTitleNoName = [
            "id": movie1ID,
            "popularity": movie1Popularity,
            "overview": movie1Overview,
            "poster_path": movie1Path,
            "title": movie1Title
        ] as [String : Any]
        
        let movie = try Movie(JSON: JSONResponseWithTitleNoName)
        
        XCTAssertEqual(movie.title, movie.title)
    }
    
    func testNameInvalidReleaseDateInJSONNoThrows() throws {
        
        let JSONResponseWithInvalidDate = [
            "id": movie1ID,
            "name": movie1Title,
            "popularity": movie1Popularity,
            "overview": movie1Overview,
            "poster_path": movie1Path,
            "release_date": "1195abcd"
        ] as [String : Any]
        
        XCTAssertNoThrow(try Movie(JSON: JSONResponseWithInvalidDate))
    }
    
    func testinstancesWithDifferentValuesNotEqual() {
        XCTAssertNotEqual(movie1.externalID, movie2.externalID)
        XCTAssertNotEqual(movie1.title, movie2.title)
        XCTAssertNotEqual(movie1.releaseDate, movie2.releaseDate)
        XCTAssertNotEqual(movie1.overview, movie2.overview)
        XCTAssertNotEqual(movie1.imageURL, movie2.imageURL)
        XCTAssertNotEqual(movie1.popularity, movie2.popularity)
    }
}
