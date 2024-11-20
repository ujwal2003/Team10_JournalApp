//
//  SignInViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/20/24.
//

import Foundation

@MainActor
class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}
