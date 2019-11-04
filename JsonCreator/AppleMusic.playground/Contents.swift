import Combine
import Foundation
import PlaygroundSupport

let url =  "https://api.music.apple.com/v1/catalog/de/charts?types=albums&genre=1153&limit=50"
let token = "generate your own token from Apple's Developer Portal + Ruby JWT generator"

struct AppleMusicResults: Codable {
    let results: AppleMusicResult
}

struct AppleMusicResult: Codable {
    let albums: [AppleMusicAlbumResult]
}

struct AppleMusicAlbumResult: Codable {
    let name: String
    let chart: String
    let href: String
    let next: String
    let data: [AppleMusicAlbum]
}

enum AppleMusicType: String, Codable {
    case albums
    case playlists
    case songs
}

struct AppleMusicAlbum: Codable {
    let id: String
    let type: AppleMusicType
    let href: String
    let attributes: AppleMusicAlbumAttributes
}

struct AppleMusicAlbumAttributes: Codable {
    let artwork: AppleMusicArtwork
    let artistName: String
    let isSingle: Bool
    let url: String
    let isComplete: Bool
    let genreNames: [String]
    let trackCount: Int
    let isMasteredForItunes: Bool
    let releaseDate: Date
    let name: String
    let recordLabel: String
    let copyright: String
}

struct AppleMusicArtwork: Codable {
    let width: Int
    let height: Int
    let url: String
    let bgColor: String?
    let textColor1: String?
    let textColor2: String?
    let textColor3: String?
    let textColor4: String?
}

struct RaumfeldAlbum: Codable {
    let id: String
    let cover: String
    let label: String
    let album: String
    let artist: String
    let year: String
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static let yyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

var urlRequest = URLRequest(url: URL(string: url)!)
urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
urlRequest.httpMethod = "GET"
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .formatted(.yyyyMMdd)
let prettyEncoder = JSONEncoder()
prettyEncoder.outputFormatting = .prettyPrinted

let cancellable = URLSession
    .shared
    .dataTaskPublisher(for: urlRequest)
    .tryMap { data, resp in
        guard let httpresp = resp as? HTTPURLResponse, httpresp.statusCode == 200 else {
            print("Error: \(resp)")
            throw URLError(.badServerResponse)
        }
        return data
    }
    .decode(type: AppleMusicResults.self, decoder: decoder)
    .map {
        $0.results.albums.flatMap { $0.data }.map { appleMusicAlbum in
            RaumfeldAlbum(
                id: appleMusicAlbum.id,
                cover: appleMusicAlbum.attributes.artwork.url
                    .replacingOccurrences(of: "{w}", with: "128")
                    .replacingOccurrences(of: "{h}", with: "128"),
                label: appleMusicAlbum.attributes.recordLabel,
                album: appleMusicAlbum.attributes.name,
                artist: appleMusicAlbum.attributes.artistName,
                year: DateFormatter.yyyy.string(from: appleMusicAlbum.attributes.releaseDate)
            )
        }
    }
    .encode(encoder: prettyEncoder)
    .map { String(data: $0, encoding: .utf8)! }
    .sink(receiveCompletion: { result in
        print("Finished with \(result)")
    }, receiveValue: { response in
        print(response)
    })

PlaygroundPage.current.needsIndefiniteExecution = true
