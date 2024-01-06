//
//  URLSessionMock.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 06/01/2022.
//

import Foundation

class URLSessionMock: URLSession {

    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    var response: HTTPURLResponse?

    func prepareSession(data: Data?, response: HTTPURLResponse?, error: Error?){
        self.data = data
        self.response = response
        self.error = error
    }

    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let response = self.response
        let error = self.error

        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}

// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTask {

    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
