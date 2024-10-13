//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/8/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        DefaultRectContainer(title: .init(text: "CatchUp", fontSize: 30.0),
                             subtitle: .init(text: "", fontSize: 20.0)) {
            
            // MARK: - City Weather & Health Indicator
            Grid(horizontalSpacing: 10, verticalSpacing: 0) {
                GridRow {
                    let cityHealthBar = viewModel.getCityHealthColors()
                    
                    Text("City Health")
                        .font(.system(size: 18.0))
                        .fontWeight(.medium)
                        .gridColumnAlignment(.leading)
                    
                    CapsuleProgressBar(percent: $viewModel.cityHealthPercentage,
                                       height: 25.0,
                                       borderColor: cityHealthBar.borderColor,
                                       borderWidth: 1.0,
                                       barColor: cityHealthBar.barColor)
                    .frame(width: 200)
                    .padding()
                    .gridColumnAlignment(.center)
                }
                
                GridRow {
                    let todaysWeather = viewModel.getWeatherStatus()
                    
                    Text("Weather")
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    HStack {
                        Text(todaysWeather.name)
                            .font(.system(size: 18))
                            .fontWeight(.heavy)
                        
                        Image(systemName: todaysWeather.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: todaysWeather.iconWidth)
                            .foregroundStyle(todaysWeather.iconColor)
                    }
                }
            }
            .padding()
            .padding(.leading)
            
            
            // MARK: - Actions Button
            Button(action: { print("TODO: Actions") }, label: {
                Text("Reccomended  actions for today")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal)
                    .padding(.vertical, 8.0)
            })
            .frame(width: 190)
            .background(Color(red: 0.09, green: 0.28, blue: 0.39))
            .foregroundStyle(Color.white)
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            
            // MARK: - City/Journal Map
            ZStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(maxWidth: .infinity)
                    .padding([.top, .leading, .trailing])
                
                GeometryReader { geometry in
                    
                    Button(action: { print("green building clicked!") }, label: {
                        Image(systemName: "building.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.1,
                                   height: geometry.size.height * 0.15)
                            .foregroundStyle(Color.green)
                    })
                    .position(x: geometry.size.width * 0.88, y: geometry.size.height * 0.15)
                    
                    Button(action: { print("cyan building clicked!") }, label: {
                        Image(systemName: "building.fill")
                            .resizable()
                            .frame(width: geometry.size.width * 0.1,
                                   height: geometry.size.height * 0.15)
                            .foregroundStyle(Color.cyan)
                    })
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.75)
                    
                }
            }
            
            // MARK: - Bottom Navigation
            HStack {
                Button(action: { print("TODO: Left") }, label: {
                    Image(systemName: "arrow.left.square")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .foregroundStyle(Color(red: 0.09, green: 0.28, blue: 0.39))
                }).padding()
                
                Spacer()
                
                VStack(spacing: 4.0) {
                   Text("City Block:")
                       .font(.system(size: 16))
                   
                   Text(viewModel.getCurrCityBlock())
                        .font(.system(size: 15.35))
                       .foregroundStyle(Color(red: 66/255,
                                              green: 100/255,
                                              blue: 125/255))
                   
                   HStack(spacing: 4.0) {
                       Text("Connected to")
                           .font(.system(size: 16))
                       
                       Text("\(viewModel.numFriends)")
                           .font(.system(size: 16))
                           .foregroundStyle(Color(red: 66/255,
                                                  green: 100/255,
                                                  blue: 125/255))
                       
                       Text("cities")
                           .font(.system(size: 16))
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
