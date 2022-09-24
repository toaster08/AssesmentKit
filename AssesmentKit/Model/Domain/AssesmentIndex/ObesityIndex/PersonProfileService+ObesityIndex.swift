//
//  PersonProfileService+ObesityIndex.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/23.
//

import Foundation

extension PersonProfileService {
    func calculateObesityIndex(in person: Person) -> ObesityIndex? {
        let obesityIndex = ObesityIndex(for: person)
        return obesityIndex
    }
}

struct ObesityIndex {
    let value: Float
    
    init?(for person: Person) {
        guard person.age != nil else { return nil }
        let standardBodyWeight = person.calculateStandardBodyWeight()
        
        switch standardBodyWeight {
        case .success(let standardBodyWeight):
            let bodyWeight = person.weight
            let obesityIndex = (bodyWeight - standardBodyWeight) / standardBodyWeight * 100
            value = obesityIndex
        case .failure: //二重でエラーを渡している
            return nil
        }

    }
    
    var evaluatedType: ObesityIndexType {
        let evaluation = ObesityIndexType(obesityIndex: self.value)
        return evaluation
    }
}

