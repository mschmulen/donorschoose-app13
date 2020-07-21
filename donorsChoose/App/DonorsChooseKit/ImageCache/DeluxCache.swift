//
//  DeluxCache.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public typealias ImageKey = String

internal let staticCache = DeluxCache<String,UIImage>()

// reference https://www.swiftbysundell.com/articles/caching-in-swift/
// https://medium.com/@NilStack/swift-world-write-our-own-cache-part-3-memory-cache-and-disk-cache-7056948eb52c

// https://github.com/hyperoslo/Cache/blob/master/Source/Shared/Storage/DiskStorage.swift

/// DeluxCache
internal final class DeluxCache<Key: Hashable, Value> {
    
    // this will turn on and off the local file cache and force in memory only
    private var enableFileCache = true
    
    // Local storage configuration
    // ------------------------
    /// diskStoragePrefix folder for the DeluxCache persistance `Library/Caches/{diskStoragePrefx}`
    private let diskStoragePrefix = "DeluxCache"
    private let cacheName = "ImageCache"
    private let fileManager: FileManager
    private let cacheFilePath: URL
    
    // TODO evaluate write DispatchQueue for performance
//    public fileprivate(set) var writeQueue: DispatchQueue
//    public fileprivate(set) var readQueue: DispatchQueue
    private var writeQueue: DispatchQueue
    private var readQueue: DispatchQueue
    // ------------------------
    
    private let wrapped = NSCache<WrappedKey, Entry>()
    
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()
    
    init(
        dateProvider: @escaping () -> Date = Date.init,
        entryLifetime: TimeInterval = 12 * 60 * 60,
        maximumEntryCount: Int = 50,
        fileManager: FileManager = FileManager.default
    ) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        wrapped.countLimit = maximumEntryCount
        wrapped.delegate = keyTracker
        
        // --------------------
        // configure the file stuff
        
        self.writeQueue = DispatchQueue(
            label: "\(diskStoragePrefix).\(cacheName).WriteQueue",
            attributes: []
        )
        self.readQueue = DispatchQueue(
            label: "\(diskStoragePrefix).\(cacheName).ReadQueue",
            attributes: []
        )
        
        self.fileManager = fileManager
        
        // MAS TODO make the base path configurable, .cachesDirectory or ,documentDirectory   FileManager.SearchPathDirectory
        
        // let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let firstPath = paths.first!
        cacheFilePath = firstPath.appendingPathComponent("\(diskStoragePrefix)")
        
        // MAS TODO if you are unable to do this then enableFileCache = false
        try! fileManager.createDirectory(
            atPath: cacheFilePath.path,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(
            key: key,
            value: value,
            expirationDate: dateProvider().addingTimeInterval(entryLifetime)
        )
        wrapped.setObject(entry, forKey: WrappedKey(key))
        keyTracker.keys.insert(key)

        // MAS TODO remove this
//            writeEntryToDisk(entry: entry)
    }
    
    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }

//        guard dateProvider() < entry.expirationDate else {
//            // Discard values that have expired
//            removeValue(forKey: key)
//            return nil
//        }
        
        return entry.value
    }

    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
}


private extension DeluxCache {
    
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
}

private extension DeluxCache {
    
    final class Entry {
        
        let key: Key
        let value: Value
        
        // MAS TODO suport expirationDate
//        let expirationDate: Date
        
        init( key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
//            self.expirationDate = expirationDate
        }
    }
}

extension DeluxCache {
    
    subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

private extension DeluxCache {
    
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()

        func cache(
            _ cache: NSCache<AnyObject, AnyObject>,
            willEvictObject object: Any
        ) {
            guard let entry = object as? Entry else {
                return
            }
            keys.remove(entry.key)
        }
    }
}

extension DeluxCache.Entry: Codable where Key: Codable, Value: Codable {}

private extension DeluxCache {
    
    func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }

//        guard dateProvider() < entry.expirationDate else {
//            removeValue(forKey: key)
//            return nil
//        }

        return entry
    }
    
    func insert(_ entry: Entry) {
        wrapped.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
}


/// Mark Internal file storage read and writes
extension DeluxCache {
    
    // https://www.hackingwithswift.com/example-code/strings/how-to-convert-a-string-to-a-safe-format-for-url-slugs-and-filenames
    // TODO Hash a URL to string
//    func mapURLToFileKey(key:ImageKey) -> String {
//        print( "key \(key)")
//
//        let outKey = "yack"
//        return outKey
//    }
    
    public func writeToFileStorage(key: ImageKey, image:UIImage ) {
        
        if enableFileCache == false { return }
        // todo spin this out in the self.writeQueue
        
        let fullDestinationFilePath = cacheFilePath.appendingPathComponent("/\(key).jpg")
        
        if fileManager.fileExists(atPath: fullDestinationFilePath.path) {
            // it already exists so bail out, this should incorporate expiration date at some time but its not important now
            return
        }
        if let image = image as? UIImage {
            if let jpgImageData = image.jpegData(compressionQuality: 1.0) {
                do {
                    try jpgImageData.write(to: fullDestinationFilePath)
                    print("DeluxCache.writeToFileStorage \(key)")
                } catch {
                    return
                    // fatalError("DeluxCache.writeEntryToDisk unable to write to \(fullDestinationFilePath)")
                }
            }
        }
    }
    
    public func readFromFileStorage(key: ImageKey) -> UIImage? {

        if enableFileCache == false { return nil}
        
        let fullDestinationFilePath = cacheFilePath.appendingPathComponent("/\(key).jpg")
        
        if fileManager.fileExists(atPath: fullDestinationFilePath.path), let image = UIImage(contentsOfFile: fullDestinationFilePath.path) {
            print("DeluxCache.readFromFileStorage \(key)")
            return image
        }
        return nil
    }
    
    public func removeAllFromFile() {
        do {
            // this removes the folders which you probably dont want to do
             try fileManager.removeItem(atPath: cacheFilePath.path)
        }
        catch let error {
            print("error: \(error)")
        }
    }
}

// MAS TODO use this instad of the static DeluxCache<String,UIImage>()
struct DeluxCacheKey: EnvironmentKey {
    static let defaultValue: DeluxCache<String,UIImage> = DeluxCache<String,UIImage>()
}

extension EnvironmentValues {
    var deluxImageCache: DeluxCache<String,UIImage> {
        get {
            self[DeluxCacheKey.self]
        }
        set {
            self[DeluxCacheKey.self] = newValue
        }
    }
}










// Save the DeluxCache as a full bob which is not so usefull as its better to save it as atomic files
//extension DeluxCache: Codable where Key: Codable, Value: Codable {
//
//    convenience init(from decoder: Decoder) throws {
//        self.init()
//
//        let container = try decoder.singleValueContainer()
//        let entries = try container.decode([Entry].self)
//        entries.forEach(insert)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(keyTracker.keys.compactMap(entry))
//    }
//}
//
//extension DeluxCache where Key: Codable, Value: Codable {
//
//    func saveToDisk(
//        withName name: String,
//        using fileManager: FileManager = .default
//    ) throws {
//        let folderURLs = fileManager.urls(
//            for: .cachesDirectory,
//            in: .userDomainMask
//        )
//
//        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
//        let data = try JSONEncoder().encode(self)
//        try data.write(to: fileURL)
//    }
//}

