//
//  Storage.swift
//  Teams
//
//  Created by Shyam Kumar on 1/3/23.
//

import Foundation

enum StorageKey: String {
    case selectedTeamImageColor = "selectedTic"
    case selectedTeam = "selectedTeam"
    case teamImageColors = "teamImageColors"
    case bdlTeams = "bdlTeams"
    case teams = "teams"
    case games = "games"
}

protocol Storage {
    func save<T: Codable>(_ obj: T, with key: StorageKey?)
    func save<T: Codable>(_ obj: [T], with key: StorageKey?)
    func read<T: Codable>(type: T.Type, from key: StorageKey) -> T?
    func read<T: Codable>(type: [T].Type, from key: StorageKey) -> [T]
}

class StorageManager: Storage {
    var storage = UserDefaults.standard
    
    func save<T: Codable>(_ obj: T, with key: StorageKey?) {
        guard let objDictionary = obj.dictionary else { return }
        guard let key = key else { return }
        storage.set(objDictionary, forKey: key.rawValue)
    }
    
    func save<T: Codable>(_ obj: [T], with key: StorageKey?) {
        guard let objDictionary = obj.compresss else { return }
        guard let key = key else { return }
        storage.set(objDictionary, forKey: key.rawValue)
    }
    
    func read<T: Codable>(type: T.Type, from key: StorageKey) -> T? {
        if let objectDict = storage.object(forKey: key.rawValue) as? [String: Any],
           let data = try? JSONSerialization.data(withJSONObject: objectDict),
           let obj = try? JSONDecoder().decode(T.self, from: data) {
            return obj
        } else {
            return nil
        }
    }
    
    func read<T: Codable>(type: [T].Type, from key: StorageKey) -> [T] {
        if let objectDict = storage.object(forKey: key.rawValue) as? [[String: Any]],
           let data = try? JSONSerialization.data(withJSONObject: objectDict),
           let obj = try? JSONDecoder().decode([T].self, from: data) {
            return obj
        } else {
            return []
        }
    }
}
