import Foundation

public struct RaumfeldAlbum: Codable {
    public let id: String
    public let cover: String
    public let label: String
    public let album: String
    public let artist: String
    public let year: String
    public let tracks: [String]

    public init(id: String, cover: String, label: String, album: String, artist: String, year: String, tracks: [String]) {
        self.id = id
        self.cover = cover
        self.label = label
        self.album = album
        self.artist = artist
        self.year = year
        self.tracks = tracks
    }
}
