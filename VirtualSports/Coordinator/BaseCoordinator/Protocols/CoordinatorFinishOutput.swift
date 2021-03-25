//
//  CoordinatorFinishOutput.swift
//  VirtualSports
//
//  Created by Вова Благой on 21.03.2021.
//

import Foundation

protocol CoordinatorFinishOutput {
    var finishFlow: (() -> Void)? { get set }
}
