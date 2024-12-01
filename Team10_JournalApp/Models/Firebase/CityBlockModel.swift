//
//  CityBlockModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/25/24.
//

import Foundation
import FirebaseFirestore

struct CityBlockData: Codable {
    @DocumentID var cityBlockId: String?
    let userId: String
    let weekStartDate: Date
    let weekEndDate: Date
    let mapName: String
    let journalIDs: [String]
    
    var cityMap: Map {
        Map(rawValue: mapName) ?? .NotFoundMap
    }
    
    init(
        cityBlockId: String? = nil,
        userId: String,
        weekStartDate: Date,
        weekEndDate: Date,
        mapName: String,
        journalIDs: [String]
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
        self.journalIDs = try container.decode([String].self, forKey: .journalIDs)
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
