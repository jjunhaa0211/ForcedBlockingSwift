//
//  BlockingModel.swift
//  ForcedBlocking
//
//  Created by 박준하 on 1/22/24.
//

import Foundation
import FamilyControls
import ManagedSettings

final class BlockingModel: ObservableObject {
    static let shared = BlockingModel()
    
    @Published var newSelection: FamilyActivitySelection = .init()
    
    var selectedAppsTokens: Set<ApplicationToken> {
        newSelection.applicationTokens
    }
}
