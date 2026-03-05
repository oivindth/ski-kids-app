import Foundation
import SwiftData

@Model
final class Child {
    var id: UUID
    var name: String
    var heightCm: Int
    var weightKg: Int
    var age: Int
    var bslMm: Int?
    var bslInputModeRaw: Int?
    var shoeSize: Int?
    var footLengthMm: Int?
    var abilityLevel: AbilityLevel
    var skiTypes: [SkiType]
    var lastCalculated: Date?
    var createdAt: Date

    init(
        name: String,
        heightCm: Int,
        weightKg: Int,
        age: Int,
        bslMm: Int? = nil,
        bslInputModeRaw: Int? = nil,
        shoeSize: Int? = nil,
        footLengthMm: Int? = nil,
        abilityLevel: AbilityLevel = .beginner,
        skiTypes: [SkiType] = [.alpine]
    ) {
        self.id = UUID()
        self.name = name
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.age = age
        self.bslMm = bslMm
        self.bslInputModeRaw = bslInputModeRaw
        self.shoeSize = shoeSize
        self.footLengthMm = footLengthMm
        self.abilityLevel = abilityLevel
        self.skiTypes = skiTypes
        self.lastCalculated = nil
        self.createdAt = Date()
    }
}
