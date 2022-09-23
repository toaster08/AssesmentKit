//
//  AssesmentKitTests.swift
//  AssesmentKitTests
//
//  Created by 山田　天星 on 2022/08/07.
//

import XCTest
@testable import AssesmentKit

class AssesmentKitTests: XCTestCase {

    func test_BMIの計算結果が算出される() {
        guard let person = Person(height: 170,
                                  weight: 60,
                                  age: 24,
                                  sex: .male) else {
            return
        }
        let bmi = BMI(for: person)
        
        XCTAssertNotNil(bmi)
    }

}
