import XCTest
@testable import SkiKids

final class RecommendationEngineTests: XCTestCase {

    // MARK: - BSL Resolution

    func testBSLFromDirectInput() {
        let input = makeInput(bslInputMode: .bsl, bslMm: 265)
        let result = RecommendationEngine.calculate(input: input)
        // Should NOT have BSL estimation warning
        XCTAssertFalse(result.warnings.contains { $0.contains("BSL was estimated") })
    }

    func testBSLFromShoeSize_showsWarning() {
        let input = makeInput(bslInputMode: .shoeSize, shoeSize: 32)
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertTrue(result.warnings.contains { $0.contains("shoe size") })
    }

    func testBSLFromHeight_showsWarning() {
        let input = makeInput(bslInputMode: .estimate)
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertTrue(result.warnings.contains { $0.contains("estimated from height") })
    }

    // MARK: - Ski Type Filtering

    func testAlpineOnly() {
        let input = makeInput(skiTypes: [.alpine])
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertNotNil(result.alpineSkiLength)
        XCTAssertNotNil(result.dinResult)
        XCTAssertNotNil(result.alpinePoleLength)
        XCTAssertNil(result.xcClassicLength)
        XCTAssertNil(result.xcSkateLength)
        XCTAssertNil(result.xcClassicPoleLength)
        XCTAssertNil(result.xcSkatePoleLength)
    }

    func testXCClassicOnly() {
        let input = makeInput(skiTypes: [.xcClassic])
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertNil(result.alpineSkiLength)
        XCTAssertNil(result.dinResult)
        XCTAssertNotNil(result.xcClassicLength)
        XCTAssertNotNil(result.xcClassicPoleLength)
    }

    func testXCSkateOnly_age8() {
        let input = makeInput(age: 8, skiTypes: [.xcSkate])
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertNotNil(result.xcSkateLength)
        XCTAssertNotNil(result.xcSkatePoleLength)
    }

    func testXCSkateOnly_age7_noPoles() {
        let input = makeInput(age: 7, skiTypes: [.xcSkate])
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertNil(result.xcSkateLength)
        XCTAssertNil(result.xcSkatePoleLength)
    }

    func testAllSkiTypes() {
        let input = makeInput(age: 10, skiTypes: [.alpine, .xcClassic, .xcSkate])
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertNotNil(result.alpineSkiLength)
        XCTAssertNotNil(result.dinResult)
        XCTAssertNotNil(result.xcClassicLength)
        XCTAssertNotNil(result.xcSkateLength)
    }

    // MARK: - Age ≤ 3 DIN Exception

    func testAge3_noDINCalculated() {
        let input = makeInput(age: 3, skiTypes: [.alpine])
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertNil(result.dinResult)
        XCTAssertNotNil(result.alpineSkiLength)
        XCTAssertTrue(result.warnings.contains { $0.contains("age 3 and under") })
    }

    // MARK: - Child Snapshot

    func testSnapshotMatchesInput() {
        let input = makeInput(name: "Nora", heightCm: 135, weightKg: 30, age: 9)
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertEqual(result.child.name, "Nora")
        XCTAssertEqual(result.child.heightCm, 135)
        XCTAssertEqual(result.child.weightKg, 30)
        XCTAssertEqual(result.child.age, 9)
        XCTAssertEqual(result.child.abilityLevel, .beginner)
    }

    // MARK: - No Duplicate Warnings

    func testNoDuplicateWarnings() {
        let input = makeInput(age: 3, skiTypes: [.alpine, .xcSkate])
        let result = RecommendationEngine.calculate(input: input)
        let uniqueWarnings = Set(result.warnings)
        XCTAssertEqual(result.warnings.count, uniqueWarnings.count, "Duplicate warnings found")
    }

    // MARK: - Foot Length BSL Mode

    func testBSLFromFootLength_showsWarning() {
        let input = makeInput(bslInputMode: .footLength, footLengthMm: 200)
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertTrue(result.warnings.contains { $0.contains("foot length") })
    }

    func testFootLength_bootRecommendationMeasured() {
        let input = makeInput(bslInputMode: .footLength, footLengthMm: 200)
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertEqual(result.bootSizeRecommendation.measuredFootLengthMm, 200)
        XCTAssertEqual(result.bootSizeRecommendation.confidence, .measured)
    }

    func testShoeSize_bootRecommendationFromShoeSize() {
        let input = makeInput(bslInputMode: .shoeSize)
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertEqual(result.bootSizeRecommendation.confidence, .fromShoeSize)
    }

    func testEstimate_bootRecommendationFromHeight() {
        let input = makeInput(bslInputMode: .estimate)
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertEqual(result.bootSizeRecommendation.confidence, .fromHeight)
    }

    func testBSL_bootRecommendationHasBoots() {
        let input = makeInput(bslInputMode: .bsl, bslMm: 258)
        let result = RecommendationEngine.calculate(input: input)
        XCTAssertEqual(result.bootSizeRecommendation.confidence, .hasBoots)
        XCTAssertEqual(result.bootSizeRecommendation.estimatedBSL, 258)
    }

    // MARK: - Helpers

    private func makeInput(
        name: String = "Test",
        heightCm: Int = 130,
        weightKg: Int = 25,
        age: Int = 8,
        bslInputMode: BSLInputMode = .estimate,
        bslMm: Int = 250,
        shoeSize: Int = 32,
        footLengthMm: Int = 200,
        abilityLevel: AbilityLevel = .beginner,
        skiTypes: [SkiType] = [.alpine]
    ) -> CalculatorInput {
        CalculatorInput(
            name: name,
            heightCm: heightCm,
            weightKg: weightKg,
            age: age,
            bslMm: bslMm,
            bslInputMode: bslInputMode,
            shoeSize: shoeSize,
            footLengthMm: footLengthMm,
            abilityLevel: abilityLevel,
            skiTypes: skiTypes
        )
    }
}
