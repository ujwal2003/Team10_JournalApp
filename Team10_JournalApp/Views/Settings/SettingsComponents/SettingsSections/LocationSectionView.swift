//
//  LocationSectionView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/2/24.
//

import SwiftUI

struct LocationSectionView: View {
    @ObservedObject var appController: AppViewController
    @Binding var isLocationShared: Bool
    
    var body: some View {
        Section(header:
                    Text("Location")
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.black)
            .textCase(nil)
            .frame(height: 0, alignment: .center)
            .padding(.leading, 25)
        ) {
            // Share Location Toggle
            HStack {
                SettingButtonWithToggleView(
                    buttonText: "Use My Location",
                    isToggleOn: $isLocationShared
                )
            }
            
            // Custom Location Button
            ZStack {
                if !isLocationShared {
                    // Navigate to CustomLocationView when toggle is off
                    CustomLocationButtonView(appController: appController, isLocationShared: $isLocationShared)
                        .background(NavigationLink("", destination: CustomLocationView()).opacity(0))
                } else {
                    // Static button when toggle is on
                    CustomLocationButtonView(appController: appController, isLocationShared: $isLocationShared)
                }
            }
            .onChange(of: isLocationShared) { oldValue, newValue in
                let uid = appController.loadedUserProfile?.userId ?? "NIL"
                let settingKey = CommonUtilities.util.getSavedUserUseLocationSettingKey(userId: uid)
                
                UserDefaults.standard.set(newValue, forKey: settingKey)
            }
            
        }
        .listRowSeparator(.hidden)
        .padding(.top, -10)
    }
}

#Preview {
    @Previewable @State var previewLocationShared: Bool = false
    
    NavigationStack {
        List {
            LocationSectionView(appController: AppViewController(), isLocationShared: $previewLocationShared)
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
        .listRowSpacing(0)
    }
}
