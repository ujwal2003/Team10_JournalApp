//
//  FeatureTestingView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/24/24.
//

import SwiftUI

struct FeatureTestingView: View {
    @ObservedObject var appController: AppViewController
    
    var body: some View {
        let loadedUserProfile = appController.loadedUserProfile
        
        VStack {
            JournalCRUDTestView(loadedUserProfile: loadedUserProfile)
        }
    }
}
