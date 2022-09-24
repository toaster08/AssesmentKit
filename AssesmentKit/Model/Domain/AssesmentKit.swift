//
//  AssesmentKit.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/08/17.
//

import Foundation
import UIKit

enum AssesmentKit: Int, CaseIterable {
    case bodyMassIndex
    case rohrerIndex
    case obesityIndex
//    case waist_hipRatio
//    case NPC_NRatio
//    case weightCompensationFormula
//    case estimatedHeight
//    case harris_BenedictEquation
//    case reeForCOPD
//    case prognosticNutritionalIndex
    case fromNowOn
    
    var title: String {
        switch self {
        case .bodyMassIndex: return "BMI"
        case .rohrerIndex: return "ローレル指数"
        case .obesityIndex: return "肥満度"
//        case .waist_hipRatio: return "W/H比"
//        case .NPC_NRatio: return "NPC/N比"
//        case .weightCompensationFormula: return "体重補正式"
//        case .estimatedHeight: return "身長予測式"
//        case .harris_BenedictEquation: return "ハリベネ"
//        case .reeForCOPD: return "COPD時REE"
//        case .prognosticNutritionalIndex: return "PNI"
        
        case .fromNowOn: return "追加予定"
        }
    }
    
    var color: UIColor {
        switch self {
        case .bodyMassIndex:
            return UIColor(red: 0/255, green: 100/255, blue: 100/255, alpha: 0.7)
        case .rohrerIndex:
            return UIColor(red: 0/255, green: 110/255, blue: 110/255, alpha: 0.7)
        case .obesityIndex:
            return UIColor(red: 0/255, green: 120/255, blue: 120/255, alpha: 0.7)
//        case .waist_hipRatio:
//            return UIColor(red: 0/255, green: 120/255, blue: 120/255, alpha: 0.7)
//        case .NPC_NRatio:
//            return UIColor(red: 0/255, green: 130/255, blue: 130/255, alpha: 0.7)
//        case .weightCompensationFormula:
//            return UIColor(red: 0/255, green: 140/255, blue: 140/255, alpha: 0.7)
//        case .estimatedHeight:
//            return UIColor(red: 0/255, green: 150/255, blue: 150/255, alpha: 0.7)
//        case .harris_BenedictEquation:
//            return UIColor(red: 0/255, green: 160/255, blue: 160/255, alpha: 0.7)
//        case .reeForCOPD:
//            return UIColor(red: 0/255, green: 170/255, blue: 170/255, alpha: 0.7)
//        case .prognosticNutritionalIndex:
//            return UIColor(red: 0/255, green: 180/255, blue: 180/255, alpha: 0.7)
        case .fromNowOn: return .lightGray
        }
    }
}
