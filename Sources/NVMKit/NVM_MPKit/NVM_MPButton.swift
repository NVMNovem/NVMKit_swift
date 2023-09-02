//
//  NVM_MPButton.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

// MARK: - NVM_MPButton
public struct NVM_MPButton<Label : View>: View {
    let label: Label
    let action: () -> Void
    let longPressAction: (() -> Void)?
    let longPress: Bool
    
    @State private var didLongPress = false
    @State private var didShortPress = false

    public init(action: @escaping () -> Void, longPressAction: (() -> Void)? = nil, longPress: Bool = true, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.action = action
        self.longPressAction = longPressAction
        self.longPress = longPress
    }

    public var body: some View {
        if let longPressAction = longPressAction, longPress {
            Button {
                if didLongPress {
                    self.didLongPress = false
                    self.didShortPress = false
                } else {
                    action()
                }
            } label: {
                label
            }
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                self.didLongPress = true
                self.didShortPress = false
                
                longPressAction()
            })
            /*.simultaneousGesture(TapGesture().onEnded {
                if !editingList.isEditing {
                    self.didLongPress = false
                    self.didShortPress = true
                    self.selectionAction()
                }
            })*/
        } else {
            Button {
                action()
            } label: {
                label
            }
        }
    }
}
