//
//  StorageTests.swift
//  TeamsTests
//
//  Created by Shyam Kumar on 1/3/23.
//

@testable import Teams
import XCTest

fileprivate class StorageManagerMock: StorageManager {
    override var storage: UserDefaults {
        get { UserDefaults(suiteName: #file)! }
        set { }
    }
    
    func save<T: Codable>(_ obj: T, with key: String) {
        guard let objDictionary = obj.dictionary else { return }
        storage.set(objDictionary, forKey: key)
    }
    
    func save<T: Codable>(_ obj: Array<T>, with key: String) {
        guard let objDictionary = obj.compresss else { return }
        storage.set(objDictionary, forKey: key)
    }
    
    func read<T: Codable>(type: T.Type, from key: String) -> T? {
        if let objectDict = storage.object(forKey: key) as? [String: Any],
           let data = try? JSONSerialization.data(withJSONObject: objectDict),
           let obj = try? JSONDecoder().decode(T.self, from: data) {
            return obj
        } else {
            return nil
        }
    }
    
    func read<T: Codable>(type: Array<T>.Type, from key: String) -> Array<T> {
        if let objectDict = storage.object(forKey: key) as? [[String: Any]],
           let data = try? JSONSerialization.data(withJSONObject: objectDict),
           let obj = try? JSONDecoder().decode(Array<T>.self, from: data) {
            return obj
        } else {
            return []
        }
    }
}

final class StorageTests: XCTestCase {
    class SUT: Codable, Equatable {
        var test: String
        var test2: String
        
        init(test: String, test2: String) {
            self.test = test
            self.test2 = test2
        }
        
        static func == (lhs: StorageTests.SUT, rhs: StorageTests.SUT) -> Bool {
            lhs.test == rhs.test && lhs.test2 == rhs.test2
        }
    }
    
    enum Keys: String {
        case arrayTest
        case objectTest
    }
    
    fileprivate var storageManager = StorageManagerMock()
    
    func testStorage_StoreArray_ShouldStoreCorrectly() {
        let sutArr = [
            SUT(test: "Hello", test2: "World")
        ]
        storageManager.save(sutArr, with: Keys.arrayTest.rawValue)
        XCTAssertEqual(sutArr, storageManager.read(type: [SUT].self, from: Keys.arrayTest.rawValue))
    }
}
