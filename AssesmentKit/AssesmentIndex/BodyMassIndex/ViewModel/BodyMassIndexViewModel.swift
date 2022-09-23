//
//  BodyMassIndexViewModel.swift
//  AssesmentKit
//
//  Created by 山田　天星 on 2022/09/23.
//

import Foundation
import RxSwift

struct BodyMassIndexViewModel {
    
    let weight: Observable<Float>
    let height: Observable<Float>
    let sexType: Observable<Int>
    let age: Observable<(row: Int, component: Int)>
}
