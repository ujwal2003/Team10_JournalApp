//
//  LocationSectionView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 12/2/24.
//

import SwiftUI

struct LocationSectionView: View {
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
                    CustomLocationButtonView(isLocationShared: $isLocationShared)
                        .background(NavigationLink("", destination: CustomLocationView()).opacity(0))
                } else {
                    // Static button when toggle is on
                    CustomLocationButtonView(isLocationShared: $isLocationShared)
                }
            }
            .onChange(of: isLocationShared) { oldValue, newValue in
                print("old: \(oldValue), new: \(newValue)")
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
            LocationSectionView(isLocationShared: $previewLocationShared)
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
        .listRowSpacing(0)
    }
}
