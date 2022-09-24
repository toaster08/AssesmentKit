//
//  RohrerIndexClass.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/08/17.
//

import Foundation

enum RohrerIndexType {
    case underweight
    case preUnderWeight
    case normalRange
    case preOverWeight
    case overWeight
    case none

    var description: String {
        switch self {
        case .underweight: return "やせすぎ"
        case .preUnderWeight: return "やせぎみ"
        case .normalRange: return "普通"
        case .preOverWeight: return "太りぎみ"
        case .overWeight : return "太りすぎ"
        case .none: return "範囲外"
        }
    }
    
    init(rohrerIndex: Float) {
        self = .none
        let group = self.classifyGroup(for: rohrerIndex)
        self = group
    }
    
    private func classifyGroup(for rohrerIndex: Float) -> RohrerIndexType {
        switch rohrerIndex {
        case 160...: return .overWeight
        case 145..<160: return .preOverWeight
        case 115..<145: return .normalRange
        case 100..<115: return .preUnderWeight
        case ..<100: return .underweight
        default: return .none
        }
    }
}
