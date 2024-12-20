//
//  DeviceOrientation.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/19/24.
//
//  Size Classes Source: https://developer.apple.com/design/human-interface-guidelines/layout#iOS-iPadOS-device-size-classes

import Foundation
import SwiftUI

enum IOSDevice {
    case iPhone; case iPhonePlusOrMax; case iPadFull
}

struct DeviceOrientation {
    var widthSizeClass: UserInterfaceSizeClass?
    var heightSizeClass: UserInterfaceSizeClass?
    
    func isPortrait(device: IOSDevice) -> Bool {
        switch device {
        case IOSDevice.iPadFull:
            return widthSizeClass == .regular && heightSizeClass == .regular
            
        case IOSDevice.iPhone:
            return self.widthSizeClass == .compact && heightSizeClass == .regular
            
        case IOSDevice.iPhonePlusOrMax:
            return widthSizeClass == .compact && heightSizeClass == .regular
        }
    }
    
    func isLandscape(device: IOSDevice) -> Bool {
        switch device {
        case IOSDevice.iPadFull:
            return widthSizeClass == .regular && heightSizeClass == .regular
            
        case IOSDevice.iPhonePlusOrMax:
            return widthSizeClass == .regular && heightSizeClass == .compact
            
        case IOSDevice.iPhone:
            return widthSizeClass == .compact && heightSizeClass == .compact
        }
    }
}
