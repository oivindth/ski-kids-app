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

    static func roundToNearestFive(_ value: Double) -> Int {
        return Int((value / 5.0).rounded()) * 5
    }

    static func roundToNearestFive(_ value: Int) -> Int {
        return roundToNearestFive(Double(value))
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
            rawMax = heightCm + 15
        case (.age12plus, .intermediate):
            rawMin = heightCm + 15
            rawMax = heightCm + 20
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
        guard age >= 8 else { return nil }

        let rawMin: Double
        let rawMax: Double

        if age >= 8 && age <= 9 {
            switch ability {
            case .beginner:
                rawMin = Double(heightCm)
                rawMax = Double(heightCm + 5)
            case .intermediate, .advanced:
                rawMin = Double(heightCm + 5)
                rawMax = Double(heightCm + 5)
            }
        } else if age >= 10 && age <= 11 {
            switch ability {
            case .beginner:
                rawMin = Double(heightCm + 5)
                rawMax = Double(heightCm + 5)
            case .intermediate:
                rawMin = Double(heightCm) + 7.5
                rawMax = Double(heightCm) + 7.5
            case .advanced:
                rawMin = Double(heightCm + 10)
                rawMax = Double(heightCm + 10)
            }
        } else {
            switch ability {
            case .beginner:
                rawMin = Double(heightCm + 5)
                rawMax = Double(heightCm + 5)
            case .intermediate:
                rawMin = Double(heightCm) + 7.5
                rawMax = Double(heightCm) + 7.5
            case .advanced:
                rawMin = Double(heightCm + 10)
                rawMax = Double(heightCm + 10)
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
            let len = roundToNearestFive(Double(heightCm) * 0.80)
            return SkiLengthRange(minCm: len, maxCm: len)
        }

        switch effectiveAbility {
        case .beginner:
            let minLen = roundToNearestFive(Double(heightCm) * 0.85)
            let maxLen = roundToNearestFive(Double(heightCm) * 0.90)
            return SkiLengthRange(minCm: minLen, maxCm: maxLen)
        case .intermediate:
            let minLen = roundToNearestFive(Double(heightCm) * 0.90)
            let maxLen = roundToNearestFive(Double(heightCm) * 0.95)
            return SkiLengthRange(minCm: minLen, maxCm: maxLen)
        case .advanced:
            let minLen = roundToNearestFive(Double(heightCm) * 0.95)
            let maxLen = roundToNearestFive(Double(heightCm) * 1.00)
            return SkiLengthRange(minCm: minLen, maxCm: maxLen)
        }
    }

    static func alpinePoleLength(heightCm: Int) -> Int {
        return roundToNearestFive(Double(heightCm) * 0.68)
    }

    static func xcClassicPoleLength(heightCm: Int) -> Int {
        return roundToNearestFive(Double(heightCm) * 0.84)
    }

    static func xcSkatePoleLength(heightCm: Int) -> Int {
        return roundToNearestFive(Double(heightCm) * 0.89)
    }

    static func estimatedBSL(fromEUSize euSize: Int) -> Int {
        switch euSize {
        case 15...16: return 150
        case 17...18: return 165
        case 19...20: return 178
        case 21...22: return 192
        case 23...24: return 207
        case 25...26: return 217
        case 27...28: return 228
        case 29...30: return 238
        case 31...32: return 258
        case 33...34: return 268
        case 35...36: return 285
        case 37...38: return 298
        default:
            if euSize < 15 { return 145 }
            return 310
        }
    }

    static func estimatedBSLFromHeight(heightCm: Int) -> Int {
        switch heightCm {
        case ...85:  return 170
        case 86...95: return 185
        case 96...105: return 200
        case 106...115: return 215
        case 116...125: return 235
        case 126...135: return 250
        case 136...145: return 265
        case 146...155: return 280
        case 156...165: return 295
        case 166...175: return 305
        default: return 315
        }
    }
}
