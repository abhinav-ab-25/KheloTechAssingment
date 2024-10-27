//
//  SportsViewModel.swift
//  KheloIndiaAssingment
//
//  Created by Abhinav on 26/10/24.
//
import Foundation

class SportsListViewModel {
    
    
    private let networkManager: NetworkHandler
    private let dbManager: DatabaseManager
    
    
    init(networkManager: NetworkHandler, dbManager: DatabaseManager) {
        self.networkManager = networkManager
        self.dbManager = dbManager
    }
    
    
    func getSportsList(completion: @escaping ([Datum]?) -> Void) {
        
        if InternetConnectionManager.isConnectedToNetwork() {
            fetchFromNetwork { [weak self] data in
                guard let self = self, let fetchedData = data else {
                    completion(nil)
                    return
                }
                self.saveSportsList(fetchedData, completion: completion)
            }
        } else {
            fetchFromDatabase(completion: completion)
        }
    }
    
    func deleteSpecificUser(sport: Datum, completion: @escaping ([Datum]?) -> Void) {
        dbManager.deleteSpecificUser(sport: sport) { [weak self] _ in
            self?.fetchFromDatabase(completion: completion)
        }
    }
    
    
    private func fetchFromNetwork(completion: @escaping ([Datum]?) -> Void) {
        guard let url = URL(string: sportsList) else {
            completion(nil)
            return
        }
        
        networkManager.APIRequest(requestURL: url, resultType: SportsListResponseModel.self, httpMethod: .GET) { result in
            switch result {
            case .success(let data):
                completion(data.data)
            case .failure:
                completion(nil)
            }
        }
    }
    
    private func saveSportsList(_ data: [Datum], completion: @escaping ([Datum]?) -> Void) {
        dbManager.saveSportsList(data: data) { [weak self] _ in
            self?.fetchFromDatabase(completion: completion)
        }
    }
    
    private func fetchFromDatabase(completion: @escaping ([Datum]?) -> Void) {
        dbManager.fetchSportsList { savedData in
            let sportsList = savedData?.map { entity in
                Datum(sportID: Int(entity.sportID),
                      nsrsSportID: Int(entity.nsrsSportID),
                      sportName: entity.sportName,
                      rfSportDBName: entity.rfSportDBName,
                      status: entity.status)
            }
            completion(sportsList)
        }
    }
    
    func getDataBySortedNames(completion: @escaping ([Datum]?) -> Void){
        dbManager.fetchSportsListSortedByName { sportsList in
            
            guard let data = sportsList else {
                completion(nil)
                return
            }
            
            var datum = [Datum]()
            for i in data {
                var value = Datum(sportID: Int(i.sportID),nsrsSportID: Int(i.nsrsSportID), sportName: i.sportName ?? "",rfSportDBName: i.rfSportDBName ?? "",status: i.status)
                datum.append(value)
            }
            completion(datum)
        }
    }
    
    func getDataBysortedID(completion: @escaping ([Datum]?) -> Void) {
        dbManager.fetchSportsListSortedByID { sportsList in
            
            guard let data = sportsList else {
                completion(nil)
                return
            }
            
            var datum = [Datum]()
            for i in data {
                var value = Datum(sportID: Int(i.sportID),nsrsSportID: Int(i.nsrsSportID), sportName: i.sportName ?? "",rfSportDBName: i.rfSportDBName ?? "",status: i.status)
                datum.append(value)
            }
            completion(datum)
        }
    }
}
