//
//  CodableExtensions.swift
//  Beaver
//
//  Created by Ravi Tripathi on 19/01/20.
//  Copyright © 2020 Ravi Tripathi. All rights reserved.
//

import Foundation

public extension Encodable {
    /// Store an encodable object to specified directory
    ///
    /// - Parameters:
    ///   - object: The encodable object to store
    ///   - directory: The directory (.documents or .cache) for storing the file
    ///   - fileName: Name of the file, with extension
    ///   - result: [StorageResult](x-source-tag://StorageResult)
    func store(to directory: Beaver.Directory = .documents, withFileName fileName: String = "\(String(describing: Self.self)).json", completition:@escaping (_ result: StorageResult) -> () = { _ in }) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            Beaver.default.store(data: data, to: directory, withFileName: fileName, completition: completition)
        } catch {
            let result = StorageResult(success: false, errorMessage: error.localizedDescription, filePath: nil, data: nil)
            completition(result)
        }
    }
}

public extension Decodable {
    /// Retrieve an encodable object from specified directory
    ///
    /// - Parameters:
    ///   - fileName: Name of the file where object is stored
    ///   - directory: The directory (.documents or .cache) where file is stored
    ///   - type: Codable Model to be retrieved
    ///   - result: [StorageResult](x-source-tag://StorageResult)
    ///   - model: Parsed Model
    mutating func retrieve(withFileName fileName: String = "\(String(describing: Self.self)).json", from directory: Beaver.Directory = .documents, completition:@escaping (_ result: StorageResult) -> () = { _ in }) {
        Beaver.default.retrieve(withFileName: fileName, from: directory) { (result) in
            if result.success, let data = result.data {
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(Self.self, from: data)
                    self = model
                    completition(result)
                } catch {
                    completition(StorageResult(success: false, errorMessage: error.localizedDescription, filePath: nil, data: nil))
                }
            } else if let url = result.filePath {
                completition(StorageResult(success: false, errorMessage: "No data at \(url.path)!", filePath: nil, data: nil))
            }
        }
    }
}
