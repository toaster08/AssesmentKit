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
    
    init?(height: Float,
          weight: Float,
          age: Int?,
          sex: SexType?) {
        
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

extension Person {
    func calculateStandardBodyWeight() -> CalculatorResult<Float> {
        guard let age = self.age else { return .failure }
        
        if age < 18 {
            guard let standardBodyWeight
                    = calculateStandardWeightForChild(in: self) else {
                return .failure
            }
            return .success(standardBodyWeight)
            
        }
        
        if 18 <= age {
            guard let standardBodyWeight
                    = calculateStandardWeightForAdult(in: self) else {
                return .failure
            }
            return .success(standardBodyWeight)
        }
        
        return .failure
    }
    
    //age over18
    private func calculateStandardWeightForAdult(in person: Person) -> Float? {
        guard let age = person.age, 18 <= age else { return nil }
        let height = person.height * 0.01
        return height * height * 22.0
    }
    
    //age before17
    private func calculateStandardWeightForChild(in person: Person) -> Float? {
        guard let sex = person.sex,
              let age = person.age, age < 18 else { return nil }
        
        //height(cm)
        let height = person.height

        let pattern = (age: age, height: height)
        
        switch sex {
            
        case .male:
            switch pattern {
            case (age: ..<6 , height: 70..<120) :
                return 0.00206 * pow(height, 2) - 0.1166 * height + 6.5273
            case (age: 6... , height: 100..<140) :
                return 0.0000303882 * pow(height, 3) - 0.00571495 * pow(height, 2) + 0.508124 * height - 9.17791
            case (age: 6... , height: 140..<149) :
                return -0.000085013 * pow(height, 3) + 0.0370692 * pow(height, 2) - 4.6558 * height + 191.847
            case (age: 6... , height: 149..<184) :
                return -0.000310205 * pow(height, 3) + 0.151159 * pow(height, 2) - 23.6303 * height + 1231.04
            default : return nil
            }
            
        case .female:
            switch pattern {
            case (age: ..<6 , height: 70..<120 ) :
                return 0.00249 * pow(height, 2) - 0.1858 * height + 9.0360
            case (age: 6... , height: 100..<140) :
                return 0.000127719 * pow(height, 3) - 0.0414712 * pow(height, 2) + 4.8575 * height - 184.492
            case (age: 6... , height: 140..<149) :
                return -0.00178766 * pow(height, 3) + 0.803922 * pow(height, 2) - 119.31 * height + 5885.03
            case (age: 6... , height: 149..<171) :
                return 0.000956401 * pow(height, 3) - 0.462755 * pow(height, 2) + 75.3058 * height - 4068.31
            default : return nil
            }
        }
    }
}
