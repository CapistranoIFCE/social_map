import Foundation

struct UserStory: Codable, Identifiable {
    var id = UUID()
    let identifier: String
    let image: String 
    let contentType: MediaType
    let location: Location

    enum CodingKeys: String, CodingKey {
        case identifier
        case image
        case contentType = "content_type"
        case location
    }
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude: Double
}


extension UserStory {
    static var mocketStories = [
        UserStory(
            identifier: "Laughing",
            image: "friends_laughing",
            contentType: MediaType.image,
            location: Location(latitude: -3.74217, longitude: -38.53488)
        ),
        UserStory(
            identifier: "Climb a Mountain",
            image: "mountain",
            contentType: MediaType.image,
            location: Location(latitude: -3.7365736405651586, longitude: -38.50111281535821)
        ),
        UserStory(
            identifier: "Me and girls",
            image: "three_friends_laughing",
            contentType: MediaType.image,
            location: Location(latitude: -3.7921852010381736, longitude: -38.50188465953605)
        ),
        UserStory(
            identifier: "Beautiful Sunset",
            image: "friends_sunset",
            contentType: MediaType.image,
            location: Location(latitude: -3.7264977742709626, longitude: -38.52656187487842)
        ),
        UserStory(
            identifier: "Beach Sunset",
            image: "sunset_beach",
            contentType: MediaType.image,
            location: Location(latitude: -3.7971866074375087, longitude: -38.56979534530145)
        )
    ]
}

