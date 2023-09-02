//
//  NVM_MPPopupButton.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

// MARK: - NVM_MPPopupButton
/**
 Use this to create a button that will show a popup on macOS, or show a detail on iOS.
 
 - note: Use this in combination with `NVM_MPNavigationView`
 */
public struct NVM_MPPopupButton<Label, Destination> : View where Label : View, Destination : View {
    let label: Label
    let destination: Destination
    let frame: NVM_MPFrame?
    
    @State private var showSheet: Bool = false
    
    public init(destination: Destination, frame: NVM_MPFrame? = nil, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.destination = destination
        self.frame = frame
    }
    
    public var body: some View {
        if NVMmacOS {
            Button {
                self.showSheet = true
            } label: {
                self.label
            }
            .offset(x: 0.5)
            .sheet(isPresented: $showSheet) {
                self.destination
                    .nvm_mpFrame(minWidth: frame?.minWidth ?? 150,
                              idealWidth: frame?.idealWidth ?? 300,
                              maxWidth: frame?.maxWidth ?? .infinity,
                              
                              minHeight: frame?.minHeight ?? 200,
                              idealHeight: frame?.idealHeight ?? 400,
                              maxHeight: frame?.maxHeight ?? 800)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(showSheet ? "Done" : "") {
                                self.showSheet = false
                            }
                        }
                    }
            }
        } else {
            NavigationLink {
                self.destination
            } label: {
                self.label
            }
        }
    }
}
