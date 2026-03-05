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

        if age >= 4 && age <= 6 && effectiveAbility == .intermediate {
            let minLen = roundToNearestFive(Double(heightCm) * 0.80)
            let maxLen = roundToNearestFive(Double(heightCm) * 0.85)
            return SkiLengthRange(minCm: minLen, maxCm: maxLen)
        }

        let (minFactor, maxFactor) = alpineMultipliers(age: age, ability: effectiveAbility)
        let minLen = roundToNearestFive(Double(heightCm) * minFactor)
        let maxLen = roundToNearestFive(Double(heightCm) * maxFactor)
        return SkiLengthRange(minCm: minLen, maxCm: maxLen)
    }

    private static func alpineMultipliers(age: Int, ability: AbilityLevel) -> (min: Double, max: Double) {
        if age <= 10 {
            switch ability {
            case .beginner:     return (0.75, 0.85)
            case .intermediate: return (0.85, 0.90)
            case .advanced:     return (0.88, 0.93)
            }
        } else if age <= 12 {
            switch ability {
            case .beginner:     return (0.80, 0.88)
            case .intermediate: return (0.88, 0.93)
            case .advanced:     return (0.92, 0.97)
            }
        } else {
            switch ability {
            case .beginner:     return (0.85, 0.90)
            case .intermediate: return (0.90, 0.95)
            case .advanced:     return (0.95, 1.00)
            }
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

    static func estimatedBSLFromFootLength(footLengthMm: Int) -> Int {
        switch footLengthMm {
        case ...160: return 205
        case 161...170: return 215
        case 171...185: return 225
        case 186...195: return 237
        case 196...205: return 245
        case 206...215: return 257
        case 216...225: return 265
        case 226...235: return 277
        case 236...245: return 285
        case 246...255: return 297
        default: return 305
        }
    }

    static func growthRoomMm(age: Int) -> Int {
        if age < 6 { return 15 }
        if age <= 14 { return 10 }
        return 5
    }

    static func mondoToEUSize(mondoMm: Int) -> String {
        // Based on Head junior boot data, cross-referenced with Wayfinder
        let mondoCm = Double(mondoMm) / 10.0
        switch mondoCm {
        case ..<15.5: return "24"
        case 15.5..<16.0: return "25"
        case 16.0..<16.5: return "25.5"
        case 16.5..<17.0: return "26"
        case 17.0..<17.5: return "27"
        case 17.5..<18.0: return "28"
        case 18.0..<18.5: return "28.5"
        case 18.5..<19.0: return "29"
        case 19.0..<19.5: return "30"
        case 19.5..<20.0: return "31"
        case 20.0..<20.5: return "31.5"
        case 20.5..<21.0: return "32"
        case 21.0..<21.5: return "33"
        case 21.5..<22.0: return "34"
        case 22.0..<22.5: return "34.5"
        case 22.5..<23.0: return "35"
        case 23.0..<23.5: return "35.5"
        case 23.5..<24.0: return "36"
        case 24.0..<24.5: return "37"
        case 24.5..<25.0: return "38"
        case 25.0..<25.5: return "39"
        case 25.5..<26.0: return "40"
        default: return "40+"
        }
    }

    static func estimatedFootLengthFromShoeSize(euSize: Int) -> Int {
        // EU size → approximate foot length (mondo) in mm
        // Standard formula: mondo ≈ (EU + 2) / 1.5 ... but lookup is more reliable for kids
        switch euSize {
        case ...24: return 150
        case 25: return 155
        case 26: return 165
        case 27: return 170
        case 28: return 175
        case 29: return 185
        case 30: return 190
        case 31: return 195
        case 32: return 200
        case 33: return 210
        case 34: return 215
        case 35: return 220
        case 36: return 225
        case 37: return 235
        case 38: return 240
        case 39: return 250
        case 40: return 255
        default: return 260
        }
    }

    static func estimatedFootLengthFromHeight(heightCm: Int) -> Int {
        // Rough estimate: foot length ≈ height * 0.152 for children
        // Rounded to nearest 5mm
        let estimated = Double(heightCm) * 0.152
        return max(Int((estimated * 10 / 5).rounded()) * 5, 100)
    }

    static func recommendedBootSize(footLengthMm: Int, age: Int, confidence: BootSizeConfidence) -> BootSizeRecommendation {
        let growth = growthRoomMm(age: age)
        let recommendedMondo = footLengthMm + growth
        let euSize = mondoToEUSize(mondoMm: recommendedMondo)
        let bsl = estimatedBSLFromFootLength(footLengthMm: footLengthMm)

        return BootSizeRecommendation(
            measuredFootLengthMm: footLengthMm,
            recommendedMondoMm: recommendedMondo,
            growthRoomMm: growth,
            euSize: euSize,
            estimatedBSL: bsl,
            confidence: confidence
        )
    }

    static func bootSizeFromBSL(bslMm: Int, age: Int) -> BootSizeRecommendation {
        // Reverse: BSL → approximate mondo (foot length)
        // This is rough since BSL varies by brand
        let approxMondo: Int
        switch bslMm {
        case ...210: approxMondo = 150
        case 211...220: approxMondo = 165
        case 221...230: approxMondo = 180
        case 231...240: approxMondo = 190
        case 241...250: approxMondo = 200
        case 251...260: approxMondo = 210
        case 261...270: approxMondo = 220
        case 271...280: approxMondo = 230
        case 281...290: approxMondo = 240
        case 291...300: approxMondo = 250
        default: approxMondo = 260
        }
        let euSize = mondoToEUSize(mondoMm: approxMondo)

        return BootSizeRecommendation(
            measuredFootLengthMm: approxMondo,
            recommendedMondoMm: approxMondo,
            growthRoomMm: 0,
            euSize: euSize,
            estimatedBSL: bslMm,
            confidence: .hasBoots
        )
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
