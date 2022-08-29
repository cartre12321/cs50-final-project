//
//  PatternDetailViewModel.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-08-08.
//

import Foundation

final class PatternDetailViewModel: ObservableObject {
    
    enum Mode {
        case view
        case edit
    }
    
    @Published var mode: Mode
    @Published var pattern: KnittingPattern
    
    init(_ pattern: KnittingPattern, mode: Mode) {
        self.pattern = pattern
        self.mode = mode
    }
}
