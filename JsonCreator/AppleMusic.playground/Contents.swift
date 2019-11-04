import Combine
import Foundation
import PlaygroundSupport

let token = "generate your own token from Apple's Developer Portal + Ruby JWT generator"

let chartsURL = "https://api.music.apple.com/v1/catalog/br/charts?types=albums&genre=1153&limit=50"
let albumsAndTracksURL = "https://api.music.apple.com/v1/catalog/br/albums?ids={ids}&include=tracks"

func get(url: String, token: String) -> URLRequest {
    var urlRequest = URLRequest(url: URL(string: url)!)
    urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    urlRequest.httpMethod = "GET"
    return urlRequest
}

func chartsURLRequest(_ url: String, token: String) -> URLRequest {
    get(url: url, token: token)
}

func albumsAndTracksURLRequest(_ url: String, token: String, albumIds: [String]) -> URLRequest {
    get(url: url.replacingOccurrences(of: "{ids}", with: albumIds.joined(separator: ",")), token: token)
}

let cancellable = URLSession
    .shared
    .dataTaskPublisher(for: chartsURLRequest(chartsURL, token: token))
    .twoHundredOrThrow()
    .decode(type: AppleMusicChartResults.self, decoder: JSONDecoder()
        .formatting { date(from: $0, formatters: [.yyyyMMdd, .yyyy]) })
    .flatMap(maxPublishers: .max(1)) {
        URLSession.shared.dataTaskPublisher(for:
            albumsAndTracksURLRequest(
                albumsAndTracksURL,
                token: token,
                albumIds: $0.results.albums.flatMap { $0.data }.map { $0.id }
            )
        )
        .twoHundredOrThrow()
        .decode(type: AppleMusicAlbumResult.self, decoder: JSONDecoder()
            .formatting { date(from: $0, formatters: [.yyyyMMdd, .yyyy]) })
    }
    .map {
        $0.data.map { appleMusicAlbum in
            RaumfeldAlbum(
                id: appleMusicAlbum.id,
                cover: appleMusicAlbum.attributes.artwork.url
                    .replacingOccurrences(of: "{w}", with: "128")
                    .replacingOccurrences(of: "{h}", with: "128"),
                label: appleMusicAlbum.attributes.recordLabel,
                album: appleMusicAlbum.attributes.name,
                artist: appleMusicAlbum.attributes.artistName,
                year: DateFormatter.yyyy.string(from: appleMusicAlbum.attributes.releaseDate),
                tracks: (appleMusicAlbum.relationships?.tracks?.data)?.map { $0.attributes.name } ?? []
            )
        }
    }
.encode(encoder: JSONEncoder.pretty)
    .map { String(data: $0, encoding: .utf8)! }
    .sink(receiveCompletion: { result in
        print("Finished with \(result)")
    }, receiveValue: { response in
        print(response)
    })

PlaygroundPage.current.needsIndefiniteExecution = true
