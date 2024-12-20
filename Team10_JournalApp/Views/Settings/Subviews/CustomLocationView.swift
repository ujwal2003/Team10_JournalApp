//
//  CustomLocationView.swift
//  Team10_JournalApp
//
//  Created by Alvaro on 12/1/24.
//

import SwiftUI
import MapKit

struct CustomLocationView: View {
    @State var usePreviewMocks: Bool = false
    @ObservedObject var appController: AppViewController
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    @State private var location: String = "" // Current user location
    @State private var region: MKCoordinateRegion
    @State private var annotations: [Annotation] = []
    
    let util = CommonUtilities.util
    
    init(usePreviewMocks: Bool = false, appController: AppViewController) {
        self.usePreviewMocks = usePreviewMocks
        self.appController = appController
        
        _region = State(
            initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 52.02833, longitude: 5.16806),
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
        )
    }

    var body: some View {
        Group {
            // Conditional ScrollView for landscape mode
            if DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass).isLandscape(device: .iPhone) {
                ScrollView {
                    content
                }
                .scrollIndicators(.never)
            } else {
                content
            }
        }
        .task {
            if self.usePreviewMocks {
                appController.loadedUserProfile = .init(
                    userId: "",
                    email: "",
                    displayName: "",
                    dateCreated: Date(),
                    photoURL: nil
                )
            }
            
            if let profile = appController.loadedUserProfile {
                let coord = CLLocationCoordinate2D(latitude: profile.locLati, longitude: profile.locLongi)
                
                self.region = MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                )
                
                let decodedPlace = try? await util.decodePlaceFromCoordinates(latitude: profile.locLati, longitude: profile.locLongi)
                
                if let place = decodedPlace {
                    self.annotations.removeAll()
                    self.annotations.append(
                        Annotation(
                            title: "\(place.locality ?? ""), \(place.administrativeArea ?? ""), \(place.isoCountryCode ?? "")",
                            subtitle: "Selected Location",
                            coordinate: coord
                        )
                    )
                }
            }
        }
    }
    
    // Main content of the CustomLocationView
    private var content: some View {
        VStack {
            // Page title
            Text("Set Custom Location")
                .font(.system(size: 30))
                .fontWeight(.heavy)
                .padding()
            
            // Input field for entering location
            HStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 52)
                        .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                        )
                    
                    TextField("Enter Location", text: $location)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.leading, 15)
                        .frame(height: 52)
                        .submitLabel(.next)
                }
                
                Button {
                    util.searchForPlace(query: location) { coordinate in
                        region.center = coordinate
                        region.span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                        
                        if let profile = appController.loadedUserProfile {
                            selectLocationAndSave(coordinate: coordinate, profile: profile)
                        }
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .buttonStyle(
                    BubbleButtonStyle(
                        backgroundColor: Color.hex("#164863"),
                        textColor: .white,
                        radius: 22,
                        shadowRadius: 2
                    )
                )
                .disabled(location.isEmpty)
                .opacity(location.isEmpty ? 0.5 : 1.0)
            }
            .padding()
            
            // Map view for displaying the selected location
            MapView(region: $region, annotations: $annotations)
                .frame(width: 366, height: 486)
                .foregroundColor(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 0.09, green: 0.28, blue: 0.39).opacity(0.5), lineWidth: 1)
                )
            
            // Display selected location
            Text("Selected Location:")
                .font(.system(size: 24))
            
            // Current location display
            if let resultLoc = annotations.first {
                Text(resultLoc.title)
                    .font(.system(size: 26))
                    .fontWeight(.heavy)
                
            } else {
                Text("Result Location")
                    .font(.system(size: 26))
                    .fontWeight(.heavy)
            }
            
            
            Spacer()
        }
    }
    
    func selectLocationAndSave(coordinate: CLLocationCoordinate2D, profile: UserProfile) {
        Task {
            let decodedPlace = try? await util.decodePlaceFromCoordinates(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            
            if let place = decodedPlace {
                annotations.removeAll()
                annotations.append(
                    Annotation(
                        title: "\(place.locality ?? ""), \(place.administrativeArea ?? ""), \(place.isoCountryCode ?? "")",
                        subtitle: "Selected Location",
                        coordinate: coordinate
                    )
                )
                
                if !usePreviewMocks {
                    try? await UserManager.shared.updateUserLocation(userId: profile.userId, newLati: coordinate.latitude, newLongi: coordinate.longitude)
                    
                    let newLocProfile = UserProfile(
                        userId: profile.userId,
                        email: profile.email,
                        displayName: profile.displayName,
                        dateCreated: profile.dateCreated,
                        photoURL: profile.photoURL,
                        locLati: coordinate.latitude,
                        locLongi: coordinate.longitude
                    )
                    
                    appController.loadedUserProfile = newLocProfile
                }
            }
        }
    }
    
}

#Preview {
    CustomLocationView(usePreviewMocks: true, appController: AppViewController())
}
