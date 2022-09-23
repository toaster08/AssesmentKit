//
//  PersonProfileService+Rohrer.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/23.
//

import Foundation

extension PersonProfileService {

    func calculateRohrerIndex(in person: Person) -> Float {
        let rohrerIndex = person.weight / pow((person.height * 0.01),3) * 10
        return rohrerIndex
    }

}
