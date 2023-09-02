//
//  NVM_MPButtonStyle.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

// MARK: - NVM_MPButtonStyle
public struct NVM_MPButtonStyle: ViewModifier {
    private let style: NVMButtonStyle
    private let platforms: [NVMOSPlatform]
    private let fallBack: NVMButtonStyle?
    
    public init(_ style: NVMButtonStyle, fallBack: NVMButtonStyle?) {
        self.style = style
        self.fallBack = fallBack
        
        self.platforms = NVMOSPlatform.allCases
    }
    
    public init(_ style: NVMButtonStyle, fallBack: NVMButtonStyle?, platforms: [NVMOSPlatform]) {
        self.style = style
        self.fallBack = fallBack
        
        self.platforms = platforms
    }
    
    public init(_ style: NVMButtonStyle, fallBack: NVMButtonStyle?, skip platforms: [NVMOSPlatform]) {
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
            content.buttonStyle(.automatic)
        case .bordered:
            if #available(iOS 15.0, *) {
                content.buttonStyle(.bordered)
            } else {
                fallBackView(content: content)
            }
        case .borderedProminent:
            if #available(iOS 15.0, *) {
                content.buttonStyle(.borderedProminent)
            } else {
                fallBackView(content: content)
            }
        case .borderless:
            #if os(iOS)
            content.buttonStyle(.borderless)
            #elseif os(macOS)
            content.buttonStyle(.borderless)
            #elseif os(watchOS)
            content.buttonStyle(.borderless)
            #else
            fallBackView(content: content)
            #endif
        case .card:
            #if os(tvOS)
            content.buttonStyle(.card)
            #else
            fallBackView(content: content)
            #endif
        case .plain:
            content.buttonStyle(.plain)
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
                    content.buttonStyle(.automatic)
                case .bordered:
                    if #available(iOS 15.0, *) {
                        content.buttonStyle(.bordered)
                    } else {
                        content
                    }
                case .borderedProminent:
                    if #available(iOS 15.0, *) {
                        content.buttonStyle(.borderedProminent)
                    } else {
                        content
                    }
                case .borderless:
                    #if os(iOS)
                    content.buttonStyle(.borderless)
                    #elseif os(macOS)
                    content.buttonStyle(.borderless)
                    #elseif os(watchOS)
                    content.buttonStyle(.borderless)
                    #else
                    content
                    #endif
                case .card:
                    #if os(tvOS)
                    content.buttonStyle(.automatic)
                    #else
                    content
                    #endif
                case .plain:
                    content.buttonStyle(.plain)
                }
            }
        } else {
            content
        }
    }
}
public extension View {
    
    func nvm_mpButtonStyle(_ style: NVMButtonStyle, fallBack: NVMButtonStyle? = nil) -> some View {
        self.modifier(NVM_MPButtonStyle(style, fallBack: fallBack))
    }
    
    func nvm_mpButtonStyle(_ style: NVMButtonStyle, fallBack: NVMButtonStyle? = nil, platforms: NVMOSPlatform...) -> some View {
        self.modifier(NVM_MPButtonStyle(style, fallBack: fallBack, platforms: platforms))
    }
    
    func nvm_mpButtonStyle(_ style: NVMButtonStyle, fallBack: NVMButtonStyle? = nil, skip platforms: NVMOSPlatform...) -> some View {
        self.modifier(NVM_MPButtonStyle(style, fallBack: fallBack, skip: platforms))
    }
}

public enum NVMButtonStyle {
    case automatic
    case bordered
    case borderedProminent
    case borderless
    case card
    case plain
}
