//
//  SportsListModel.swift
//  KheloIndiaAssingment
//
//  Created by Abhinav on 26/10/24.
//

import Foundation

// MARK: - SportsListResponseModel
struct SportsListResponseModel: Codable {
    var status: String?
    var statusCode: Int?
    var message: String?
    var data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    var sportID, nsrsSportID: Int?
    var sportName, rfSportDBName: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case sportID = "sport_id"
        case nsrsSportID = "nsrs_sport_id"
        case sportName = "sport_name"
        case rfSportDBName = "rf_sport_db_name"
        case status
    }
}
