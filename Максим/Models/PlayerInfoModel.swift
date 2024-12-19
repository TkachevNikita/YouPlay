import Foundation

struct PlayerInfo: Codable {
    var storage: [MediaFile]
    var unmodifiedStorage: [MediaFile]?
    var currentIndex: Int
    var currentTime: Double
    var duration: Double
    var isRandomized: Bool
}
