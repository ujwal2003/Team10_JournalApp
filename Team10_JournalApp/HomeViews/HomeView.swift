//
//  HomeView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/8/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel(cityHealthPercentage: 1.0,
                                                       weatherStatus: .Cloudy,
                                                       numFriends: 5,
                                                       dummyWeek: 0)
    
    var body: some View {
        ZStack {
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
                    Text("Recommended  actions for today")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal)
                        .padding(.vertical, 8.0)
                })
                .disabled(viewModel.isNavigateLoading)
                .frame(width: 190)
                .background(Color(red: 0.09, green: 0.28, blue: 0.39))
                .foregroundStyle(Color.white)
                .cornerRadius(18)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .opacity(viewModel.isNavigateLoading ? 0.4 : 1)
                
                // MARK: - City/Journal Map
                let currCityMap = viewModel.getCityMap(week: viewModel.dummyWeek)
                CityJournalMapView(map: currCityMap.map, buildings: currCityMap.buildings)
                    .sheet(isPresented: $viewModel.isGrowthReportShowing) {
                        let dayIndex = viewModel.selectedGrowthReportIndex
                        
                        CityGrowthView(headlineTitle: "\(viewModel.days[dayIndex])'s City Growth",
                                       growthReport: currCityMap.reports[dayIndex])
                    }
                
                // MARK: - Bottom Navigation
                HStack {
                    // MARK: - Left Navigate
                    Button(action: { viewModel.getPrevWeekMap() }, label: {
                        Image(systemName: "arrow.left.square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundStyle(Color(red: 0.09, green: 0.28, blue: 0.39))
                            .opacity(viewModel.isNavigateLoading ? 0.4 : 1)
                    })
                    .disabled(viewModel.isNavigateLoading)
                    .padding()
                    
                    Spacer()
                    
                    // MARK: Week and Number of Friends
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
                    
                    // MARK: - Right Navigate
                    Button(action: { viewModel.getNextWeekMap() }, label: {
                        Image(systemName: "arrow.right.square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .foregroundStyle(Color(red: 0.09, green: 0.28, blue: 0.39))
                            .opacity(viewModel.isNavigateLoading ? 0.4 : 1)
                    })
                    .disabled(viewModel.isNavigateLoading)
                    .padding()
                    
                }.padding([.leading, .bottom, .trailing])
                
                Spacer()
            }
            
            if viewModel.isNavigateLoading {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                                
                ProgressView("Loading Data...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
        
    }
}

//#Preview {
//    HomeView()
//}
