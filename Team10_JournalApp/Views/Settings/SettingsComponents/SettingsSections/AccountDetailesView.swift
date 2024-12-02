//
//  AccountDetailesView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/2/24.
//

import SwiftUI

struct AccountDetailesView: View {
    @ObservedObject var appController: AppViewController
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        Section(header:
                    Text("Account Details")
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.black)
            .textCase(nil)
            .frame(height: 0, alignment: .center)
            .padding(.leading, 25)
        ) {
            // Display Name Button with navigation
            SettingButtonWithAccountDetailView(
                buttonText: "Display Name",
                accountDetail: appController.loadedUserProfile?.displayName ?? "[none]"
            )
            .background(
                NavigationLink(
                    "",
                    destination: DisplayNameView(appController: appController, settingsViewModel: settingsViewModel)
                )
                .opacity(0)
            )
            
            // Email Button with navigation
            SettingButtonWithAccountDetailView(
                buttonText: "Email",
                accountDetail: appController.loadedUserProfile?.email ?? "[none]"
            )
            .background(
                NavigationLink(
                    "",
                    destination: EmailView(appController: appController, settingsViewModel: settingsViewModel)
                )
                .opacity(0)
            )
            
            // Password Button with navigation
            SettingButtonWithAccountDetailView(
                buttonText: "Password",
                accountDetail: "Change Password"
            )
            .background(
                NavigationLink(
                    "",
                    destination: PasswordView(appController: appController, settingsViewModel: settingsViewModel)
                ).opacity(0)
            )
        }
        .listRowSeparator(.hidden)
        .padding(.top, -10)
    }
}

#Preview {
    AccountDetailesView(appController: AppViewController(), settingsViewModel: SettingsViewModel())
}
