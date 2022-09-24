//
//  BodyMassIndexViewModel.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/23.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol Input {
    
}

protocol Output {
    
}

struct BodyEvaluationViewModel: Input, Output {
    
    let bmiObservable: Observable<BMI?>
    let obesityIndexObservable: Observable<ObesityIndex?>
    let rohrerIndexObservable: Observable<RohrerIndex?>
    
    init?(input: (
        age: Observable<(row: Int, component: Int)>,
        sexType: Observable<Int>,
        height: Observable<Float>,
        weight: Observable<Float>
    )) {
        let personProfileService = PersonProfileService()

        let bmiObservable = Observable
            .combineLatest (
                input.age,
                input.sexType,
                input.height,
                input.weight
            ) { (age: (row: Int, component: Int),
                 sex: Int,
                 height: Float,
                 weight: Float) -> BMI? in
                
                guard let person = personProfileService
                        .profiledPerson(height: height,
                                        weight: weight) else {
                            return nil
                        }
                let bmi = personProfileService.calculateBMI(for: person)
                return bmi
            }
        
        let obesityIndexObservable = Observable
            .combineLatest (
                input.age,
                input.sexType,
                input.height,
                input.weight
            ) { (age: (row: Int, component: Int),
                 sex: Int,
                 height: Float,
                 weight: Float) -> ObesityIndex? in

                //Indexの場合にどのPersonを作るか
                guard let person = personProfileService
                        .profiledPerson(height: height,
                                        weight: weight,
                                        age: age.row,
                                        sex: Person.SexType(rawValue: sex)
                        ) else {
                            return nil
                        }
                        
                let obesityIndex = personProfileService.calculateObesityIndex(in: person)
                return obesityIndex
            }

        let rohrelIndexObservable = Observable
            .combineLatest (
                input.age,
                input.sexType,
                input.height,
                input.weight
            ) { (age: (row: Int, component: Int),
                 sex: Int,
                 height: Float,
                 weight: Float) -> RohrerIndex? in

                //Indexの場合にどのPersonを作るか
                guard let person = personProfileService
                        .profiledPerson(height: height,
                                        weight: weight,
                                        age: age.row,
                                        sex: Person.SexType(rawValue: sex)
                        ) else {
                            return nil
                        }
                        
                let obesityIndex = personProfileService.calculateRohrerIndex(in: person)
                return obesityIndex
            }
        
        self.bmiObservable = bmiObservable
        self.obesityIndexObservable = obesityIndexObservable
        self.rohrerIndexObservable = rohrelIndexObservable
    }
}
