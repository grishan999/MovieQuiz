//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by mac on 03.12.2024.
//
import XCTest
@testable import MovieQuiz

func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
    // Given
    let array = [1, 1, 2, 3, 5]
    
    // When
    let value = array[safe: 2]
    
    // Then
    XCTAssertNotNil(value)
    XCTAssertEqual(value, 2)
}

func testGetValueOutOfRange() throws {
    // Given
    let array = [1, 1, 2, 3, 5]
    
    // When
    let value = array[safe: 20]
    
    // Then
    XCTAssertNil(value)
}
