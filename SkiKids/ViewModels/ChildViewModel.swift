import Foundation
import SwiftData
import Observation

@Observable
final class ChildViewModel {
    var isAddingChild: Bool = false
    var editingChild: Child?

    func deleteChild(_ child: Child, from context: ModelContext) {
        context.delete(child)
        try? context.save()
    }

    func saveChild(
        _ child: Child?,
        name: String,
        heightCm: Int,
        weightKg: Int,
        age: Int,
        bslMm: Int?,
        abilityLevel: AbilityLevel,
        skiTypes: [SkiType],
        context: ModelContext
    ) {
        if let existing = child {
            existing.name = name
            existing.heightCm = heightCm
            existing.weightKg = weightKg
            existing.age = age
            existing.bslMm = bslMm
            existing.abilityLevel = abilityLevel
            existing.skiTypes = skiTypes
        } else {
            let newChild = Child(
                name: name,
                heightCm: heightCm,
                weightKg: weightKg,
                age: age,
                bslMm: bslMm,
                abilityLevel: abilityLevel,
                skiTypes: skiTypes
            )
            context.insert(newChild)
        }
        try? context.save()
    }

    func updateLastCalculated(for child: Child, context: ModelContext) {
        child.lastCalculated = Date()
        try? context.save()
    }
}
