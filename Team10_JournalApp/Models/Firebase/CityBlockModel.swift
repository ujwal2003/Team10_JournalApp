//
//  CityBlockModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/25/24.
//

import Foundation
import FirebaseFirestore

enum DayID: String {
    case Sunday = "sundayID"
    case Monday = "mondayID"
    case Tuesday = "tuesdayID"
    case Wednesday = "wednesdayID"
    case Thursday = "thursdayID"
    case Friday = "fridayID"
    case Saturday = "saturdayID"
    
    /// Returns day ID based on an integer representation of the days of week.
    /// Where there are N=7 integers, with Sunday being 0.
    static func getDayIDByInteger(dayIndex: Int) -> DayID? {
        switch dayIndex {
            case 0: return .Sunday
            case 1: return .Monday
            case 2: return .Tuesday
            case 3: return .Wednesday
            case 4: return .Thursday
            case 5: return .Friday
            case 6: return .Saturday
            default: return nil
        }
    }
}

struct JournalDaysIDs: Codable {
    let sundayID: String
    let mondayID: String
    let tuesdayID: String
    let wednesdayID: String
    let thursdayID: String
    let fridayID: String
    let saturdayID: String
}

struct CityBlockData: Codable {
    @DocumentID var cityBlockId: String?
    let userId: String
    let weekStartDate: Date
    let weekEndDate: Date
    let mapName: String
    let journalIDs: JournalDaysIDs
    
    var cityMap: Map {
        Map(rawValue: mapName) ?? .NotFoundMap
    }
    
    init(
        cityBlockId: String? = nil,
        userId: String,
        weekStartDate: Date,
        weekEndDate: Date,
        mapName: String,
        journalIDs: JournalDaysIDs
    ) {
        self.cityBlockId = cityBlockId
        self.userId = userId
        self.weekStartDate = weekStartDate
        self.weekEndDate = weekEndDate
        self.mapName = mapName
        self.journalIDs = journalIDs
    }
    
    enum CodingKeys: String, CodingKey {
        case cityBlockId = "city_block_id"
        case userId = "user_id"
        case weekStartDate = "week_start_date"
        case weekEndDate = "week_end_date"
        case mapName = "map_name"
        case journalIDs = "journal_ids"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._cityBlockId = try container.decode(DocumentID<String>.self, forKey: .cityBlockId)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.weekStartDate = try container.decode(Date.self, forKey: .weekStartDate)
        self.weekEndDate = try container.decode(Date.self, forKey: .weekEndDate)
        self.mapName = try container.decode(String.self, forKey: .mapName)
        self.journalIDs = try container.decode(JournalDaysIDs.self, forKey: .journalIDs)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.cityBlockId, forKey: .cityBlockId)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.weekStartDate, forKey: .weekStartDate)
        try container.encode(self.weekEndDate, forKey: .weekEndDate)
        try container.encode(self.mapName, forKey: .mapName)
        try container.encode(self.journalIDs, forKey: .journalIDs)
    }
}
