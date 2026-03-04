import Foundation
import Observation

@Observable
final class CalculatorViewModel {
    enum BSLInputMode: Int, CaseIterable {
        case estimate = 0
        case shoeSize = 1
        case bsl = 2

        var label: String {
            switch self {
            case .estimate: return "Estimate"
            case .shoeSize: return "Shoe Size"
            case .bsl: return "BSL"
            }
        }
    }

    var name: String = ""
    var heightCm: Int = 120
    var weightKg: Int = 25
    var age: Int = 8
    var bslMm: Int = 230
    var bslInputMode: BSLInputMode = .estimate
    var shoeSize: Int = 32
    var abilityLevel: AbilityLevel = .beginner
    var selectedSkiTypes: Set<SkiType> = [.alpine]

    var recommendation: SkiRecommendation?
    var hasAttemptedCalculation: Bool = false

    var heightError: String? {
        if heightCm < 60 || heightCm > 200 { return "Height must be 60–200 cm" }
        return nil
    }

    var weightError: String? {
        if weightKg < 8 || weightKg > 80 { return "Weight must be 8–80 kg" }
        return nil
    }

    var ageError: String? {
        if age < 2 || age > 17 { return "Age must be 2–17 years" }
        return nil
    }

    var bslError: String? {
        if bslInputMode == .bsl && (bslMm < 150 || bslMm > 330) {
            return "Boot sole length must be 150–330 mm"
        }
        return nil
    }

    var skiTypeError: String? {
        if selectedSkiTypes.isEmpty { return "Select at least one ski type" }
        return nil
    }

    var validationErrors: [String] {
        var errors: [String] = []
        if heightCm < 60 || heightCm > 200 {
            errors.append("Height must be between 60 and 200 cm.")
        }
        if weightKg < 8 || weightKg > 80 {
            errors.append("Weight must be between 8 and 80 kg.")
        }
        if age < 2 || age > 17 {
            errors.append("Age must be between 2 and 17 years.")
        }
        if bslInputMode == .bsl && (bslMm < 150 || bslMm > 330) {
            errors.append("Boot sole length must be between 150 and 330 mm.")
        }
        if selectedSkiTypes.isEmpty {
            errors.append("Select at least one ski type.")
        }
        return errors
    }

    var isValid: Bool { validationErrors.isEmpty }

    func calculate() {
        hasAttemptedCalculation = true
        guard isValid else { return }

        let effectiveBSL: Int
        var bslEstimationMethod: String? = nil
        if bslInputMode == .bsl {
            effectiveBSL = bslMm
        } else if bslInputMode == .shoeSize {
            effectiveBSL = SkiCalculator.estimatedBSL(fromEUSize: shoeSize)
            bslEstimationMethod = "shoe size (EU \(shoeSize))"
        } else {
            effectiveBSL = SkiCalculator.estimatedBSLFromHeight(heightCm: heightCm)
            bslEstimationMethod = "height (\(heightCm) cm)"
        }

        let skiTypesArray = Array(selectedSkiTypes)
        var globalWarnings = DINCalculator.warnings(for: (
            age: age,
            heightCm: heightCm,
            weightKg: weightKg,
            ability: abilityLevel,
            skiTypes: skiTypesArray
        ))

        let alpineLength: SkiLengthRange? = skiTypesArray.contains(.alpine)
            ? SkiCalculator.alpineSkiLength(heightCm: heightCm, age: age, ability: abilityLevel)
            : nil

        var dinResult: DINResult?
        if skiTypesArray.contains(.alpine) {
            if age <= 3 {
                globalWarnings.append("DIN settings are not calculated for children age 3 and under. Please consult a certified ski school for binding setup.")
            } else {
                let result = DINCalculator.calculate(
                    weightKg: weightKg,
                    heightCm: heightCm,
                    bslMm: effectiveBSL,
                    age: age,
                    ability: abilityLevel
                )
                dinResult = result
                globalWarnings.append(contentsOf: result.warnings)
            }
        }

        let xcClassicLength: SkiLengthRange? = skiTypesArray.contains(.xcClassic)
            ? SkiCalculator.classicXCSkiLength(heightCm: heightCm, age: age, ability: abilityLevel)
            : nil

        let xcSkateLength: SkiLengthRange? = skiTypesArray.contains(.xcSkate)
            ? SkiCalculator.skateXCSkiLength(heightCm: heightCm, age: age, ability: abilityLevel)
            : nil

        let alpinePole: Int? = skiTypesArray.contains(.alpine)
            ? SkiCalculator.alpinePoleLength(heightCm: heightCm)
            : nil

        let xcClassicPole: Int? = skiTypesArray.contains(.xcClassic)
            ? SkiCalculator.xcClassicPoleLength(heightCm: heightCm)
            : nil

        let xcSkatePole: Int? = (skiTypesArray.contains(.xcSkate) && xcSkateLength != nil)
            ? SkiCalculator.xcSkatePoleLength(heightCm: heightCm)
            : nil

        if bslInputMode != .bsl && skiTypesArray.contains(.alpine) {
            if let method = bslEstimationMethod {
                globalWarnings.insert("Boot sole length not provided. BSL was estimated from \(method). Provide the actual Boot Sole Length (printed inside the boot) for accurate DIN results.", at: 0)
            }
        }

        let snapshot = SkiRecommendation.ChildSnapshot(
            name: name,
            heightCm: heightCm,
            weightKg: weightKg,
            age: age,
            abilityLevel: abilityLevel,
            skiTypes: skiTypesArray
        )

        recommendation = SkiRecommendation(
            child: snapshot,
            alpineSkiLength: alpineLength,
            dinResult: dinResult,
            xcClassicLength: xcClassicLength,
            xcSkateLength: xcSkateLength,
            alpinePoleLength: alpinePole,
            xcClassicPoleLength: xcClassicPole,
            xcSkatePoleLength: xcSkatePole,
            warnings: globalWarnings.reduce(into: [String]()) { result, warning in
                if !result.contains(warning) { result.append(warning) }
            },
            calculatedAt: Date()
        )
    }

    func populate(from child: Child) {
        name = child.name
        heightCm = child.heightCm
        weightKg = child.weightKg
        age = child.age

        let mode = BSLInputMode(rawValue: child.bslInputModeRaw ?? 0) ?? .estimate
        bslInputMode = mode
        switch mode {
        case .shoeSize:
            shoeSize = child.shoeSize ?? 32
        case .bsl:
            bslMm = child.bslMm ?? 230
        case .estimate:
            break
        }

        abilityLevel = child.abilityLevel
        selectedSkiTypes = Set(child.skiTypes)
    }

    func reset() {
        name = ""
        heightCm = 120
        weightKg = 25
        age = 8
        bslMm = 230
        bslInputMode = .estimate
        shoeSize = 32
        abilityLevel = .beginner
        selectedSkiTypes = [.alpine]
        recommendation = nil
        hasAttemptedCalculation = false
    }
}
