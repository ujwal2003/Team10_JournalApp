//
//  ContentView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appController = AppController()
    
    var body: some View {
        VStack {
            if appController.loggedIn {
                UserContentView().preferredColorScheme(.light)
            } else {
                SignInView(appController: appController).preferredColorScheme(.light)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDisplayName("Portrait")

        ContentView().previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Landscape Left")
    }
}
