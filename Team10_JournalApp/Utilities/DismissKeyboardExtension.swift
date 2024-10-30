//
//  DismissKeyboardExtension.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/30/24.
//

import Foundation
import SwiftUI

extension View {
    public func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resolveInstanceMethod(_:)), to: nil, from: nil, for: nil)
    }
}
