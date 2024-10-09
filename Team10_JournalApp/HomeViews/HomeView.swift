//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/8/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        DefaultRectContainer(title: .init(text: "CatchUp", fontSize: 30.0),
                             subtitle: .init(text: "", fontSize: 20.0)) {
            
            HStack(spacing: 30.0) {
                Text("City Health")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                // fix this later
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(maxWidth: 180, maxHeight: 22)
                  .background(Color(red: 0.79, green: 1, blue: 0.87))
                  .cornerRadius(20)
                  .overlay(
                    RoundedRectangle(cornerRadius: 20)
                      .inset(by: 0.5)
                      .stroke(Color(red: 0, green: 0.66, blue: 0.39).opacity(0.4), lineWidth: 1)
                  )
            }.padding([.top, .leading, .trailing])
            
            HStack {
                Text("Weather")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                Spacer()
                    .frame(width: 95.0)
                
                Text("Sunny")
                    .font(.system(size: 18))
                    .fontWeight(.heavy)
                
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .foregroundStyle(Color.yellow)
                    .padding(.trailing, 40.0)
                
            }.padding(.horizontal)
            
            Button(action: { print("TODO: Actions") }, label: {
                Text("Reccomended  actions for today")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding()
            })
            .frame(width: 190)
            .background(Color(red: 0.09, green: 0.28, blue: 0.39))
            .foregroundStyle(Color.white)
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            
            ZStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .leading, .trailing])
                
                Text("Insert Mapo Here")
            }
            
            HStack {
                Button(action: { print("TODO: Left") }, label: {
                    Image(systemName: "arrow.left.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .foregroundStyle(Color(red: 0.09, green: 0.28, blue: 0.39))
                }).padding()
                
                Spacer()
                
                VStack {
                   Text("City Block:")
                       .font(.system(size: 18))
                   
                   Text("1/3/2024-1/9/2024")
                       .font(.system(size: 18))
                       .foregroundStyle(Color(red: 66/255,
                                              green: 100/255,
                                              blue: 125/255))
                   
                   HStack(spacing: 4.0) {
                       Text("Connected to")
                           .font(.system(size: 18))
                       
                       Text("5")
                           .font(.system(size: 18))
                           .foregroundStyle(Color(red: 66/255,
                                                  green: 100/255,
                                                  blue: 125/255))
                       
                       Text("cities")
                           .font(.system(size: 18))
                   }
                }
                
                Spacer()
                
                Button(action: { print("TODO: Right") }, label: {
                    Image(systemName: "arrow.right.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .foregroundStyle(Color(red: 0.09, green: 0.28, blue: 0.39))
                }).padding()
                
            }.padding([.leading, .bottom, .trailing])
            
        }
    }
}

#Preview {
    HomeView()
}
