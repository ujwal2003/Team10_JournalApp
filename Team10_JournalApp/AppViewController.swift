//
//  AppController.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/2/24.
//

import Foundation

class AppViewController: ObservableObject {
    @Published var loggedIn: Bool = true
    @Published var viewSignUpFlag: Bool = false
}
