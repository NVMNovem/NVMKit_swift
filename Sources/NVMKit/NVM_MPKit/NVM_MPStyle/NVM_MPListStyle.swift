//
//  NVM_MPListStyle.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

// MARK: - NVM_MPListStyle
public struct NVM_MPListStyle: ViewModifier {
    private let style: NVMListStyle
    private let platforms: [NVMOSPlatform]
    private let fallBack: NVMListStyle?
    
    public init(_ style: NVMListStyle, fallBack: NVMListStyle?) {
        self.style = style
        self.fallBack = fallBack
        
        self.platforms = NVMOSPlatform.allCases
    }
    
    public init(_ style: NVMListStyle, fallBack: NVMListStyle?, platforms: [NVMOSPlatform]) {
        self.style = style
        self.fallBack = fallBack
        
        self.platforms = platforms
    }
    
    public init(_ style: NVMListStyle, fallBack: NVMListStyle?, skip platforms: [NVMOSPlatform]) {
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
            content.listStyle(.automatic)
        case .grouped:
            #if os(iOS)
            content.listStyle(.grouped)
            #elseif os(tvOS)
            content.listStyle(.grouped)
            #else
            fallBackView(content: content)
            #endif
        case .inset:
            #if os(iOS)
            content.listStyle(.inset)
            #elseif os(tvOS)
            content.listStyle(.inset)
            #else
            fallBackView(content: content)
            #endif
        case .insetGrouped:
            #if os(iOS)
            content.listStyle(.insetGrouped)
            #elseif os(tvOS)
            content.listStyle(.insetGrouped)
            #else
            fallBackView(content: content)
            #endif
        case .plain:
            content.listStyle(.plain)
        case .sidebar:
            #if os(iOS)
            content.listStyle(.sidebar)
            #elseif os(tvOS)
            content.listStyle(.sidebar)
            #else
            fallBackView(content: content)
            #endif
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
                    content.listStyle(.automatic)
                case .grouped:
                    #if os(iOS)
                    content.listStyle(.grouped)
                    #elseif os(tvOS)
                    content.listStyle(.grouped)
                    #else
                    content
                    #endif
                case .inset:
                    #if os(iOS)
                    content.listStyle(.inset)
                    #elseif os(tvOS)
                    content.listStyle(.inset)
                    #else
                    content
                    #endif
                case .insetGrouped:
                    #if os(iOS)
                    content.listStyle(.insetGrouped)
                    #elseif os(tvOS)
                    content.listStyle(.insetGrouped)
                    #else
                    content
                    #endif
                case .plain:
                    content.listStyle(.plain)
                case .sidebar:
                    #if os(iOS)
                    content.listStyle(.sidebar)
                    #elseif os(tvOS)
                    content.listStyle(.sidebar)
                    #else
                    content
                    #endif
                }
            }
        } else {
            content
        }
    }
}
public extension View {
    
    func nvm_mpListStyle(_ style: NVMListStyle, fallBack: NVMListStyle? = nil) -> some View {
        self.modifier(NVM_MPListStyle(style, fallBack: fallBack))
    }
    
    func nvm_mpListStyle(_ style: NVMListStyle, fallBack: NVMListStyle? = nil, platforms: NVMOSPlatform...) -> some View {
        self.modifier(NVM_MPListStyle(style, fallBack: fallBack, platforms: platforms))
    }
    
    func nvm_mpListStyle(_ style: NVMListStyle, fallBack: NVMListStyle? = nil, skip platforms: NVMOSPlatform...) -> some View {
        self.modifier(NVM_MPListStyle(style, fallBack: fallBack, skip: platforms))
    }
}

public enum NVMListStyle {
    case automatic
    case grouped
    case inset
    case insetGrouped
    case plain
    case sidebar
}
