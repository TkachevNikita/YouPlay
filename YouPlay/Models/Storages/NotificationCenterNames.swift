import Foundation

enum NotificationCenterNames {
    
    static let updatedPlaylists = NSNotification.Name("updatePlaylists")
    
    static let playedSong = NSNotification.Name("playedSong")
    
    static func updatePlaylistWithID(id: UUID) -> NSNotification.Name {
        return NSNotification.Name("updatePlaylist:\(id.uuidString)")
    }
}
