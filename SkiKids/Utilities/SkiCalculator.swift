import Foundation

enum AgeBracket {
    case under5
    case age5to7
    case age8to11
    case age12plus

    static func from(age: Int) -> AgeBracket {
        if age < 5 { return .under5 }
        if age <= 7 { return .age5to7 }
        if age <= 11 { return .age8to11 }
        return .age12plus
    }
}

struct SkiCalculator {

    static func roundToNearestFive(_ value: Int) -> Int {
        return Int((Double(value) / 5.0).rounded()) * 5
    }

    static func classicXCSkiLength(heightCm: Int, age: Int, ability: AbilityLevel) -> SkiLengthRange {
        let bracket = AgeBracket.from(age: age)
        let (rawMin, rawMax): (Int, Int)

        switch (bracket, ability) {
        case (.under5, _):
            rawMin = heightCm - 5
            rawMax = heightCm
        case (.age5to7, .beginner):
            rawMin = heightCm
            rawMax = heightCm + 5
        case (.age5to7, .intermediate), (.age5to7, .advanced):
            rawMin = heightCm + 5
            rawMax = heightCm + 10
        case (.age8to11, .beginner):
            rawMin = heightCm + 5
            rawMax = heightCm + 10
        case (.age8to11, .intermediate):
            rawMin = heightCm + 10
            rawMax = heightCm + 15
        case (.age8to11, .advanced):
            rawMin = heightCm + 15
            rawMax = heightCm + 20
        case (.age12plus, .beginner):
            rawMin = heightCm + 10
            rawMax = heightCm + 10
        case (.age12plus, .intermediate):
            rawMin = heightCm + 15
            rawMax = heightCm + 15
        case (.age12plus, .advanced):
            rawMin = heightCm + 20
            rawMax = heightCm + 25
        }

        return SkiLengthRange(
            minCm: roundToNearestFive(rawMin),
            maxCm: roundToNearestFive(rawMax)
        )
    }

    static func skateXCSkiLength(heightCm: Int, age: Int, ability: AbilityLevel) -> SkiLengthRange? {
        guard age >= 7 else { return nil }

        let rawMin: Int
        let rawMax: Int

        if age >= 7 && age <= 9 {
            switch ability {
            case .beginner:
                rawMin = heightCm
                rawMax = heightCm + 5
            case .intermediate, .advanced:
                rawMin = heightCm + 5
                rawMax = heightCm + 5
            }
        } else if age >= 10 && age <= 11 {
            switch ability {
            case .beginner:
                rawMin = heightCm + 5
                rawMax = heightCm + 5
            case .intermediate:
                rawMin = Int(Double(heightCm) + 7.5)
                rawMax = Int(Double(heightCm) + 7.5)
            case .advanced:
                rawMin = heightCm + 10
                rawMax = heightCm + 10
            }
        } else {
            switch ability {
            case .beginner:
                rawMin = heightCm + 5
                rawMax = heightCm + 5
            case .intermediate:
                rawMin = Int(Double(heightCm) + 7.5)
                rawMax = Int(Double(heightCm) + 7.5)
            case .advanced:
                rawMin = heightCm + 10
                rawMax = heightCm + 10
            }
        }

        return SkiLengthRange(
            minCm: roundToNearestFive(rawMin),
            maxCm: roundToNearestFive(rawMax)
        )
    }

    static func alpineSkiLength(heightCm: Int, age: Int, ability: AbilityLevel) -> SkiLengthRange {
        var effectiveAbility = ability
        if age <= 6 && ability == .advanced {
            effectiveAbility = .intermediate
        }

        if age <= 3 {
            let minLen = roundToNearestFive(heightCm - 15)
            let maxLen = roundToNearestFive(heightCm - 10)
            return SkiLengthRange(minCm: max(minLen, 50), maxCm: max(maxLen, 55))
        }

        if age >= 4 && age <= 6 && effectiveAbility == .beginner {
            let len = roundToNearestFive(Int(Double(heightCm) * 0.80))
            return SkiLengthRange(minCm: len, maxCm: len)
        }

        switch effectiveAbility {
        case .beginner:
            let minLen = roundToNearestFive(Int(Double(heightCm) * 0.85))
            let maxLen = roundToNearestFive(Int(Double(heightCm) * 0.90))
            return SkiLengthRange(minCm: minLen, maxCm: maxLen)
        case .intermediate:
            let minLen = roundToNearestFive(Int(Double(heightCm) * 0.90))
            let maxLen = roundToNearestFive(Int(Double(heightCm) * 0.95))
            return SkiLengthRange(minCm: minLen, maxCm: maxLen)
        case .advanced:
            let minLen = roundToNearestFive(Int(Double(heightCm) * 0.95))
            let maxLen = roundToNearestFive(Int(Double(heightCm) * 1.00))
            return SkiLengthRange(minCm: minLen, maxCm: maxLen)
        }
    }

    static func alpinePoleLength(heightCm: Int) -> Int {
        let calculated = Double(heightCm) * 0.68
        return roundToNearestFive(Int(calculated))
    }

    static func xcClassicPoleLength(heightCm: Int) -> Int {
        let calculated = Double(heightCm) * 0.83
        return roundToNearestFive(Int(calculated))
    }

    static func xcSkatePoleLength(heightCm: Int) -> Int {
        let calculated = Double(heightCm) * 0.88
        return roundToNearestFive(Int(calculated))
    }

    static func estimatedBSL(fromEUSize euSize: Int) -> Int {
        switch euSize {
        case 15...16: return 157
        case 17...18: return 173
        case 19...20: return 188
        case 21...22: return 203
        case 23...24: return 218
        case 25...26: return 233
        case 27...28: return 248
        case 29...30: return 263
        case 31...32: return 278
        case 33...34: return 293
        case 35...36: return 308
        case 37...38: return 323
        default:
            if euSize < 15 { return 150 }
            return 330
        }
    }
}
