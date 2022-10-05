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
    
    let bmiText: Observable<String>
    let bmiTextFont: Observable<UIFont>
    let bmiEvaluationText: Observable<String>

    let obesityIndexText: Observable<String>
    let obesityIndexTextFont: Observable<UIFont>
    let obesityIndexEvaluationText: Observable<String>

    let rohrerIndexText: Observable<String>
    let rohrerIndexTextFont: Observable<UIFont>
    let rohrerIndexEvaluationText: Observable<String>

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
        
        self.bmiText = bmiObservable
            .map({ bmi in
                if bmi?.value != nil {
                    return String(format: "%.1f", bmi!.value)
                } else {
                    return "計算不可"
                }
                
            }).asObservable()
        
        self.bmiTextFont = bmiObservable
            .map({ bmi in
                let size = bmi?.value != nil ? 35 : 20
                return UIFont(name: "Helvetica", size: CGFloat(size))!
            }).asObservable()
        
        self.bmiEvaluationText = bmiObservable
            .map({ bmi in
                guard  let type = bmi?.evaluatedType.description else {
                    return ""
                }
                return "現在のBMIの評価は\(type)です"
            }).asObservable()
        
        self.obesityIndexText = obesityIndexObservable
            .map({ index in
                if index?.value != nil {
                    return String(format: "%.f", index!.value)
                } else {
                    return "計算不可"
                }
                
            }).asObservable()
        
        self.obesityIndexTextFont = obesityIndexObservable
            .map({ index in
                let size = index?.value != nil ? 35 : 20
                return UIFont(name: "Helvetica", size: CGFloat(size))!
            }).asObservable()
        
        self.obesityIndexEvaluationText = obesityIndexObservable
            .map({ index in
                guard  let type = index?.evaluatedType.description else {
                    return ""
                }
                return "現在の肥満度の評価は\(type)です"
            }).asObservable()
        
        self.rohrerIndexText = rohrelIndexObservable
            .map({ index in
                if index?.value != nil {
                    return String(format: "%.f", index!.value)
                } else {
                    return "計算不可"
                }
                
            }).asObservable()
        
        self.rohrerIndexTextFont = rohrelIndexObservable
            .map({ index in
                let size = index?.value != nil ? 35 : 20
                return UIFont(name: "Helvetica", size: CGFloat(size))!
            }).asObservable()
        
        self.rohrerIndexEvaluationText = rohrelIndexObservable
            .map({ index in
                guard  let type = index?.evaluatedType.description else {
                    return ""
                }
                return "現在のローレル指数の評価は\(type)です"
            }).asObservable()
    }
}
