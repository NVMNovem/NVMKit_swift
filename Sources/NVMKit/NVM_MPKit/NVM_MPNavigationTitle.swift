//
//  NVM_MPNavigationTitle.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

// MARK: - NVM_MPNavigationTitle
public extension View {
    
    func nvm_mpNavigationTitle(_ title: String, mode: NVM_MPTitleDisplayMode = .automatic) -> some View {
        return self
            .navigationTitle(title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(mode.displayMode)
            #endif
    }
}

public enum NVM_MPTitleDisplayMode {
    case automatic
    case inline
    case large
}
#if os(iOS)
private extension NVM_MPTitleDisplayMode {
    
    var displayMode: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .automatic:
            return NavigationBarItem.TitleDisplayMode.automatic
        case .inline:
            return NavigationBarItem.TitleDisplayMode.inline
        case .large:
            return NavigationBarItem.TitleDisplayMode.large
        }
    }
}
#endif
