//
//  CustomLocationButtonView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 11/30/24.
//

import SwiftUI

struct CustomLocationButtonView: View {
    @ObservedObject var appController: AppViewController
    
    @Binding var isLocationShared: Bool // Toggle state for sharing location
    @State var defaultLocation: String = "[City], [State]" // Default location
    @State var currentLocation: String = "Houston, TX, USA" // FIXME: Current location when sharing is on

    var body: some View {
        ZStack {
            // Button background with shadow
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 50)
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
        .frame(maxWidth: .infinity, maxHeight: 50)
        .task {
            if let profile = appController.loadedUserProfile {
                let decodedPlace = try? await CommonUtilities.util.decodePlaceFromCoordinates(latitude: profile.locLati, longitude: profile.locLongi)
                
                if let place = decodedPlace {
                    self.defaultLocation = "\(place.locality ?? "City"), \(place.administrativeArea ?? "State")"
                }
            }
        }
        
    }
}
