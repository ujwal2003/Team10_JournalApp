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
                    self.cityBlockData = nil
                    self.resultText = "No data loaded..."
                    
                    print("search date set to: \(getDateWithOffset(offset: dateOffset))")
                } label: {
                    Text("+").font(.headline)
                }
                .buttonStyle(TestButtonStyle(backgroundColor: Color.green, textColor: Color.white))
                
                Text("Date Offset: \(dateOffset)")
                    .padding()
                
                Button {
                    self.dateOffset -= 1
                    self.cityBlockData = nil
                    self.resultText = "No data loaded..."
                    
                    print("search date set to: \(getDateWithOffset(offset: dateOffset))")
                } label: {
                    Text("-").font(.headline)
                }
                .buttonStyle(TestButtonStyle(backgroundColor: Color.red, textColor: Color.white))
            }
            
            // MARK: - Create City Block Data
            Button {
                self.cityBlockData = nil
                
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            let newCityData = CityBlockData(
                                userId: userProfile.userId,
                                weekStartDate: currWeek.startDate,
                                weekEndDate: currWeek.endDate,
                                mapName: "Map1",
                                journalIDs: []
                            )
                            
                            try await CityBlockManager.shared.createNewCityBlockMap(cityBlockData: newCityData)
                            print("Succesfully created new city block data for current week")
                            self.resultText = "Succesfully created new city block data for current week."
                        }
                    } catch {
                        print("Failed to make new city block data with error: \(error)")
                        self.resultText = "Error: failed to make new city block."
                    }
                }
            } label: {
                Text("Create city block data for the current week for user")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.cyan, textColor: Color.white))
            .padding([.top, .leading, .trailing])
            
            // MARK: - Get City Block Data
            Button {
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            self.resultText = "No data loaded..."
                            
                            let fetchedData = try await CityBlockManager.shared.getCityBlockData(
                                userId: userProfile.userId,
                                weekStartDate: currWeek.startDate,
                                weekEndDate: currWeek.endDate
                            )
                            
                            print("Succesfully fetched user's city block data for the current week")
                            self.cityBlockData = fetchedData
                        }
                    } catch {
                        print("Failed to fetch user's city block data with error: \(error)")
                        self.resultText = "Error: failed to fetch city block data."
                    }
                }
            } label: {
                Text("Get city block data for the current week for the user")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(TestButtonStyle(backgroundColor: Color.indigo, textColor: Color.white))
            .padding([.top, .leading, .trailing])
            
            // MARK: - Add Journal id to current week City Block Data
            Button {
                self.cityBlockData = nil
                
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            let searchDate = getDateWithOffset(offset: dateOffset)
                            
                            let fetchedEntry = try await JournalManager.shared.getJournalEntry(userId: userProfile.userId, date: searchDate)
                            print("Fetched journal for date: \(searchDate)")
                            
                            try await CityBlockManager.shared.addJournalToCityBlockMap(
                                userId: userProfile.userId,
                                weekStartDate: currWeek.startDate,
                                weekEndDate: currWeek.endDate,
                                journalId: fetchedEntry.journalId!
                            )
                            
                            print("Succesfully added journal id to curr city block")
                            self.resultText = "Added journal \(fetchedEntry.journalId!) to current week city block data."
                        }
                    } catch {
                        print("Failed to add journal id with error: \(error)")
                        self.resultText = "Error: failed to add journal id to city block data."
                    }
                }
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
