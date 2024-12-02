//
//  SettingView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 10/22/24.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var appController: AppViewController
    @StateObject var viewModel = SettingsViewModel()
    
    // User state variables
    @State private var isShowingChangeCredentialsAlert: Bool = false
    @State private var isShowingSignOutAlert: Bool = false
    @State private var isShowingDeleteAccountAlert: Bool = false
    @State private var isLocationShared: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            AppLayoutContainer(height: 20.0) {
                // Header for Settings
                VStack(alignment: .leading, spacing: 10) {
                    Text("Settings")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical)
            } containerContent: {
                // Main content of the settings
                VStack {
                    NavigationStack {
                        VStack {
                            List {
                                AccountDetailesView(appController: appController, settingsViewModel: viewModel)
                                
                                ManageAccountView(
                                    appController: appController,
                                    settingsViewModel: viewModel,
                                    isShowingChangeCredentialsAlert: $isShowingChangeCredentialsAlert,
                                    isShowingSignOutAlert: $isShowingSignOutAlert,
                                    isShowingDeleteAccountAlert: $isShowingDeleteAccountAlert
                                )
                                
                                LocationSectionView(isLocationShared: $isLocationShared)
                                
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                            .listRowSpacing(0)
                        }
                    }
                }
                
                if viewModel.isResettingJournal || viewModel.isDeletingAccount {
                    ProgressBufferView(backgroundColor: Color(.systemGray5).opacity(0.98)) {
                        Text("Please wait...")
                    }
                }
                
            }
        }
    }
}

#Preview {
    SettingView(appController: AppViewController())
}
