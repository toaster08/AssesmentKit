//
//  PersonProfileService+ObesityIndex.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/23.
//

import Foundation

extension PersonProfileService {
    
    func calculateObesityIndex(in person: Person) -> CalculatorResult<Float> {
        
        guard let age = person.age, age < 18 else { return
            .failure
        }

        let standardBodyWeight = calculateStandardBodyWeight(for: person)
        switch standardBodyWeight {
        case .success(let standardBodyWeight):
            let bodyWeight = person.weight
            let obesityIndex = (bodyWeight - standardBodyWeight) / standardBodyWeight * 100
            return .success(obesityIndex)
        case .failure: //二重でエラーを渡している
            return .failure
        }
    }
    
}
