//
//  AllDependencies.swift
//  Teams
//
//  Created by Shyam Kumar on 1/1/23.
//

import Foundation

protocol AllDependencies: HasAPI, HasSession, HasStorage {}

protocol HasAPI {
    var api: API { get set }
}

protocol HasSession {
    var session: Session { get set }
}

protocol HasStorage {
    var storage: Storage { get set }
}

class Dependencies: AllDependencies {
    var storage: Storage = StorageManager()
    lazy var session: Session = SessionManager(dependencies: self)
    lazy var api: API = APIManager(dependencies: self)
}

