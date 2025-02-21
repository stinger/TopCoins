//
//  URLProtocolMock.swift
//  TopCoins
//
//  Created by Ilian Konchev on 21.02.25.
//

import Foundation

final class URLProtocolMock<T: APIURLMock>: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        for urlMock in T.allCases {
            let mapRequest = urlMock.apiURL.request
            if mapRequest?.url == request.url && mapRequest?.httpMethod == request.httpMethod {
                return true
            }

        }
        return false
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    func mockResponse(for request: URLRequest) -> (HTTPURLResponse, Data?, Error?) {
        var mockFileName: String?
        var wantedResponseCode: Int = 200
        for urlMock in T.allCases {
            let mapRequest = urlMock.apiURL.request
            if mapRequest?.url == request.url && mapRequest?.httpMethod == request.httpMethod {
                mockFileName = urlMock.fileName
                wantedResponseCode = urlMock.responseCode
                break
            }
        }
        guard let mockFileName = mockFileName,
            let url = Bundle.main.url(forResource: mockFileName, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)
            return (response!, nil, APIError.unknown)
        }

        let response = HTTPURLResponse(
            url: request.url!, statusCode: wantedResponseCode, httpVersion: nil, headerFields: nil)
        return (response!, data, nil)
    }

    override func startLoading() {
        let (response, data, error) = mockResponse(for: request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else {
            guard let error = error else {
                client?.urlProtocolDidFinishLoading(self)
                return
            }
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
