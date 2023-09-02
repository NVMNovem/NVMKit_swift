//
//  NVM_MPFrame.swift
//  
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

public struct NVM_MPFrame {
    public var minWidth: CGFloat? = nil
    public var idealWidth: CGFloat? = nil
    public var maxWidth: CGFloat? = nil
    
    public var minHeight: CGFloat? = nil
    public var idealHeight: CGFloat? = nil
    public var maxHeight: CGFloat? = nil
    
    public init(minWidth: CGFloat? = nil,
                idealWidth: CGFloat? = nil,
                maxWidth: CGFloat? = nil,
                
                minHeight: CGFloat? = nil,
                idealHeight: CGFloat? = nil,
                maxHeight: CGFloat? = nil) {
        self.minWidth = minWidth
        self.idealWidth = idealWidth
        self.maxWidth = maxWidth
        
        self.minHeight = minHeight
        self.idealHeight = idealHeight
        self.maxHeight = maxHeight
    }
}

/**
 Adjust window sizes on screens where it is appropriate to adjust the size.
 */
fileprivate struct NVM_MPFrameModifier: ViewModifier {
    private var minWidth: CGFloat?
    private var idealWidth: CGFloat?
    private var maxWidth: CGFloat?
    
    private var minHeight: CGFloat?
    private var idealHeight: CGFloat?
    private var maxHeight: CGFloat?
    
    private let platforms: [NVMOSPlatform]
    
    init(minWidth: CGFloat?,
         idealWidth: CGFloat?,
         maxWidth: CGFloat?,
         minHeight: CGFloat?,
         idealHeight: CGFloat?,
         maxHeight: CGFloat?) {
        self.minWidth = minWidth
        self.idealWidth = idealWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.idealHeight = idealHeight
        self.maxHeight = maxHeight
        
        self.platforms = NVMOSPlatform.allCases
    }
    
    init(minWidth: CGFloat?,
         idealWidth: CGFloat?,
         maxWidth: CGFloat?,
         minHeight: CGFloat?,
         idealHeight: CGFloat?,
         maxHeight: CGFloat?,
         platforms: [NVMOSPlatform]) {
        self.minWidth = minWidth
        self.idealWidth = idealWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.idealHeight = idealHeight
        self.maxHeight = maxHeight
        
        self.platforms = platforms
    }
    
    init(minWidth: CGFloat?,
         idealWidth: CGFloat?,
         maxWidth: CGFloat?,
         minHeight: CGFloat?,
         idealHeight: CGFloat?,
         maxHeight: CGFloat?,
         skip platforms: [NVMOSPlatform]) {
        self.minWidth = minWidth
        self.idealWidth = idealWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.idealHeight = idealHeight
        self.maxHeight = maxHeight
        
        var allPlatforms = NVMOSPlatform.allCases
        allPlatforms.removeAll(where: { platforms.contains($0) })
        self.platforms = allPlatforms
    }
    
    func body(content: Content) -> some View {
        #if os(iOS)
        if platforms.contains(.iOS) || (platforms.contains(.iPadOS) &&
                                        UIDevice.current.userInterfaceIdiom == .pad ) {
            content
                .frame(minWidth: minWidth,
                       idealWidth: idealWidth,
                       maxWidth: maxWidth,
                       
                       minHeight: minHeight,
                       idealHeight: idealHeight,
                       maxHeight: maxHeight)
        } else {
            content
        }
        #endif
        #if os(macOS)
        if platforms.contains(.macOS) {
            content
                .frame(minWidth: minWidth,
                       idealWidth: idealWidth,
                       maxWidth: maxWidth,
                       
                       minHeight: minHeight,
                       idealHeight: idealHeight,
                       maxHeight: maxHeight)
        } else {
            content
        }
        #endif
        #if os(watchOS)
        if platforms.contains(.watchOS) {
            content
                .frame(minWidth: minWidth,
                       idealWidth: idealWidth,
                       maxWidth: maxWidth,
                       
                       minHeight: minHeight,
                       idealHeight: idealHeight,
                       maxHeight: maxHeight)
        } else {
            content
        }
        #endif
        #if os(tvOS)
        if platforms.contains(.tvOS) {
            content
                .frame(minWidth: minWidth,
                       idealWidth: idealWidth,
                       maxWidth: maxWidth,
                       
                       minHeight: minHeight,
                       idealHeight: idealHeight,
                       maxHeight: maxHeight)
        } else {
            content
        }
        #endif
    }
}
public extension View {
    
