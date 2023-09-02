//
//  NVM_MPPickerStyle.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

// MARK: - NVM_MPPickerStyle
public struct NVM_MPPickerStyle: ViewModifier {
    private let style: NVMPickerStyle
    private let platforms: [NVMOSPlatform]
    private let fallBack: NVMPickerStyle?
    
    public init(_ style: NVMPickerStyle, fallBack: NVMPickerStyle?) {
        self.style = style
        self.fallBack = fallBack
        
        self.platforms = NVMOSPlatform.allCases
    }
    
    public init(_ style: NVMPickerStyle, fallBack: NVMPickerStyle?, platforms: [NVMOSPlatform]) {
        self.style = style
        self.fallBack = fallBack
        
        self.platforms = platforms
    }
    
    public init(_ style: NVMPickerStyle, fallBack: NVMPickerStyle?, skip platforms: [NVMOSPlatform]) {
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
            content.pickerStyle(.automatic)
        case .inline:
            content.pickerStyle(.inline)
        case .menu:
            #if os(iOS)
            content.pickerStyle(.menu)
            #elseif os(macOS)
            content.pickerStyle(.menu)
            #else
            fallBackView(content: content)
            #endif
        case .navigationLink:
            #if os(iOS)
            if #available(iOS 16.0, *) {
                content.pickerStyle(.navigationLink)
            } else {
                content
            }
            #elseif os(watchOS)
            if #available(watchOS 9.0, *) {
                content.pickerStyle(.navigationLink)
            } else {
                content
            }
            #elseif os(tvOS)
            if #available(tvOS 16.0, *) {
                content.pickerStyle(.navigationLink)
            } else {
                content
            }
            #else
            fallBackView(content: content)
            #endif
        case .segmented:
            #if os(iOS)
            content.pickerStyle(.segmented)
            #elseif os(macOS)
            content.pickerStyle(.segmented)
            #elseif os(tvOS)
            content.pickerStyle(.segmented)
            #else
            fallBackView(content: content)
            #endif
        case .wheel:
            #if os(iOS)
            content.pickerStyle(.wheel)
            #elseif os(watchOS)
            content.pickerStyle(.wheel)
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
                    content.pickerStyle(.automatic)
                case .inline:
                    content.pickerStyle(.inline)
                case .menu:
                    #if os(iOS)
                    content.pickerStyle(.menu)
                    #elseif os(macOS)
                    content.pickerStyle(.menu)
                    #else
                    content
                    #endif
                case .navigationLink:
                    #if os(iOS)
                    if #available(iOS 16.0, *) {
                        content.pickerStyle(.navigationLink)
                    } else {
                        content
                    }
                    #elseif os(watchOS)
                    if #available(watchOS 9.0, *) {
                        content.pickerStyle(.navigationLink)
                    } else {
                        content
                    }
                    #elseif os(tvOS)
                    if #available(tvOS 16.0, *) {
                        content.pickerStyle(.navigationLink)
                    } else {
                        content
                    }
                    #else
                    content
                    #endif
                case .segmented:
                    #if os(iOS)
                    content.pickerStyle(.segmented)
                    #elseif os(macOS)
                    content.pickerStyle(.segmented)
                    #elseif os(tvOS)
                    content.pickerStyle(.segmented)
                    #else
                    content
                    #endif
                case .wheel:
                    #if os(iOS)
                    content.pickerStyle(.wheel)
                    #elseif os(watchOS)
                    content.pickerStyle(.wheel)
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
    
    func nvm_mpPickerStyle(_ style: NVMPickerStyle, fallBack: NVMPickerStyle? = nil) -> some View {
        self.modifier(NVM_MPPickerStyle(style, fallBack: fallBack))
    }
    
    func nvm_mpPickerStyle(_ style: NVMPickerStyle, fallBack: NVMPickerStyle? = nil, platforms: NVMOSPlatform...) -> some View {
        self.modifier(NVM_MPPickerStyle(style, fallBack: fallBack, platforms: platforms))
    }
    
    func nvm_mpPickerStyle(_ style: NVMPickerStyle, fallBack: NVMPickerStyle? = nil, skip platforms: NVMOSPlatform...) -> some View {
        self.modifier(NVM_MPPickerStyle(style, fallBack: fallBack, skip: platforms))
    }
}

public enum NVMPickerStyle {
    case automatic
    case inline
    case menu
    case navigationLink
    case segmented
    case wheel
}
