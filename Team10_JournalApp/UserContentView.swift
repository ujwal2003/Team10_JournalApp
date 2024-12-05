//
//  UserContentView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/2/24.
//

import SwiftUI

enum AppTab: Hashable {
    case Home; case Journal; case Friends; case Settings
    case FeatureTest // for testing purposes
}

struct UserContentView: View {
    @ObservedObject var appController: AppViewController
    @State var selectedTab: AppTab = .Home
    
    @State var testingMode: Bool = false
    
    @StateObject var locationManager = LocationManager()
    
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        let deviceOrientation = DeviceOrientation(widthSizeClass: widthSizeClass, heightSizeClass: heightSizeClass)
        
        VStack {
            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house", value: .Home) {
                    if deviceOrientation.isPortrait(device: .iPhone) || deviceOrientation.isPortrait(device: .iPhonePlusOrMax) {
                        HomeView(appController: appController)
                        
                    } else if deviceOrientation.isLandscape(device: .iPhone) || deviceOrientation.isLandscape(device: .iPhonePlusOrMax) {
                        HomeLandscapeView(appController: appController)
                    }
                }
                
                Tab("Journal", systemImage: "book", value: .Journal) {
                    JournalEntryView(appController: appController)
                }
                
                Tab("Friends", systemImage: "person.3", value: .Friends) {
                    FriendsView(appController: appController)
                }
                
                Tab("Settings", systemImage: "gear", value: .Settings) {
                    SettingView(appController: appController)
                }
                
                if testingMode {
                    Tab("Testing", systemImage: "apple.terminal.fill", value: .FeatureTest) {
                        FeatureTestingView(appController: appController)
                    }
                }
            }
            .onChange(of: selectedTab) { oldValue, newValue in
                if appController.isJournalInEditMode {
                    appController.isShowingJournalInEditModeAlert = true
                    selectedTab = .Journal
                }
            }
            .onAppear {
                if let profile = appController.loadedUserProfile {
                    let settingKey = CommonUtilities.util.getSavedUserUseLocationSettingKey(userId: profile.userId)
                    let isLocationSharePermissionOn = UserDefaults.standard.bool(forKey: settingKey)
                    
                    if isLocationSharePermissionOn {
                        CommonUtilities.util.requestLocationAccessIfNecessary(locationManager: locationManager)
                    }
                }
            }
            
        }
        
    }
}
