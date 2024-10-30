//
//  AppLayoutContainer.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/30/24.
//

import SwiftUI

struct AppLayoutContainer<TitleContent: View, ContainerContent: View>: View {
    var heightOffset: CGFloat
    var cornerRadius: CGFloat
    var corners: UIRectCorner
    
    let titleContent: TitleContent
    let containerContent: ContainerContent
    
    init(height: CGFloat,
         cornerRadius: CGFloat = 25.0,
         corners: UIRectCorner = [.topLeft, .topRight],
         @ViewBuilder titleContent: () -> TitleContent,
         @ViewBuilder containerContent: () -> ContainerContent) {
        
        self.heightOffset = height
        self.cornerRadius = cornerRadius
        self.corners = corners
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
                        .frame(height: heightOffset)
                    
                    ZStack {
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .background(Color.white)
                            .frame(maxHeight: .infinity)
                            .clipShape(RoundedCorner(radius: cornerRadius,
                                                     corners: corners))
                            .ignoresSafeArea()
                        
                        containerContent
                    }
                }
            }
    }
}

#Preview {
    AppLayoutContainer(height: 10.0) {
        VStack(alignment: .leading, spacing: 10) {
            Text("Title")
                .font(.system(size: 40.0).weight(.heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40.0)
                .foregroundStyle(Color.black)
            
            Text("Subtitle")
                .font(.system(size: 20).weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40.0)
                .foregroundStyle(Color.black)
        }
        .padding(.vertical)
        
    } containerContent: {
        VStack {
            Text("Hello World")
                .font(.title)
                .padding(50)
            
            Spacer()
        }
    }

}
