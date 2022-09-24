//
//  PersonProfileService+Rohrer.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/23.
//

import Foundation

extension PersonProfileService {

    func calculateRohrerIndex(in person: Person) -> RohrerIndex? {
        let rohrerIndex = RohrerIndex(for: person)
        return rohrerIndex
    }

}

struct RohrerIndex {
    let value: Float
    
    init?(for person: Person) {
        guard let age = person.age, (6..<18).contains(age) else { return nil }
        value = person.weight / pow((person.height * 0.01),3) * 10
    }
    
    var evaluatedType: RohrerIndexType {
        let evaluation = RohrerIndexType(rohrerIndex: self.value)
        return evaluation
    }
}
