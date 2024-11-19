//
//  AppController.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/2/24.
//

import Foundation
import SwiftUI

let isIphone16ProMaxPortrait: Bool = UIScreen.main.bounds.height == 956.0

class AppViewController: ObservableObject {
    @Published var loggedIn: Bool = false
    @Published var viewSignUpFlag: Bool = false
}