    func nvm_mpFrame(minWidth: CGFloat? = nil,
                     idealWidth: CGFloat? = nil,
                     maxWidth: CGFloat? = nil,
                     
                     minHeight: CGFloat? = nil,
                     idealHeight: CGFloat? = nil,
                     maxHeight: CGFloat? = nil) -> some View {
        self.modifier(NVM_MPFrameModifier(minWidth: minWidth,
                                          idealWidth: idealWidth,
                                          maxWidth: maxWidth,
                                          
                                          minHeight: minHeight,
                                          idealHeight: idealHeight,
                                          maxHeight: maxHeight))
    }
    
    func nvm_mpFrame(_ frame: NVM_MPFrame) -> some View {
        self.modifier(NVM_MPFrameModifier(minWidth: frame.minWidth,
                                          idealWidth: frame.idealWidth,
                                          maxWidth: frame.maxWidth,
                                          
                                          minHeight: frame.minHeight,
                                          idealHeight: frame.idealHeight,
                                          maxHeight: frame.maxHeight))
    }
    
    func nvm_mpFrame(minWidth: CGFloat? = nil,
                     idealWidth: CGFloat? = nil,
                     maxWidth: CGFloat? = nil,
                     
                     minHeight: CGFloat? = nil,
                     idealHeight: CGFloat? = nil,
                     maxHeight: CGFloat? = nil,
                     
                     platforms: [NVMOSPlatform]) -> some View {
        self.modifier(NVM_MPFrameModifier(minWidth: minWidth,
                                          idealWidth: idealWidth,
                                          maxWidth: maxWidth,
                                          
                                          minHeight: minHeight,
                                          idealHeight: idealHeight,
                                          maxHeight: maxHeight,
                                          platforms: platforms))
    }
    
    func nvm_mpFrame(_ frame: NVM_MPFrame, platforms: [NVMOSPlatform]) -> some View {
        self.modifier(NVM_MPFrameModifier(minWidth: frame.minWidth,
                                          idealWidth: frame.idealWidth,
                                          maxWidth: frame.maxWidth,
                                          
                                          minHeight: frame.minHeight,
                                          idealHeight: frame.idealHeight,
                                          maxHeight: frame.maxHeight,
                                          platforms: platforms))
    }
    
    func nvm_mpFrame(minWidth: CGFloat? = nil,
                     idealWidth: CGFloat? = nil,
                     maxWidth: CGFloat? = nil,
                     
                     minHeight: CGFloat? = nil,
                     idealHeight: CGFloat? = nil,
                     maxHeight: CGFloat? = nil,
                     
                     skip platforms: [NVMOSPlatform]) -> some View {
        self.modifier(NVM_MPFrameModifier(minWidth: minWidth,
                                          idealWidth: idealWidth,
                                          maxWidth: maxWidth,
                                          
                                          minHeight: minHeight,
                                          idealHeight: idealHeight,
                                          maxHeight: maxHeight,
                                          skip: platforms))
    }
    
    func nvm_mpFrame(_ frame: NVM_MPFrame, skip platforms: [NVMOSPlatform]) -> some View {
        self.modifier(NVM_MPFrameModifier(minWidth: frame.minWidth,
                                          idealWidth: frame.idealWidth,
                                          maxWidth: frame.maxWidth,
                                          
                                          minHeight: frame.minHeight,
                                          idealHeight: frame.idealHeight,
                                          maxHeight: frame.maxHeight,
                                          skip: platforms))
    }
}

extension NVM_MPFrame {
    
    internal static var settings: Self {
        return NVM_MPFrame(minWidth: 400,
                           idealWidth: 600,
                           maxWidth: 1200,
                           
                           minHeight: 200,
                           idealHeight: 400,
                           maxHeight: .infinity)
    }
}
