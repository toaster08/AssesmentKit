//
//  ObesityIndexClass.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/08/17.
//

import Foundation

enum ObesityIndexType {
    case severeObesity
    case moderateObesity
    case mildObesity
    case normalRange
    case none

    var description: String {
        switch self {
        case .severeObesity: return "高度肥満"
        case .moderateObesity: return "中等度肥満"
        case .mildObesity: return "軽度肥満"
        case .normalRange: return "普通"
        case .none: return "範囲外"
        }
    }
    
    init(obesityIndex: Float) {
        self = .none
        let group = self.classifyGroup(for: obesityIndex)
        self = group
    }
    
    private func classifyGroup(for obesityIndex: Float) -> ObesityIndexType {
        switch obesityIndex {
        case 50...: return .severeObesity
        case 30..<50: return .moderateObesity
        case 20..<30: return .mildObesity
        case -20..<20: return .normalRange
        default: return .none
        }
    }
}
