import Foundation

enum AbilityLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var dinSkierType: String {
        switch self {
        case .beginner: return "Type I"
        case .intermediate: return "Type II"
        case .advanced: return "Type III"
        }
    }

    var description: String {
        switch self {
        case .beginner:
            return "Just starting out; cautious; mostly on groomed easy runs or flat terrain"
        case .intermediate:
            return "Comfortable on groomed runs; skiing most terrain; moderate speed"
        case .advanced:
            return "Aggressive; skiing all terrain including moguls, off-piste, or racing"
        }
    }
}

enum SkiType: String, Codable, CaseIterable {
    case alpine = "Alpine"
    case xcClassic = "XC Classic"
    case xcSkate = "XC Skate"

    var icon: String {
        switch self {
        case .alpine: return "figure.skiing.downhill"
        case .xcClassic: return "figure.skiing.crosscountry"
        case .xcSkate: return "figure.skating"
        }
    }
}
