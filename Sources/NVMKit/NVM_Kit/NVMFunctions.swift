//
//  NVMFunctions.swift
//
//
//  Created by Damian Van de Kauter on 2/09/2023.
//

import Foundation
import LocalAuthentication
#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public func canAuthenticateByFaceID() -> Bool {
    #if os(tvOS)
    return false
    #elseif os(watchOS)
    return false
    #else
    let laContext = LAContext()
    var laError: NSError?
    
    if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &laError) {
        if laContext.biometryType == .faceID {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
    #endif
}
public func canAuthenticateByTouchID() -> Bool {
    #if os(tvOS)
    return false
    #elseif os(watchOS)
    return false
    #else
    let laContext = LAContext()
    var laError: NSError?

    if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &laError) {
        if laContext.biometryType == .touchID {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
    #endif
}
public func bioIDImageName() -> String {
    if canAuthenticateByFaceID() {
        return "faceid"
    } else if canAuthenticateByTouchID() {
        return "touchid"
    } else {
        return ""
    }
}
public func bioIDName() -> String {
    if canAuthenticateByFaceID() {
        return "Face ID"
    } else if canAuthenticateByTouchID() {
        return "Touch ID"
    } else {
        return "Face ID (not enabled)"
    }
}

public func nvmAppIsActive() -> Bool {
#if os(macOS)
    return NSApplication.shared.isActive
#elseif os(watchOS)
    return true
#else
    #if EXTENSION
        return true
    #else
        let state = UIApplication.shared.applicationState
        if state == .active {
            return true
        } else {
            return false
        }
    #endif
#endif
}

public var NVMextension: Bool {
#if EXTENSION
    return true
#else
    return false
#endif
}

public var NVMiOS: Bool {
#if os(iOS)
    return UIDevice.current.userInterfaceIdiom != .pad
#else
    return false
#endif
}

public var NVMipadOS: Bool {
#if os(iOS)
    return UIDevice.current.userInterfaceIdiom == .pad
#else
    return false
#endif
}

public var NVMmacOS: Bool {
#if os(macOS)
    return true
#else
    return false
#endif
}

public var NVMtvOS: Bool {
#if os(tvOS)
    return true
#else
    return false
#endif
}

public var NVMwatchOS: Bool {
#if os(watchOS)
    return true
#else
    return false
#endif
}
