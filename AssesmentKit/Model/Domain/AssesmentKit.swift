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
    case fromNowOn
    
    var title: String {
        switch self {
        case .bodyMassIndex: return "BMI"
        case .rohrerIndex: return "ローレル指数"
        case .obesityIndex: return "肥満度"
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
        case .fromNowOn: return .lightGray
        }
    }
}
