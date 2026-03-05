import Foundation

enum BSLInputMode: Int, CaseIterable {
    case estimate = 0
    case shoeSize = 1
    case footLength = 2
    case bsl = 3

    var label: String {
        switch self {
        case .estimate: return "Estimate"
        case .shoeSize: return "Shoe Size"
        case .footLength: return "Foot Length"
        case .bsl: return "BSL"
        }
    }
}

struct CalculatorInput {
    let name: String
    let heightCm: Int
    let weightKg: Int
    let age: Int
    let bslMm: Int
    let bslInputMode: BSLInputMode
    let shoeSize: Int
    let footLengthMm: Int
    let abilityLevel: AbilityLevel
    let skiTypes: [SkiType]
}

struct RecommendationEngine {

    static func calculate(input: CalculatorInput) -> SkiRecommendation {
        let effectiveBSL: Int
        var bslEstimationMethod: String? = nil
        if input.bslInputMode == .bsl {
            effectiveBSL = input.bslMm
        } else if input.bslInputMode == .footLength {
            effectiveBSL = SkiCalculator.estimatedBSLFromFootLength(footLengthMm: input.footLengthMm)
            bslEstimationMethod = "foot length (\(String(format: "%.1f", Double(input.footLengthMm) / 10.0)) cm)"
        } else if input.bslInputMode == .shoeSize {
            effectiveBSL = SkiCalculator.estimatedBSL(fromEUSize: input.shoeSize)
            bslEstimationMethod = "shoe size (EU \(input.shoeSize))"
        } else {
            effectiveBSL = SkiCalculator.estimatedBSLFromHeight(heightCm: input.heightCm)
            bslEstimationMethod = "height (\(input.heightCm) cm)"
        }

        var warnings = DINCalculator.warnings(for: (
            age: input.age,
            heightCm: input.heightCm,
            weightKg: input.weightKg,
            ability: input.abilityLevel,
            skiTypes: input.skiTypes
        ))

        let alpineLength: SkiLengthRange? = input.skiTypes.contains(.alpine)
            ? SkiCalculator.alpineSkiLength(heightCm: input.heightCm, age: input.age, ability: input.abilityLevel)
            : nil

        var dinResult: DINResult?
        if input.skiTypes.contains(.alpine) {
            if input.age <= 3 {
                warnings.append("DIN settings are not calculated for children age 3 and under. Please consult a certified ski school for binding setup.")
            } else {
                let result = DINCalculator.calculate(
                    weightKg: input.weightKg,
                    heightCm: input.heightCm,
                    bslMm: effectiveBSL,
                    age: input.age,
                    ability: input.abilityLevel
                )
                dinResult = result
                warnings.append(contentsOf: result.warnings)
            }
        }

        let xcClassicLength: SkiLengthRange? = input.skiTypes.contains(.xcClassic)
            ? SkiCalculator.classicXCSkiLength(heightCm: input.heightCm, age: input.age, ability: input.abilityLevel)
            : nil

        let xcSkateLength: SkiLengthRange? = input.skiTypes.contains(.xcSkate)
            ? SkiCalculator.skateXCSkiLength(heightCm: input.heightCm, age: input.age, ability: input.abilityLevel)
            : nil

        let alpinePole: Int? = input.skiTypes.contains(.alpine)
            ? SkiCalculator.alpinePoleLength(heightCm: input.heightCm)
            : nil

        let xcClassicPole: Int? = input.skiTypes.contains(.xcClassic)
            ? SkiCalculator.xcClassicPoleLength(heightCm: input.heightCm)
            : nil

        let xcSkatePole: Int? = (input.skiTypes.contains(.xcSkate) && xcSkateLength != nil)
            ? SkiCalculator.xcSkatePoleLength(heightCm: input.heightCm)
            : nil

        let bootRecommendation: BootSizeRecommendation
        switch input.bslInputMode {
        case .footLength:
            bootRecommendation = SkiCalculator.recommendedBootSize(
                footLengthMm: input.footLengthMm, age: input.age, confidence: .measured)
        case .shoeSize:
            let footLength = SkiCalculator.estimatedFootLengthFromShoeSize(euSize: input.shoeSize)
            bootRecommendation = SkiCalculator.recommendedBootSize(
                footLengthMm: footLength, age: input.age, confidence: .fromShoeSize)
        case .bsl:
            bootRecommendation = SkiCalculator.bootSizeFromBSL(bslMm: input.bslMm, age: input.age)
        case .estimate:
            let footLength = SkiCalculator.estimatedFootLengthFromHeight(heightCm: input.heightCm)
            bootRecommendation = SkiCalculator.recommendedBootSize(
                footLengthMm: footLength, age: input.age, confidence: .fromHeight)
        }

        if input.bslInputMode != .bsl && input.skiTypes.contains(.alpine) {
            if let method = bslEstimationMethod {
                warnings.insert("Boot sole length not provided. BSL was estimated from \(method). Provide the actual Boot Sole Length (printed inside the boot) for accurate DIN results.", at: 0)
            }
        }

        let snapshot = SkiRecommendation.ChildSnapshot(
            name: input.name,
            heightCm: input.heightCm,
            weightKg: input.weightKg,
            age: input.age,
            abilityLevel: input.abilityLevel,
            skiTypes: input.skiTypes
        )

        return SkiRecommendation(
            child: snapshot,
            alpineSkiLength: alpineLength,
            dinResult: dinResult,
            xcClassicLength: xcClassicLength,
            xcSkateLength: xcSkateLength,
            alpinePoleLength: alpinePole,
            xcClassicPoleLength: xcClassicPole,
            xcSkatePoleLength: xcSkatePole,
            bootSizeRecommendation: bootRecommendation,
            warnings: warnings.reduce(into: [String]()) { result, warning in
                if !result.contains(warning) { result.append(warning) }
            },
            calculatedAt: Date()
        )
    }
}
