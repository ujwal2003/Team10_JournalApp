//
//  CityBlockDataTestView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/25/24.
//

import SwiftUI

struct CityBlockDataTestView: View {
    @State var loadedUserProfile: UserProfile?
    
    @State var dateOffset: Int
    @State var cityBlockData: CityBlockData?
    @State var resultText: String
    
    init(loadedUserProfile: UserProfile?) {
        self.loadedUserProfile = loadedUserProfile
        self.dateOffset = 0
        self.cityBlockData = nil
        self.resultText = "No data loaded..."
    }
    
    func getDateWithOffset(offset: Int) -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        let newDate = calendar.date(byAdding: .day, value: offset, to: currentDate)!
        return newDate
    }
    
    func getCurrentWeekDates() -> (startDate: Date, endDate: Date) {
        let currentDate = Date()
        
        let calendar = Calendar.current
        
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        
        let targetWeekStart = calendar.date(byAdding: .weekOfYear, value: 0, to: startOfWeek)!
        let targetWeekEnd = calendar.date(byAdding: .day, value: 6, to: targetWeekStart)!
        
        return (startDate: targetWeekStart, endDate: targetWeekEnd)
    }
    
    var body: some View {
        let currWeek = getCurrentWeekDates()
        
        VStack {
            Group {
                if let userProfile = loadedUserProfile {
                    Text("User: \(userProfile.displayName)")
                } else {
                    Text("Loading user...")
                }
            }
            
            Text("Current Week: \(currWeek.startDate.formatted(.dateTime.month().day().year())) - \(currWeek.endDate.formatted(.dateTime.month().day().year()))")
                .padding()
            
            // MARK: - Date Offset controls
            HStack {
                Button {
                    self.dateOffset += 1
                    
                    print("search date set to: \(getDateWithOffset(offset: dateOffset))")
                } label: {
                    Text("+").font(.headline)
                }
                .buttonStyle(TestButtonStyle(backgroundColor: Color.green, textColor: Color.white))
                
                Text("Date Offset: \(dateOffset)")
                    .padding()
                
                Button {
                    self.dateOffset -= 1
                    
                    print("search date set to: \(getDateWithOffset(offset: dateOffset))")
                } label: {
                    Text("-").font(.headline)
                }
                .buttonStyle(TestButtonStyle(backgroundColor: Color.red, textColor: Color.white))
            }
            
            // MARK: - Create City Block Data
            Button {
                print("create new city block data for user")
            } label: {
                Text("Create city block data for the current week for user")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.cyan, textColor: Color.white))
            .padding([.top, .leading, .trailing])
            
            // MARK: - Get City Block Data
            Button {
                print("get the city block data for the current week for user")
            } label: {
                Text("Get city block data for the current week for the user")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.indigo, textColor: Color.white))
            .padding([.top, .leading, .trailing])
            
            // MARK: - Add Journal id to City Block Data
            Button {
                print("add journal id to current week city map")
            } label: {
                Text("Add journal for date offset \(dateOffset) to current city block data")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.mint, textColor: Color.white))
            .padding()
            
            // MARK: - Result Display
            if let data = cityBlockData {
                Group {
                    Text("userID: \(data.userId)")
                    Text("start of week: \(data.weekStartDate)")
                    Text("end of week: \(data.weekEndDate)")
                    Text("map name: \(data.mapName)")
                    Text("journals id list: \(data.journalIDs)")
                }
                .padding([.leading, .trailing])
            } else {
                Text(resultText).padding()
            }
            
        }
    }
}
