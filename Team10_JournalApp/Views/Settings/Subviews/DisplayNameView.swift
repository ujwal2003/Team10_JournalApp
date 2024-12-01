//
//  DisplayNameView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 12/1/24.
//

import SwiftUI

struct DisplayNameView: View {
    @State private var displayName: String = "JohnDoe" // Default display name
    @Environment(\.dismiss) private var dismiss // Access the dismiss environment value

    var body: some View {
        NavigationStack {
            AppLayoutContainer(height: 20.0) {
                // Title Content
                VStack(alignment: .leading, spacing: 10) {
                    Text("Display Name")
                        .font(.system(size: 30.0).weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 40.0)
                        .foregroundStyle(Color.black)
                }
                .padding(.vertical)
            } containerContent: {
                // Main Content
                VStack(spacing: 20) {
                    // Rounded text field for the display name
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 315, height: 52)
                            .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                            .cornerRadius(100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                            )
                        
                        TextField("JohnDoe", text: $displayName) // TODO: fetch the user's actual display name instead
                            .autocorrectionDisabled()
                            .padding(.horizontal, 5)
                            .frame(width: 295, height: 52)
                            .foregroundColor(.black)
                            .submitLabel(.next)
                    }
                    .padding(.vertical, 25)
                    
                    // Done button
                    Button(action: {
                        // Save the updated display name
                        print("Display Name Updated: \(displayName)")
                        // Dismiss the view and go back to SettingView
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
                    
                    Spacer() // Push the content up
                }
            }
        }
    }
}

#Preview {
    DisplayNameView()
}


