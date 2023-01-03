//
//  Encodable.swift
//  Teams
//
//  Created by Shyam Kumar on 1/3/23.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension Array where Element: Codable {
    var compresss: [[String: Any]]? {
        self.compactMap({ $0.dictionary })
    }
}

extension Dictionary where Key == String, Value == Any {
    var stringified: String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            guard let string = String(data: data, encoding: .utf8) else {
                return ""
            }
            return string
        } catch let err {
            print(err)
            return ""
        }
    }
}
