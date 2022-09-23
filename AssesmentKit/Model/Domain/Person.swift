//
//  BodyMassIndex.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/08/17.
//

import Foundation



struct Person {
    //生物学的な性別
    enum SexType: Int {
        case male = 0
        case female
    }
    
    private(set) var age: Int?
    private(set) var sex: SexType?
    private(set) var height: Float
    private(set) var weight: Float
    
    init?(height: Float, weight: Float, age: Int?, sex: SexType?) {
        guard 0 <= height, 0 <= weight else { return nil }
        
        if let age = age, let sex = sex {
            self.height = height
            self.weight = weight
            self.age = age
            self.sex = sex
        } else {
            self.height = height
            self.weight = weight
            self.age = nil
            self.sex = nil
        }
    }
}

extension Person {
    static var sampleData = [
        Person(height: 170, weight: 60, age: 25, sex: .male),
        Person(height: 150, weight: 50, age: 28, sex: .female),
        Person(height: 172, weight: 65, age: 30, sex: .male)
    ]
}

extension Person {
    static let allAge = Array(0...120)
}

