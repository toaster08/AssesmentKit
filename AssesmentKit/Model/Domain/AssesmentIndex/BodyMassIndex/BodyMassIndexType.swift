//
//  BodyMassIndexClass.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/08/17.
//

import Foundation

enum BodyMassIndexType {
    case underweight
    case normalRange
    case preObese
    case obeseClassⅠ
    case obeseClassⅡ
    case obeseClassⅢ
    case none

    var description: String {
        switch self {
        case .underweight: return "低体重"
        case .normalRange: return "標準"
        case .preObese: return "肥満（１度）"
        case .obeseClassⅠ: return "肥満（２度）"
        case .obeseClassⅡ: return "肥満（３度）"
        case .obeseClassⅢ: return "肥満（4度）"
        case .none: return "範囲外"
        }
    }
    
    init(bmi: BMI) {
        self = .none //これはいいの？
        let group = self.classifyType(for: bmi)
        self = group
    }
    
    func classifyType(for bmi: BMI) -> Self {
        switch bmi.value {
        case 40.0...: return .obeseClassⅢ
        case 35.0..<40.0: return .obeseClassⅡ
        case 30.0..<35.0: return .obeseClassⅠ
        case 25.0..<30.0: return .preObese
        case 18.5..<25.0: return .normalRange
        case ..<18.5: return .underweight
        default: return .none
        }
    }
}
