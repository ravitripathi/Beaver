# Beaver

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub release](https://img.shields.io/github/v/tag/ravitripathi/Beaver?label=release)](https://github.com/ravitripathi/Beaver/releases)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Beaver.svg)](https://img.shields.io/cocoapods/v/Beaver.svg)
[![License](https://img.shields.io/github/license/ravitripathi/Beaver)](https://raw.githubusercontent.com/ravitripathi/Beaver/master/LICENSE)

<p align="center">
<img align="middle" src="https://raw.githubusercontent.com/ravitripathi/Beaver/master/updatedIcon.png" width="250" height="250"/>
</p>

## Beaver is an easy to use, file persistence micro-library for iOS

Beaver allows you to store files in an elegant manner. An extension over Codable classes allows storing and retrieving JSON files with ease.

## Installation

### Carthage
Add the following line to your [Cartfile](https://github.com/Carthage/Carthage)

```github "ravitripathi/Beaver"```

### Cocoapods
Add the following line to your [Podfile](https://cocoapods.org/pods/Beaver)

```pod 'Beaver', '~> 1.1'```

## Storing and Retrieving Data

Storing files is as easy as calling :

```swift
Beaver.default.store(data: data, to: .documents, withFileName: "Filename") { (result) in
    // Utilize the result callback if needed
}
```

And fetching files can be done by:

```swift
Beaver.default.retrieve(withFileName: "Filename", from directory: .documents) { (result) in
    // Utilize the result callback if needed
}
```

## Storage Result

Upon storing or retrieving files, a `StorageResult` callback is obtained, which contains the following metadata:

- A boolean `success` flag
- `errorMessage` string
- `filePath` URL object
- `data`: The data object for the item being read or written

By performing exception handling performed under the hood, all you need to deal with are callback parameters.

## Codable Extension

Beaver provides extensions for Codable objects.

For example, consider the following codable class:

```swift
class User: Codable {
    var name: String?
    var email: String?
    ....
}
```

An object for this class can be stored directly:

```swift
    var userModel: User
    userModel.store(to: .documents, withFileName: "CurrentUser") { (result) in
            if result.success {
                self.statusLabel.text = "The json file was saved in \(result.filePath!)"
            } else {
                self.statusLabel.text = result.errorMessage
            }
        }
```

And for retrieval:

```swift
userModel.retrieve(withFileName: "CurrentUser", from: .documents) { (result) in
            if result.success {
                //Utilize the retrived data via result.data 
            } else {
                print(result.errorMessage))
            }
        }
```

By calling ```yourCodableObject.store()``` directly, the contents of the object are stored in a file named ```yourCodableClass``` in the documents directory, which can then be retrieved later by calling ```yourCodableObject.retrieve()``` directly.