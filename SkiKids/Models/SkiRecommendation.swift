import Foundation

struct SkiLengthRange {
    let minCm: Int
    let maxCm: Int

    var displayRange: String {
        if minCm == maxCm {
            return "\(minCm) cm"
        }
        return "\(minCm)–\(maxCm) cm"
    }
}

struct DINResult {
    let value: Double
    let code: String
    let skierType: String
    let isJuniorAdjusted: Bool
    let warnings: [String]

    var displayValue: String {
        if value == value.rounded() {
            return String(format: "%.1f", value)
        }
        return String(format: "%.2f", value).replacingOccurrences(of: "0$", with: "", options: .regularExpression)
    }

    var formattedValue: String {
        String(format: "%.2f", value)
    }

    var isHighForJunior: Bool {
        value > 6.0
    }
}

struct PoleRecommendation {
    let lengthCm: Int
    let type: PoleType

    enum PoleType {
        case alpine, xcClassic, xcSkate
        var label: String {
            switch self {
            case .alpine: return "Alpine Poles"
            case .xcClassic: return "XC Classic Poles"
            case .xcSkate: return "XC Skate Poles"
            }
        }
    }
}

struct SkiRecommendation {
    let child: ChildSnapshot
    let alpineSkiLength: SkiLengthRange?
    let dinResult: DINResult?
    let xcClassicLength: SkiLengthRange?
    let xcSkateLength: SkiLengthRange?
    let alpinePoleLength: Int?
    let xcClassicPoleLength: Int?
    let xcSkatePoleLength: Int?
    let warnings: [String]
    let calculatedAt: Date

    struct ChildSnapshot {
        let name: String
        let heightCm: Int
        let weightKg: Int
        let age: Int
        let abilityLevel: AbilityLevel
        let skiTypes: [SkiType]
    }
}
