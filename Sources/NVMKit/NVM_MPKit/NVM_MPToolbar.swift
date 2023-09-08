//
//  NVM_MPToolbar.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import SwiftUI

public struct NVM_MPToolbarButton: ToolbarContent {
    private let type: ButtonType
    private let color: Color?
    private let renderingMode: SymbolRenderingMode?
    private let placement: ToolbarItemPlacement
    private let visible: Bool
    private let disabled: Bool
    private let action: (() -> Void)
    
    public init(_ type: ButtonType,
                color: Color? = nil,
                renderingMode: SymbolRenderingMode? = nil,
                placement: ToolbarItemPlacement = .automatic,
                visible: Bool = true,
                disabled: Bool = false,
                action: @escaping (() -> Void)) {
        self.type = type
        self.color = color
        self.renderingMode = renderingMode
        self.placement = placement
        self.visible = visible
        self.disabled = disabled
        self.action = action
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            if visible {
                switch type {
                case .done:
                    Button("Done") {
                        action()
                    }
                    .disabled(disabled)
                case .save:
                    Button("Save") {
                        action()
                    }
                    .disabled(disabled)
                case .text(let textName):
                    Button(textName) {
                        action()
                    }
                    .disabled(disabled)
                default:
                    Button {
                        action()
                    } label: {
                        if let systemImage = type.systemImage {
                            Image(systemName: systemImage)
                                .foregroundColor(buttonColor)
                                .symbolRenderingMode(buttonRenderingMode)
                        }
                    }
                    .disabled(disabled)
                }
            }
        }
    }
    
    private var buttonColor: Color {
        if let color {
            return color
        } else {
            switch self.type {
            case .add:
                return .secondary
            case .close:
                return .secondary
            default:
                return .primary
            }
        }
    }
    
    private var buttonRenderingMode: SymbolRenderingMode {
        if let renderingMode {
            return renderingMode
        } else {
            switch self.type {
            case .add:
                return .hierarchical
            case .close:
                return .hierarchical
            default:
                return .monochrome
            }
        }
    }
    
    public enum ButtonType {
        case add
        case close
        case done
        case save
        
        case image(String)
        case text(String)
    }
}

fileprivate extension NVM_MPToolbarButton.ButtonType {
    
    var systemImage: String? {
        switch self {
        case .add:
            return "plus.circle.fill"
        case .close:
            return "xmark.circle.fill"
        case .done:
            return nil
        case .save:
            return nil
            
        case .image(let imageName):
            return imageName
        case .text(_):
            return nil
        }
    }
}
