//
//  NVM_MPTextFieldStyle.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

// MARK: - NVM_MPTextFieldStyle
public struct NVM_MPTextFieldStyle: ViewModifier {
    private let style: NVMTextFieldStyle
    private let platforms: [NVMOSPlatform]
    private let fallBack: NVMTextFieldStyle?
    
    public init(_ style: NVMTextFieldStyle, fallBack: NVMTextFieldStyle?) {
        self.style = style
        self.fallBack = fallBack
        
        self.platforms = NVMOSPlatform.allCases
    }
    
    public init(_ style: NVMTextFieldStyle, fallBack: NVMTextFieldStyle?, platforms: [NVMOSPlatform]) {
        self.style = style
        self.fallBack = fallBack
        
        self.platforms = platforms
    }
    
    public init(_ style: NVMTextFieldStyle, fallBack: NVMTextFieldStyle?, skip platforms: [NVMOSPlatform]) {
        self.style = style
        self.fallBack = fallBack
        
        var allPlatforms = NVMOSPlatform.allCases
        allPlatforms.removeAll(where: { platforms.contains($0) })
        self.platforms = allPlatforms
    }
    
    public func body(content: Content) -> some View {
        #if os(iOS)
        if platforms.contains(.iOS) || (platforms.contains(.iPadOS) &&
                                        UIDevice.current.userInterfaceIdiom == .pad ) {
            contentView(content: content)
        } else {
            content
        }
        #endif
        #if os(macOS)
        if platforms.contains(.macOS) {
            contentView(content: content)
        } else {
            content
        }
        #endif
        #if os(watchOS)
        if platforms.contains(.watchOS) {
            contentView(content: content)
        } else {
            content
        }
        #endif
        #if os(tvOS)
        if platforms.contains(.tvOS) {
            contentView(content: content)
        } else {
            content
        }
        #endif
    }
    
    @ViewBuilder
    private func contentView(content: Content) -> some View {
        switch style {
        case .automatic:
            content.textFieldStyle(.automatic)
        case .roundedBorder:
            #if os(iOS)
            content.textFieldStyle(.roundedBorder)
            #elseif os(macOS)
            content.textFieldStyle(.roundedBorder)
            #else
            content
            #endif
        case .plain:
            content.textFieldStyle(.plain)
        }
    }
    
    @ViewBuilder
    private func fallBackView(content: Content) -> some View {
        if let fallBack {
            if style == fallBack {
                content
            } else {
                switch fallBack {
                case .automatic:
                    content.textFieldStyle(.automatic)
                case .roundedBorder:
                    #if os(iOS)
                    content.textFieldStyle(.roundedBorder)
                    #elseif os(macOS)
                    content.textFieldStyle(.roundedBorder)
                    #else
                    content
                    #endif
                case .plain:
                    content.textFieldStyle(.plain)
                }
            }
        } else {
            content
        }
    }
}
public extension View {
    
    func nvm_mpTextFieldStyle(_ style: NVMTextFieldStyle, fallBack: NVMTextFieldStyle? = nil) -> some View {
        self.modifier(NVM_MPTextFieldStyle(style, fallBack: fallBack))
    }
    
    func nvm_mpTextFieldStyle(_ style: NVMTextFieldStyle, fallBack: NVMTextFieldStyle? = nil, platforms: NVMOSPlatform...) -> some View {
        self.modifier(NVM_MPTextFieldStyle(style, fallBack: fallBack, platforms: platforms))
    }
    
    func nvm_mpTextFieldStyle(_ style: NVMTextFieldStyle, fallBack: NVMTextFieldStyle? = nil, skip platforms: NVMOSPlatform...) -> some View {
        self.modifier(NVM_MPTextFieldStyle(style, fallBack: fallBack, skip: platforms))
    }
}

public enum NVMTextFieldStyle {
    case automatic
    case roundedBorder
    case plain
}
