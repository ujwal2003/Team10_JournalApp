//
//  SplashScreenView.swift
//  Exercise6_Urtaza_Alvaro
//
//  Created by Alvaro on 10/13/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            SignInView()
                .preferredColorScheme(.light)
        } else {
            VStack {
                Image("CatchUpLogo")
            }
            .padding()
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                            LinearGradient(gradient: Gradient(stops: [
                                Gradient.Stop(color: Color(red: 0.866, green: 0.949, blue: 0.992), location: 0.0),
                                Gradient.Stop(color: Color.white, location: 0.47),
                                Gradient.Stop(color: Color(red: 0.866, green: 0.949, blue: 0.992), location: 1.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom)
                        )
                        .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    SplashScreenView()
}
