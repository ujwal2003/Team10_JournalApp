//
//  AppLayoutContainer.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/30/24.
//

import SwiftUI

struct AppLayoutContainer<TitleContent: View, ContainerContent: View>: View {
    var height: CGFloat
    
    let titleContent: TitleContent
    let containerContent: ContainerContent
    
    init(height: CGFloat,
         @ViewBuilder titleContent: () -> TitleContent,
         @ViewBuilder containerContent: () -> ContainerContent) {
        
        self.height = height
        self.titleContent = titleContent()
        self.containerContent = containerContent()
    }
    
    var body: some View {
        LinearGradient(gradient: Gradient(stops: [
                    Gradient.Stop(color: Color(red: 0.866, green: 0.949, blue: 0.992), location: 0.0),
                    Gradient.Stop(color: Color(red: 0.843, green: 0.922, blue: 0.965), location: 0.20),
                    Gradient.Stop(color: Color(red: 0.518, green: 0.565, blue: 0.592), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
            .overlay {
                VStack {
                    Group {
                        titleContent
                    }
                    
                    Spacer()
                        .frame(height: height)
                    
                    ZStack {
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .background(Color.white)
                            .frame(maxHeight: .infinity)
                            .clipShape(RoundedCorner(radius: 25.0,
                                                     corners: [.topLeft, .topRight]))
                            .ignoresSafeArea()
                        
                        containerContent
                    }
                }
            }
    }
}

#Preview {
    AppLayoutContainer(height: 40.0) {
        VStack(alignment: .leading) {
            Text("title")
        }
        
    } containerContent: {
        Text("hewwo")
    }

}
