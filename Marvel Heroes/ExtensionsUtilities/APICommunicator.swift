//
//  API_Communicator.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 18/11/2021.
//

import CryptoKit
import Foundation

// MARK: - CommunicatorProtocol

protocol CommunicatorProtocol {

    typealias CharacterQueryResult = (Result<CharacterDataWrapper, GError>) -> Void
    typealias DetailsModelQueryResult = (Result<DetailsModel, GError>) -> Void

    func getCharacterData(fromPosition offset:Int, until limit:Int, completion: @escaping CharacterQueryResult)
    func getDetails(character: CharacterModel, completion: @escaping DetailsModelQueryResult)
    func getFilteredCharacterData(fromPosition offset:Int, until limit:Int, withFilter text:String, completion: @escaping CharacterQueryResult)

}

// MARK: - API Communicator

class APICommunicator: CommunicatorProtocol {

    // MARK: Constants

    private enum Constants {

        static let timeStamp = "1"
        static let publicKey = "9a75cdd9b8bc5547cea570d091fd1b00"
        static let privateKey = "785f099a54d7de2605e4df29ca4b3b41f2b46198"
        static let offset: Int = 0
        static let limit: Int = 20
        static let baseURL = "https://gateway.marvel.com:443"
    }

    // MARK: Properties

    private let decoder = JSONDecoder()
    private let dispatchGroup = DispatchGroup()
    private let defaultSession: URLSession

    private var hash: String {
        get{ (Constants.timeStamp + Constants.privateKey + Constants.publicKey).md5Value }
    }

    // MARK: Enum

    enum TypeOfDetail: String {
        case comic = "comics"
        case event = "events"
        case series = "series"
        case story = "stories"
    }

    // MARK: Lifecycle

    init(defaultSession: URLSession = URLSession(configuration: .default)) {
        self.defaultSession = defaultSession
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func getCharacterData(fromPosition offset:Int, until limit:Int, completion: @escaping CharacterQueryResult){

        guard let url = self.generateCharacterURL() else {
            completion(.failure(.invalidURL))
            return
        }

        let task = defaultSession.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try self.decoder.decode(CharacterDataWrapper.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func getDetails(character: CharacterModel, completion: @escaping DetailsModelQueryResult){

        DispatchQueue.global(qos: .default).async {
            var comics:[Comic] = []
            var events:[Event] = []
            var series:[Series] = []
            var stories:[Story] = []

            self.dispatchGroup.enter()
            self.getComicData(character: character){ result in

                switch result {

                case .success(let details):
                    comics = details
                case .failure(let error):
                    print("Search error: " + error.rawValue)
                }
                self.dispatchGroup.leave()
            }

            self.dispatchGroup.enter()
            self.getEventsData(character: character){ result in

                switch result {

                case .success(let details):
                    events = details
                case .failure(let error):
                    print("Search error: " + error.rawValue)
                }
                self.dispatchGroup.leave()
            }

            self.dispatchGroup.enter()
            self.getStoryData(character: character){ result in
                switch result {

                case .success(let details):
                    stories = details
                case .failure(let error):
                    print("Search error: " + error.rawValue)
                }
                self.dispatchGroup.leave()
            }


            self.dispatchGroup.enter()
            self.getSeriesData(character: character){ result in
                switch result {

                case .success(let details):
                    series = details
                case .failure(let error):
                    print("Search error: " + error.rawValue)
                }
                self.dispatchGroup.leave()
            }

            self.dispatchGroup.wait()
            self.dispatchGroup.notify(queue: .main){
                completion(.success(DetailsModel(characterId: character.id, comics: comics, events: events,
                                                 series: series, stories: stories)))
            }
        }
    }

    func getFilteredCharacterData(fromPosition offset:Int, until limit:Int, withFilter text:String, completion: @escaping CharacterQueryResult){

        guard let url = getFilterURLForCharacter(from: offset, until: limit, with: text) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = defaultSession.dataTask(with: url) { data, response, error in

            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decodedData = try self.decoder.decode(CharacterDataWrapper.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}

// MARK: - URL Construction

private extension APICommunicator {

    func buildURL(path: String, with queries:[URLQueryItem] = []) -> URL?{
        var urlComponents = URLComponents(string: Constants.baseURL)
        urlComponents?.path = path
        urlComponents?.queryItems = [.init(name: "ts", value: Constants.timeStamp),
                                     .init(name: "apikey", value: Constants.publicKey),
                                     .init(name: "hash", value: hash)] + queries
        return urlComponents?.url
    }

    func generateCharacterURL(from offset:Int = 0, until limit: Int = 20) -> URL? {

        return buildURL(path: "/v1/public/characters", with: [.init(name: "offset", value: String(offset)),
                                                              .init(name: "limit", value: String(limit))])
    }

    func generateDetailURL(from offset:Int = 0,
                           until limit: Int = 3,
                           with characterId: Int,
                           get typeOfDetail: TypeOfDetail) -> URL? {

        return buildURL(path: "/v1/public/characters/\(characterId)/\(typeOfDetail.rawValue)",
                        with: [.init(name: "offset", value: String(offset)),
                               .init(name: "limit", value: String(limit))])
    }

    func getFilterURLForCharacter(from offset:Int = 0, until limit:Int = 20, with searchText:String) -> URL? {

        return buildURL(path: "/v1/public/characters", with: [.init(name: "nameStartsWith", value: searchText),
                                                              .init(name: "offset", value: String(offset)),
                                                              .init(name: "limit", value: String(limit))])
    }
}

// MARK: - Fetch Details

private extension APICommunicator {

    func getComicData(character: CharacterModel, completion: @escaping (Result<[Comic], GError>) -> Void){

        guard let url = self.generateDetailURL(with: character.id, get: .comic) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = defaultSession.dataTask(with: url) { data, response, error in

            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decodedData = try self.decoder.decode(ComicDataWrapper.self, from: data)
                guard let results = decodedData.data?.results else {
                    completion(.failure(.invalidData))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func getEventsData(character: CharacterModel, completion: @escaping (Result<[Event], GError>) -> Void){

        guard let url = self.generateDetailURL(with: character.id, get: .event) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = defaultSession.dataTask(with: url) { data, response, error in

            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {

                let decodedData = try self.decoder.decode(EventDataWrapper.self, from: data)
                guard let results = decodedData.data?.results else {
                    completion(.failure(.invalidData))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func getSeriesData(character: CharacterModel, completion: @escaping (Result<[Series], GError>) -> Void){

        guard let url = self.generateDetailURL(with: character.id, get: .series) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = defaultSession.dataTask(with: url) { data, response, error in

            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {

                let decodedData = try self.decoder.decode(SeriesDataWrapper.self, from: data)
                guard let results = decodedData.data?.results else {
                    completion(.failure(.invalidData))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func getStoryData(character: CharacterModel, completion: @escaping (Result<[Story], GError>) -> Void){

        guard let url = self.generateDetailURL(with: character.id, get: .story) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = defaultSession.dataTask(with: url) { data, response, error in

            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {

                let decodedData = try self.decoder.decode(StoryDataWrapper.self, from: data)
                guard let results = decodedData.data?.results else {
                    completion(.failure(.invalidData))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
