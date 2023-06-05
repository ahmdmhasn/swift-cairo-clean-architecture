import Foundation

enum NetworkError: Error {
    case invalidResponse
    case statusCode(_ invalidStatusCode: Int)
    case serverError(String)
    case networkError(Error)
}

final class URLSessionTwitterAPI: TwitterAPI {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchHomeTimeline() async throws -> [TweetData] {
        let url = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.statusCode(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            let tweets = try decoder.decode([TweetData].self, from: data)
            
            return tweets
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    func postTweet(_ tweet: Tweet) async throws {
        let url = URL(string: "https://api.twitter.com/1.1/statuses/update.json")!
        var request = URLRequest(url: url)
        let parameters = ["text": tweet.text]
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.statusCode(httpResponse.statusCode)
            }
            
            // Check for errors in the response
            let responseString = String(data: data, encoding: .utf8) ?? ""
            if responseString.contains("errors") || responseString.contains("error") {
                throw NetworkError.serverError(responseString)
            }
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
