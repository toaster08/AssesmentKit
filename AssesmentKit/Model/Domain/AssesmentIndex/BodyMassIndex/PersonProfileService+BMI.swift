//
//  PersonProfileService+BMI.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/23.
//

import Foundation

//それぞれの機能に関してはextensiotnで繋げる
//大元でPersonを作り出す必要があるため
extension PersonProfileService {
    
    func targetBMI(for person: Person) -> ClosedRange<Float>? {
        guard let age = person.age else { return nil }
        switch age {
        case 18..<49: return (18.5...24.9)
        case 49..<64: return (20.0...24.9)
        case 65..<74: return (21.5...24.9)
        case 75...: return (21.5...24.9)
        default: return nil
        }
    }
    
    func calculateBMI(for person: Person) -> BMI? {
        let bmi = BMI(for: person)
        return bmi
    }
    
    func evaluate(_ bmi: BMI) -> BodyMassIndexType {
        let evaluatedType = bmi.evaluatedType
        return evaluatedType
    }
}

struct BMI {
    let value: Float
    
    init(for person: Person) {
        value = person.weight / pow((person.height * 0.01), 2)
    }
    
    var evaluatedType: BodyMassIndexType {
        let evaluation = BodyMassIndexType(bmi: self)
        return evaluation
    }
}
