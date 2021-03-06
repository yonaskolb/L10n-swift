//
//  ResourceContainer.swift
//  L10n_swift
//
//  Created by Adrian Bobrowski on 24.06.2017.
//  Copyright © 2017 Adrian Bobrowski (Decybel07), adrian071993@gmail.com. All rights reserved.
//

import Foundation

internal struct ResourceContainer {

    private let name: String
    private let bundle: Bundle?
    private var resource: Resource = EmptyResource()

    subscript(keyPath: String) -> String? {
        return self.resource[keyPath]
    }

    init(bundle: Bundle?, name: String) {
        self.name = name
        self.bundle = bundle

        self.resource = [
            self.cleanStringsdict(self.loadDictionary(ofType: "stringsdict")),
            self.loadDictionary(ofType: "strings"),
            self.loadDictionary(ofType: "plist"),
            self.loadJSON(),
        ].reduce(self.resource) { $0.merging(DictionaryResource($1)) }
    }

    private func loadJSON() -> [String: Any] {
        guard let path = self.bundle?.path(forResource: self.name, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let dictionary = json as? [String: Any]
        else {
            return [:]
        }
        return dictionary
    }

    private func loadDictionary(ofType type: String) -> [String: Any] {
        guard let path = self.bundle?.path(forResource: self.name, ofType: type),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            return [:]
        }
        return dictionary
    }

    private func cleanStringsdict(_ dictionary: [String: Any]) -> [String: Any] {
        var dictionary = dictionary
        dictionary.keys.forEach {
            guard let format = dictionary[$0] as? [String: Any] else {
                return
            }

            if var value = format["value"] as? [String: Any], format.keys.contains("NSStringLocalizedFormatKey") {
                value.removeValue(forKey: "NSStringFormatSpecTypeKey")
                value.removeValue(forKey: "NSStringFormatValueTypeKey")
                dictionary[$0] = value
            } else {
                dictionary[$0] = self.cleanStringsdict(format)
            }
        }
        return dictionary
    }
}
