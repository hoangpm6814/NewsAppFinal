//
//  NewsClass.swift
//  News App
//
//  Created by I Am Focused on 12/7/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import Foundation
import MobileCoreServices



enum NewsError: Error {
    case invalidTypeIdentifier
    case invalidNews
}

struct Articles: Codable {
    var articles: [News]
}


//News Structure
class News: NSObject, Serializable {

    public var title: String = ""
    public var author: String?
    public var Description: String?
    public var url: String?
    public var urlToImage: String?
    public var publishedAt: String?
    public var content: String?

    private enum CodingKeys: String, CodingKey {
        case Description = "description"
        case title, author, url, urlToImage, publishedAt, content
    }
}

//Define type of data can be loaded for an item provider

enum NewsUTI {
    static let kUTTypeNews = "kUTTypeNews"
}



extension News: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        [NewsUTI.kUTTypeNews, kUTTypeUTF8PlainText as String]
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        if typeIdentifier == NewsUTI.kUTTypeNews as String {
            completionHandler(self.url?.data(using: .utf8), nil)
        } else if typeIdentifier == kUTTypeUTF8PlainText as String {
            completionHandler(self.url?.data(using: .utf8), nil)

        } else {
            completionHandler(nil, NewsError.invalidNews)
        }
        return nil
    }
}

extension News: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [NewsUTI.kUTTypeNews]
    }

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        if typeIdentifier == NewsUTI.kUTTypeNews {
            let news = News()
            do {
                let listNews = try news.deserialize(data: data)
                return listNews as! Self
            } catch {
                throw NewsError.invalidNews
            }
        } else {
            throw NewsError.invalidTypeIdentifier
        }
    }
}












//Protocol Serializable of Codable

protocol Serializable: Codable {
    func serialize() -> Data?
}

extension Serializable {
    func serialize() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    func deserialize(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}

//End config Protocol Serializable of Codable


enum JSONDecodingError: Error, LocalizedError {
    case unknownError

    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return NSLocalizedString("Unknown Error occured", comment: "")
        }
    }
}

extension DecodingError {
    public var errorDescription: String? {
        switch self {
        case .dataCorrupted(let context):
            return NSLocalizedString(context.debugDescription, comment: "")

        case .keyNotFound(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")

        case .typeMismatch(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")

        case .valueNotFound(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")
        @unknown default:
            return "DecodingError!"
        }
    }
}
