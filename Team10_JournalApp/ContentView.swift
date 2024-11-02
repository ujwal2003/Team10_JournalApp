//
//  ContentView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/6/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appController = AppViewController()
    
    var body: some View {
        ZStack {
            if appController.loggedIn {
                UserContentView(appController: appController)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .move(edge: .top))
                    )
                    .preferredColorScheme(.light)
                
            } else {
                if appController.viewSignUpFlag {
                    SignUpView(appController: appController)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading))
                        )
                        .preferredColorScheme(.light)
                } else {
                    SignInView(appController: appController)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing))
                        )
                        .preferredColorScheme(.light)
                }
            }
        }
        .animation(.spring, value: appController.loggedIn || appController.viewSignUpFlag)
        .environmentObject(appController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDisplayName("Portrait")

        ContentView().previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Landscape Left")
    }
}
