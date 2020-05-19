import Foundation

public struct AppleMusicChartResults: Codable {
    public let results: AppleMusicChart
}

public struct AppleMusicChart: Codable {
    public let albums: [AppleMusicChartAlbum]
}

public struct AppleMusicChartAlbum: Codable {
    public let name: String
    public let chart: String
    public let href: String
    public let next: String
    public let data: [AppleMusicAlbum]
}

public struct AppleMusicAlbumResult: Codable {
    public let data: [AppleMusicAlbum]
}

public enum AppleMusicType: String, Codable {
    case albums
    case artists
    case playlists
    case songs
}

public struct AppleMusicAlbum: Codable {
    public let id: String
    public let type: AppleMusicType
    public let href: String
    public let attributes: AppleMusicAlbumAttributes
    public let relationships: AppleMusicRelationships?
}

public struct AppleMusicAlbumAttributes: Codable {
    public let artwork: AppleMusicArtwork
    public let artistName: String
    public let isSingle: Bool
    public let url: String
    public let isComplete: Bool
    public let genreNames: [String]
    public let trackCount: Int
    public let isMasteredForItunes: Bool
    public let releaseDate: Date
    public let name: String
    public let recordLabel: String
    public let copyright: String
}

public struct AppleMusicArtwork: Codable {
    public let width: Int
    public let height: Int
    public let url: String
    public let bgColor: String?
    public let textColor1: String?
    public let textColor2: String?
    public let textColor3: String?
    public let textColor4: String?
}

public struct AppleMusicRelationships: Codable {
    public let tracks: AppleMusicTrackResult?
    public let artist: AppleMusicArtistResult?
}

public struct AppleMusicTrackResult: Codable {
    public let data: [AppleMusicTrack]
    public let href: String
}

public struct AppleMusicTrack: Codable {
    public let id: String
    public let type: String
    public let href: String
    public let attributes: AppleMusicTrackAttributes
}

public struct AppleMusicTrackAttributes: Codable {
    public let previews: [AppleMusicTrackPreview]
    public let artwork: AppleMusicArtwork
    public let artistName: String
    public let url: String
    public let discNumber: Int?
    public let genreNames: [String]
    public let durationInMillis: Int
    public let releaseDate: Date?
    public let name: String
    public let isrc: String
    public let hasLyrics: Bool?
    public let albumName: String
    public let trackNumber: Int
    public let composerName: String?
}

public struct AppleMusicTrackPreview: Codable {
    public let url: String
}

public struct AppleMusicArtistResult: Codable {
    public let data: [AppleMusicArtist]
    public let href: String
}

public struct AppleMusicArtist: Codable {
    public let id: String
    public let type: AppleMusicType
    public let href: String
}
