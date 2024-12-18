import Foundation
import Differentiator

protocol MediaFileUIProtocol: Any {
    var id: String { get }
    var title: String { get set }
    var duration: TimeInterval { get set }
    var author: String { get set }
    var imageURL: URL? { get set }
    var uiId: UUID? { get set }
    var playerSpecID: UUID? { get set }
}

struct MediaFile: Codable, MediaFileUIProtocol {
  var playerSpecID: UUID?
  
    var url: String
    var title: String
    var id: String
    var uiId: UUID?
    var duration: TimeInterval
    var author: String
    var videoURL: URL
    var supportsVideo: Bool = false
    var videoDescription: String?
    var imageURL: URL?
}

struct MediaFileUIModel: IdentifiableType, Equatable, MediaFileUIProtocol {
    var playerSpecID: UUID?
    var id: String
    var title: String
    var duration: TimeInterval
    var author: String
    var imageURL: URL?
    var uiId: UUID?
    
    var identity: String {
        get {
            return uiId?.uuidString ?? id
        }
    }
    
    init(model: MediaFileUIProtocol) {
        self.id = model.id
        self.title = model.title
        self.imageURL = model.imageURL
        self.duration = model.duration
        self.author = model.author
        self.uiId = model.uiId
        self.playerSpecID = model.playerSpecID
    }
}
