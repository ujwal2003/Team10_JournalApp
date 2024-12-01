//
//  CustomLocationView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 12/1/24.
//

import SwiftUI

struct CustomLocationView: View {
    @State private var location: String = "Houston, TX, USA" // Current user location

    var body: some View {
        // Page title
        Text("Set Custom Location")
            .font(.system(size: 30))
            .fontWeight(.heavy)
            .padding()
        
        // Input field for entering location
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 366, height: 52)
                .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                )
            
            TextField("Enter Location", text: $location)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 5)
                .frame(width: 346, height: 52)
                .submitLabel(.next)
        }
        
        // Display selected location
        Rectangle()
            .frame(width: 366, height: 486)
            .foregroundColor(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 0.09, green: 0.28, blue: 0.39).opacity(0.5), lineWidth: 1)
            )
        
        Text("Selected Location:")
            .font(.system(size: 24))
        
        Text(location) // Current location display
            .font(.system(size: 26))
            .fontWeight(.heavy)
        
        Spacer()
    }
}

#Preview {
    CustomLocationView()
}
