//
//  CustomLocationButtonView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 11/30/24.
//

import SwiftUI

struct CustomLocationButtonView: View {
    @Binding var isLocationShared: Bool // Toggle state for sharing location
    var defaultLocation: String = "Houston, TX" // Default location
    var currentLocation: String = "Houston, TX, USA" // Current location when sharing is on

    var body: some View {
        ZStack {
            // Button background with shadow
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 370, height: 49)
                .background(Color.rgb(221, 237, 240))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)

            HStack {
                // Location text based on toggle state
                Text(isLocationShared ? "My Location: \(currentLocation)" : "Default: \(defaultLocation)")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.black)

                Spacer()

                // "Change" and arrow are displayed only if sharing is off
                if !isLocationShared {
                    HStack(spacing: 20) {
                        Text("Change")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(.black.opacity(0.5))

                        Text(">")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(width: 370, height: 49)
    }
}
