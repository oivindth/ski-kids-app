import Foundation
import Observation

@Observable
final class CalculatorViewModel {
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
        if heightCm < 60 || heightCm > 210 { return "Height must be 60–210 cm" }
        return nil
    }

    var weightError: String? {
        if weightKg < 8 || weightKg > 120 { return "Weight must be 8–120 kg" }
        return nil
    }

    var ageError: String? {
        if age < 2 || age > 99 { return "Age must be 2–99 years" }
        return nil
    }

    var bslError: String? {
        if bslInputMode == .bsl && (bslMm < 150 || bslMm > 380) {
            return "Boot sole length must be 150–380 mm"
        }
        return nil
    }

    var skiTypeError: String? {
        if selectedSkiTypes.isEmpty { return "Select at least one ski type" }
        return nil
    }

    var validationErrors: [String] {
        var errors: [String] = []
        if heightCm < 60 || heightCm > 210 {
            errors.append("Height must be between 60 and 210 cm.")
        }
        if weightKg < 8 || weightKg > 120 {
            errors.append("Weight must be between 8 and 120 kg.")
        }
        if age < 2 || age > 99 {
            errors.append("Age must be between 2 and 99 years.")
        }
        if bslInputMode == .bsl && (bslMm < 150 || bslMm > 380) {
            errors.append("Boot sole length must be between 150 and 380 mm.")
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

        let input = CalculatorInput(
            name: name,
            heightCm: heightCm,
            weightKg: weightKg,
            age: age,
            bslMm: bslMm,
            bslInputMode: bslInputMode,
            shoeSize: shoeSize,
            abilityLevel: abilityLevel,
            skiTypes: Array(selectedSkiTypes)
        )

        recommendation = RecommendationEngine.calculate(input: input)
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
