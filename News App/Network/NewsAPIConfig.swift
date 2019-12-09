//
//  NewsAPIConfig.swift
//  News App
//
//  Created by I Am Focused on 12/6/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import Foundation
import PromiseKit //To get a response step by step


enum NewsAPIConfig {

    //Some of context to get from API
    case articles(source: String)
    case sources(category: String?, language: String?, country: String?)
    case search(query: String)

    static var baseURL = URLComponents(string: "https://newsapi.org")
    static let APIkey = "0e77d9600fa342989f8eb644e6f4450e"



    //URL Config Endpoints
    var url: URL? {
        // Setting each of URL need to get data
        switch self {
            //URL: 'https://newsapi.org/v2/top-headlines?source=bbc-news&apiKey=0e77d9600fa342989f8eb644e6f4450e'
        case .articles(let source):
            NewsAPIConfig.baseURL?.path = "/v2/top-headlines"
            NewsAPIConfig.baseURL?.queryItems = [URLQueryItem(name: "sources", value: source), URLQueryItem(name: "apiKey", value: NewsAPIConfig.APIkey)]

            guard let url = NewsAPIConfig.baseURL?.url else {
                return nil
            }
            print(url)
            return url

            //URL: https://newsapi.org/v2/sources?category=business&language=en&country=usapiKey=0e77d9600fa342989f8eb644e6f4450e
        case .sources(let category, let language, let country):
            NewsAPIConfig.baseURL?.path = "/v2/sources"
            NewsAPIConfig.baseURL?.queryItems = [URLQueryItem(name: "category", value: category),
                                                 URLQueryItem(name: "language", value: language),
                                                 URLQueryItem(name: "country", value: country),
                                                 URLQueryItem(name: "apiKey", value: NewsAPIConfig.APIkey)]

            guard let url = NewsAPIConfig.baseURL?.url else {
                return nil
            }
            print(url)
            return url



            //URL: https://newsapi.org/v2/everything?q=bitcoin&apiKey=0e77d9600fa342989f8eb644e6f4450e
        case .search(let query):
            NewsAPIConfig.baseURL?.path = "/v2/everything"
            NewsAPIConfig.baseURL?.queryItems = [URLQueryItem(name: "q", value: query),
                                                 URLQueryItem(name: "apiKey", value: NewsAPIConfig.APIkey)]

            guard let url = NewsAPIConfig.baseURL?.url else {
                return nil
            }
            print(url)
            return url
        }

    }

    //Get Fetch Image from source of newsapi.org
//    static func getImageURLFromSource(source: String){
//        let ImageURL = ""
//        return
//    }
//

    //Get News articles from /top-headline Endpoint
    static func getNewsItems(source: String) -> Promise<Articles> {
        return Promise { seal in
            guard let URLDetail = NewsAPIConfig.articles(source: source).url else {
                seal.reject(JSONDecodingError.unknownError)
                return
            }
            let baseUrlRequest = URLRequest(url: URLDetail)
            let session = URLSession.shared

            session.dataTask(with: baseUrlRequest) {
                (data, response, error) in

                //Fail with error Case
                guard error == nil else {
                    seal.reject(error!)
                    return
                }
                //Fail with data error Case
                guard let data = data else {
                    seal.reject(error!)
                    return
                }

                //Success
                do {
                    let jsonFromData = try JSONDecoder().decode(Articles.self, from: data)
                    print(jsonFromData)
                    seal.fulfill(jsonFromData)
                } catch DecodingError.dataCorrupted(let context) {
                    seal.reject(DecodingError.dataCorrupted(context))
                } catch DecodingError.keyNotFound(let key, let context) {
                    seal.reject(DecodingError.keyNotFound(key, context))

                } catch DecodingError.typeMismatch(let type, let context) {
                    seal.reject(DecodingError.typeMismatch(type, context))
                } catch DecodingError.valueNotFound(let value, let context) {
                    seal.reject(DecodingError.valueNotFound(value, context))
                } catch {
                    seal.reject(JSONDecodingError.unknownError)
                }
            }.resume()

        }

    }
    //Get News sources from /sources Endpoint
    static func getNewsSource(sourceRequestParams: SourcesRequestParameters)
        -> Promise<Sources> {
            return Promise { seal in
                guard let URLDetail = NewsAPIConfig.sources(category: sourceRequestParams.category, language: sourceRequestParams.language, country: sourceRequestParams.country).url else {
                    seal.reject(JSONDecodingError.unknownError)
                    return
                }
                let baseUrlRequest = URLRequest(url: URLDetail, cachePolicy: .returnCacheDataElseLoad)
                let session = URLSession.shared

                session.dataTask(with: baseUrlRequest) {
                    (data, response, error) in

                    //Fail with error Case
                    guard error == nil else {
                        seal.reject(error!)
                        return
                    }
                    //Fail with data error Case
                    guard let data = data else {
                        seal.reject(error!)
                        return
                    }

                    //Success
                    do {
                        let jsonFromData = try JSONDecoder().decode(Sources.self, from: data)
                        seal.fulfill(jsonFromData)
                    } catch DecodingError.dataCorrupted(let context) {
                        seal.reject(DecodingError.dataCorrupted(context))
                    } catch DecodingError.keyNotFound(let key, let context) {
                        seal.reject(DecodingError.keyNotFound(key, context))
                    } catch DecodingError.typeMismatch(let type, let context) {
                        seal.reject(DecodingError.typeMismatch(type, context))
                    } catch DecodingError.valueNotFound(let value, let context) {
                        seal.reject(DecodingError.valueNotFound(value, context))
                    } catch {
                        seal.reject(JSONDecodingError.unknownError)
                    }
                }.resume()

            }
    }

    //Get News searched from /everything Endpoint

    static func searchNews(query: String) -> Promise<Articles> {
        return Promise { seal in
            guard let URLDetail = NewsAPIConfig.search(query: query).url else {
                seal.reject(JSONDecodingError.unknownError)
                return
            }
            let baseUrlRequest = URLRequest(url: URLDetail, cachePolicy: .reloadIgnoringLocalCacheData)
            let session = URLSession.shared
            print(baseUrlRequest)
            session.dataTask(with: baseUrlRequest) {
                (data, response, error) in


                //Fail with error Case
                guard error == nil else {
                    print("Fail with error Case")
                    print(error!)
                    seal.reject(error!)
                    return
                }
                //Fail with data error Case
                guard let data = data else {
                    print("Fail with data error Case")
                    print(error!)
                    seal.reject(error!)
                    return
                }

                //Success
                do {
                    let jsonFromData = try JSONDecoder().decode(Articles.self, from: data)
                    seal.fulfill(jsonFromData)
                } catch DecodingError.dataCorrupted(let context) {
                    seal.reject(DecodingError.dataCorrupted(context))
                } catch DecodingError.keyNotFound(let key, let context) {
                    seal.reject(DecodingError.keyNotFound(key, context))
                } catch DecodingError.typeMismatch(let type, let context) {
                    seal.reject(DecodingError.typeMismatch(type, context))
                } catch DecodingError.valueNotFound(let value, let context) {
                    seal.reject(DecodingError.valueNotFound(value, context))
                } catch {
                    seal.reject(JSONDecodingError.unknownError)
                }
            }.resume()
        }
    }
}

