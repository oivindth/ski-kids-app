import Foundation

struct DINCalculator {

    static func codeFromWeight(_ weightKg: Int) -> DINCode {
        for code in DINCode.allCases {
            if code.weightRange.contains(weightKg) {
                return code
            }
        }
        return .A
    }

    static func adjustCodeForHeight(_ code: DINCode, heightCm: Int) -> DINCode {
        var currentCode = code
        while heightCm > currentCode.heightThreshold {
            guard let next = currentCode.next else { break }
            currentCode = next
        }
        return currentCode
    }

    static func calculate(
        weightKg: Int,
        heightCm: Int,
        bslMm: Int,
        age: Int,
        ability: AbilityLevel
    ) -> DINResult {
        let baseCode = codeFromWeight(weightKg)
        let heightAdjustedCode = adjustCodeForHeight(baseCode, heightCm: heightCm)

        var warnings: [String] = []
        let adjustedCode: DINCode
        if age <= 12 && heightAdjustedCode != baseCode {
            adjustedCode = baseCode
            warnings.append("Height suggests a higher DIN code, but the lower (weight-based) setting was kept for child safety.")
        } else {
            adjustedCode = heightAdjustedCode
        }

        var dinValue = DINTable.lookup(code: adjustedCode, bsl: bslMm, ability: ability)

        var isJuniorAdjusted = false
        var lookupCode = adjustedCode

        if age <= 9 {
            if let previousCode = adjustedCode.previous {
                lookupCode = previousCode
                dinValue = DINTable.lookup(code: lookupCode, bsl: bslMm, ability: ability)
            }
            isJuniorAdjusted = true
        }

        dinValue = min(dinValue, 12.0)

        dinValue = (dinValue * 4).rounded() / 4

        let skierType: String
        switch ability {
        case .beginner: skierType = "Type I"
        case .intermediate: skierType = "Type II"
        case .advanced: skierType = "Type III"
        }

        if dinValue > 6.0 && age <= 12 {
            warnings.append("High DIN setting recommended. This should be verified by a certified ski technician. Some junior bindings do not support settings above 6.")
        }

        if weightKg < 10 {
            warnings.append("Very low weight detected. Verify minimum binding DIN capability with your ski technician.")
        }

        // Junior adjustment info is shown in the DIN detail view, not in the main warnings list

        return DINResult(
            value: dinValue,
            code: lookupCode.rawValue,
            skierType: skierType,
            isJuniorAdjusted: isJuniorAdjusted,
            warnings: warnings
        )
    }

    static func warnings(for child: (age: Int, heightCm: Int, weightKg: Int, ability: AbilityLevel, skiTypes: [SkiType])) -> [String] {
        var warnings: [String] = []

        if child.age <= 3 {
            warnings.append("For children under 3, consult a certified ski school. Sizing varies widely and individual assessment is recommended.")
        }

        if child.skiTypes.contains(.xcSkate) && child.age < 8 {
            warnings.append("Skate skiing is generally recommended for children 8 and older. Classic technique should be learned first.")
        }

        if child.ability == .advanced && child.age <= 6 {
            warnings.append("For children 6 and under, we recommend starting at Intermediate sizing even if ability is advanced, to maintain manoeuvrability.")
        }

        return warnings
    }
}
