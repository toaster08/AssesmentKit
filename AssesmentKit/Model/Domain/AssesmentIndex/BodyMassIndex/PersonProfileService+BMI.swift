//
//  PersonProfileService+BMI.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/23.
//

import Foundation

extension PersonProfileService {
    
    func calculateBMI(in person: Person) -> Float {
        let bmi = person.weight / pow((person.height * 0.01), 2)
        return bmi
    }
    
    func calculateBMI(in person: Person) -> BMI? {
        guard let bmi = BMI(for: person) else { return nil }
        return bmi
    }
    
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
    
}

struct BMI {
    let value: Float
    let age: Int
    
    init?(for person: Person) {
        guard let age = person.age else { return nil }
        self.age = age
        
        value = person.weight / pow((person.height * 0.01), 2)
    }
    
    var evaluateBMI: BodyMassIndexType {
        let evaluation = BodyMassIndexType(bmi: self)
        return evaluation
    }
    
    func targetBMI() -> ClosedRange<Float>? {
        switch age {
        case 18..<49: return (18.5...24.9)
        case 49..<64: return (20.0...24.9)
        case 65..<74: return (21.5...24.9)
        case 75...: return (21.5...24.9)
        default: return nil
        }
    }
}
