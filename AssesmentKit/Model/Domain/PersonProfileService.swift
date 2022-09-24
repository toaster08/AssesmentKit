//
//  PersonProfileUseCase.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/08/17.
//

import Foundation

//not error type
enum CalculatorResult<T> {
    case success(T)
    case failure
}

class PersonProfileService {
    
    func profiledPerson(height: Float,
                        weight: Float,
                        age: Int? = nil,
                        sex: Person.SexType? = nil) -> Person? {
        guard let person
                = Person(height: height,
                         weight: weight,
                         age: age,
                         sex: sex) else {
                    return nil
                }
        return person
    }

}


