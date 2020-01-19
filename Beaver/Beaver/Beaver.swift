//
//  Beaver.swift
//  Beaver
//
//  Created by Ravi Tripathi on 16/04/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import Foundation

/// Contains a success flag, filePath of saved file and errorMessage if a file operation fails
///
/// - Tag: StorageResult
///
public struct StorageResult {
    public var success: Bool
    public var errorMessage: String?
    public var filePath: URL?
    public var data: Data?
}

public extension Encodable {
    /// Store an encodable object to specified directory
    ///
    /// - Parameters:
    ///   - object: The encodable object to store
    ///   - directory: The directory (.documents or .cache) for storing the file
    ///   - fileName: Name of the file, with extension
    ///   - result: [StorageResult](x-source-tag://StorageResult)
    public func store(to directory: Beaver.Directory = .documents, withFileName fileName: String = "\(String(describing: Self.self)).json", completition:@escaping (_ result: StorageResult) -> () = { _ in }) {
        let url = Beaver.default.getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            let result = StorageResult(success: true, errorMessage: nil, filePath: url, data: data)
            completition(result)
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
        let url = Beaver.default.getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            completition(StorageResult(success: false, errorMessage: "File at path \(url.path) does not exist!", filePath: nil, data: nil))
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(Self.self, from: data)
                self = model
                completition(StorageResult(success: true, errorMessage: nil, filePath: url, data: data))
            } catch {
                completition(StorageResult(success: false, errorMessage: error.localizedDescription, filePath: nil, data: nil))
            }
        } else {
            completition(StorageResult(success: false, errorMessage: "No data at \(url.path)!", filePath: nil, data: nil))
        }
    }
}

public class Beaver {
    
    public static let `default` = Beaver()
    
    fileprivate init() { }
    
    /// - Tag: Directory
    ///
    /// Available Directories for Storage. Can be of two types:
    /// - documents : Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
    /// - caches: Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
    public enum Directory {
        case documents
        case caches
    }
    
    /// Returns URL constructed from specified directory
    public func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    /// Clears all files in a given [Directory](x-source-tag://Directory)
    ///
    /// - Parameter directory: The [Directory](x-source-tag://Directory) to be cleared
    public func clear(_ directory: Directory) {
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Remove specified file from the given [Directory](x-source-tag://Directory)
    ///
    /// - Parameters:
    ///   - fileName: File name to be removed
    ///   - directory: The given [Directory](x-source-tag://Directory)
    public func remove(_ fileName: String, from directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /// Returns Bool indicating whether file exists at specified directory with specified file name
    ///
    /// - Parameters:
    ///   - fileName: File name to be checked for
    ///   - directory: The [Directory](x-source-tag://Directory) to be checked
    /// - Returns: true or false, depending on the result
    public func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    /// Stores data object to specified directory
    ///
    /// - Parameters:
    ///   - data: The Data object to be stored
    ///   - directory: The [Directory](x-source-tag://Directory) for storing the file
    ///   - fileName: Name of the file
    ///   - result: [StorageResult](x-source-tag://StorageResult)
    public func store(data: Data, to directory: Beaver.Directory = .documents, withFileName fileName: String, completition:@escaping (_ result: StorageResult) -> () = { _ in }) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            let result = StorageResult(success: true, errorMessage: nil, filePath: url, data: data)
            completition(result)
        } catch {
            let result = StorageResult(success: false, errorMessage: error.localizedDescription, filePath: nil, data: nil)
            completition(result)
        }
    }
    
    /// Retrieve data from specified directory
    ///
    /// - Parameters:
    ///   - fileName: Name of the file
    ///   - directory: The [Directory](x-source-tag://Directory) where file is stored
    ///   - result: [StorageResult](x-source-tag://StorageResult)
    public func retrieve(withFileName fileName: String, from directory: Beaver.Directory = .documents, completition:@escaping (_ result: StorageResult) -> ()) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            completition(StorageResult(success: false, errorMessage: "File at path \(url.path) does not exist!", filePath: nil, data: nil))
        } else if let data = FileManager.default.contents(atPath: url.path) {
            completition(StorageResult(success: true, errorMessage: nil, filePath: url, data: data))
        } else {
            completition(StorageResult(success: false, errorMessage: "No data at \(url.path)!", filePath: nil, data: nil))
        }
    }
    
}

