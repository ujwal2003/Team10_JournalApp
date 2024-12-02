//
//  DisplayNameView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 12/1/24.
//

import SwiftUI

struct DisplayNameView: View {
    @ObservedObject var appController: AppViewController
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    @State private var displayName: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            // Title for Display Name page
            AppLayoutContainer(height: 20.0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Display Name")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical)
            } containerContent: {
                VStack(spacing: 20) {
                    // Text field for editing the display name
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 315, height: 52)
                            .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                            )
                        
                        let currDisplayName = appController.loadedUserProfile?.displayName ?? "ERROR"
                        TextField(currDisplayName, text: $displayName)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 5)
                            .frame(width: 295, height: 52)
                            .foregroundColor(.black)
                            .submitLabel(.next)
                    }
                    .padding(.vertical, 25)
                    
                    // Done button to save changes
                    Button(action: {
                        print("Display Name Updated: \(displayName)")
                        dismiss()
                    }) {
                        Text("Done")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 315, height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(red: 0.09, green: 0.28, blue: 0.39))
                                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            )
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DisplayNameView(appController: AppViewController(), settingsViewModel: SettingsViewModel())
}
