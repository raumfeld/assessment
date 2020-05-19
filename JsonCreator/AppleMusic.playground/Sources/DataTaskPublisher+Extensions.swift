import Combine
import Foundation

extension URLSession.DataTaskPublisher {
    public func twoHundredOrThrow() -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        tryMap { data, resp in
            guard let httpresp = resp as? HTTPURLResponse, httpresp.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            return data
        }
    }
}
