//
//  TURequest.swift
//  TestUndabot
//
//  Created by Filip Varda on 13.02.2023..
//
/// https://api.github.com/search/repositories?q=tetris&sort=stars&order=desc

import Foundation

/// Request object that is created with Enpoint, Path Components and Query Parametars
final class GARequest {
    private struct Constants {
        static let baseUrl = "https://api.github.com"
    }

    /// Endpoint returns string to create URL from baseUrl
    /// (Example: "https://api.github.com/search/repositories")
    private let endpoint: GAEndpoint

    /// Path components contains strings to add to "baseUrl  + enpoint"
    /// Example: "https://api.github.com/users/mojombo
    private var pathComponents: [String]

    /// QueryParams contains name and values of params to add to" baseUrl  + enpoint" or "baseUrl + enpoint + pathComponents"
    /// Example: "https://api.github.com/search/repositories?q=tetris&sort=stars&order=desc")
    private var queryParams: [URLQueryItem]

    /// Create urlString from all provided parametars (Example: "https://api.github.com/search/repositories?q=tetris")
    private var urlString: String {
        var string = Constants.baseUrl + "/" + endpoint.rawValue

        if !pathComponents.isEmpty {
            pathComponents.forEach() {
                string += "/\($0)"
            }
        }

        if !queryParams.isEmpty {
            string += "?"
            let argument = queryParams.compactMap { item in
                guard let value = item.value else { return nil }
                return "\(item.name)=\(value)"
            }.joined(separator: "&")
            string += argument
        }

        return string
    }

    /// There are only GET methods on this API. No need for enum
    public let httpMethod = "GET"

    /// Computed URL that is needed to perform a URLRequest
    public var url: URL? {
        return URL(string: urlString)
    }

    // MARK: - Init
    /// Create TURequest with provided enpoint. Path Components and Query Parametars are optional.
    public init(enpoint: GAEndpoint, pathComponents: [String] = [], queryParams: [URLQueryItem] = []) {
        self.endpoint = enpoint
        self.pathComponents = pathComponents
        self.queryParams = queryParams
    }

    /// Create TURequest with provided URL. Provided URL must contain baseUrl
    /// - Parameter url: URL to parse and create path components and query items
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        /// Create pathComponents from urlString
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let endpoint = GAEndpoint(rawValue: endpointString) {
                    self.init(enpoint: endpoint, pathComponents: pathComponents)
                    return
                }
            }
        /// Create queryParams from urlString
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            let endpointString = components[0]
            if let endpoint = GAEndpoint(rawValue: endpointString) {
                let queryParamsString = trimmed.replacingOccurrences(of: endpoint.rawValue + "?", with: "")
                let queryComponents = queryParamsString.components(separatedBy: "&")
                let queryParams: [URLQueryItem] = queryComponents.compactMap { queryComponent in
                    guard queryComponent.contains("=") else {
                        return nil
                    }
                    let parts = queryComponent.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                }
                self.init(enpoint: endpoint, queryParams: queryParams)
                return
            }
        }
        return nil
    }
}
