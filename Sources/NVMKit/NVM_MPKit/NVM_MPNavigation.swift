//
//  NVM_MPNavigation.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

// MARK: - NVM_MPNavigationView
/**
 Wrap your content in a NavigationView if needed.
 */
public struct NVM_MPNavigationStack<Content : View> : View {
    let content: Content
    let navigation: Bool
    
    @Binding private var path: Data?
    
    /**
     - parameter navigation: Can be used to make the NaviagtionStack variable based on a parameter.
     */
    public init(_ navigation: Bool = true, path: Binding<Data?> = .constant(nil), @ViewBuilder content: () -> Content) {
        self.navigation = navigation
        self._path = path
        
        self.content = content()
    }
    
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *), navigation {
            if path != nil {
                NavigationStack(path: Binding($path)!) {
                    content
                }
            } else {
                NavigationStack {
                    content
                }
            }
        } else if !NVMmacOS, navigation {
            NavigationView {
                content
            }
        } else {
            content
        }
    }
}

/**
 Wrap your content in a NavigationView if needed.
 */
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
public struct NVM_MPNavigationStackLink<Content : View> : View {
    let content: Content
    let navigation: Bool
    
    @Binding private var path: NavigationPath?
    
    /**
     - parameter navigation: Can be used to make the NaviagtionStack variable based on a parameter.
     */
    public init(_ navigation: Bool = true, path: Binding<NavigationPath?> = .constant(nil), @ViewBuilder content: () -> Content) {
        self.navigation = navigation
        self._path = path
        
        self.content = content()
    }
    
    public var body: some View {
        if path != nil {
            NavigationStack(path: Binding($path)!) {
                content
            }
        } else {
            NavigationStack {
                content
            }
        }
    }
}

// MARK: - NVM_MPNavigationLink
/**
 Use this to create a button that will show a popup on macOS, or show a detail on iOS.
 
 - note: Use this in combination with `NVM_MPNavigationView`
 */
public struct NVM_MPNavigationLink<Label, Destination> : View where Label : View, Destination : View {
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
        if !NVMmacOS {
            NavigationLink {
                self.destination
            } label: {
                self.label
            }
        } else if #available(macOS 13.0, *) {
            NavigationLink {
                self.destination
            } label: {
                HStack {
                    self.label
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.system(size: 15))
                }
            }
        } else {
            Button {
                self.showSheet = true
            } label: {
                HStack {
                    self.label
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.system(size: 15))
                }
            }
            .nvm_mpButtonStyle(.plain)
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
                        NVM_MPToolbarButton(.done, placement: .cancellationAction) {
                            self.showSheet = false
                        }
                    }
            }
        }
    }
}
