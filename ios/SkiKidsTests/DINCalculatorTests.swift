import XCTest
@testable import SkiKids

final class DINCalculatorTests: XCTestCase {

    // MARK: - Weight to Code

    func testCodeFromWeight() {
        XCTAssertEqual(DINCalculator.codeFromWeight(10), .A)
        XCTAssertEqual(DINCalculator.codeFromWeight(13), .A)
        XCTAssertEqual(DINCalculator.codeFromWeight(14), .B)
        XCTAssertEqual(DINCalculator.codeFromWeight(25), .D)
        XCTAssertEqual(DINCalculator.codeFromWeight(50), .I)
        XCTAssertEqual(DINCalculator.codeFromWeight(95), .M)
        XCTAssertEqual(DINCalculator.codeFromWeight(150), .M)
    }

    func testCodeFromWeight_belowMinimum() {
        // Weight below 10kg falls through to default .A
        XCTAssertEqual(DINCalculator.codeFromWeight(5), .A)
    }

    // MARK: - Height Adjustment

    func testHeightAdjustment_noChange() {
        // Code D threshold is 148, height 130 ≤ 148 → stays D
        let result = DINCalculator.adjustCodeForHeight(.D, heightCm: 130)
        XCTAssertEqual(result, .D)
    }

    func testHeightAdjustment_singleStep() {
        // Code E threshold is 148, height 150 > 148 → adjusts to F (threshold 157)
        let result = DINCalculator.adjustCodeForHeight(.E, heightCm: 150)
        XCTAssertEqual(result, .F)
    }

    func testHeightAdjustment_multipleSteps() {
        // Code C threshold 148, height 170 exceeds C(148), D(148), E(148), F(157), G(166) → H(174)
        let result = DINCalculator.adjustCodeForHeight(.C, heightCm: 170)
        XCTAssertEqual(result, .H)
    }

    // MARK: - Full DIN Calculation

    func testCLAUDEmd_testCase() {
        // Child 25kg, 130cm, age 8, beginner → Code D, junior adjusted to Code C
        let result = DINCalculator.calculate(
            weightKg: 25, heightCm: 130, bslMm: 250, age: 8, ability: .beginner
        )
        XCTAssertEqual(result.code, "C")
        XCTAssertTrue(result.isJuniorAdjusted)
        XCTAssertEqual(result.skierType, "Type I")
        // Code C, BSL ≤250, Type I → 1.50
        XCTAssertEqual(result.value, 1.50)
    }

    func testChildSafetyException_keepsLowerCode() {
        // 20kg → Code C, height 155 exceeds threshold → would adjust to F
        // But age 11 ≤ 12, so keeps Code C
        let result = DINCalculator.calculate(
            weightKg: 20, heightCm: 155, bslMm: 235, age: 11, ability: .beginner
        )
        XCTAssertEqual(result.code, "C")
        XCTAssertFalse(result.isJuniorAdjusted)  // age 11 > 9
        XCTAssertTrue(result.warnings.contains { $0.contains("weight-based") })
    }

    func testAdult_heightAdjustmentApplied() {
        // 20kg → Code C, height 170 → adjusts to H for adult (age 20, not ≤12)
        let result = DINCalculator.calculate(
            weightKg: 20, heightCm: 170, bslMm: 260, age: 20, ability: .intermediate
        )
        XCTAssertEqual(result.code, "H")
        XCTAssertFalse(result.isJuniorAdjusted)
    }

    func testJuniorAdjustment_age9() {
        // 30kg → Code E, age 9 → junior shifts to D
        let result = DINCalculator.calculate(
            weightKg: 30, heightCm: 130, bslMm: 250, age: 9, ability: .intermediate
        )
        XCTAssertEqual(result.code, "D")
        XCTAssertTrue(result.isJuniorAdjusted)
        // Code D, BSL ≤250, Type II → 2.50
        XCTAssertEqual(result.value, 2.50)
    }

    func testJuniorAdjustment_age10NotApplied() {
        // 30kg → Code E, age 10 → no junior adjustment
        let result = DINCalculator.calculate(
            weightKg: 30, heightCm: 130, bslMm: 250, age: 10, ability: .intermediate
        )
        XCTAssertEqual(result.code, "E")
        XCTAssertFalse(result.isJuniorAdjusted)
        // Code E, BSL ≤250, Type II → 3.00
        XCTAssertEqual(result.value, 3.00)
    }

    func testJuniorAdjustment_codeA_cannotGoLower() {
        // 10kg → Code A, age 8 → junior tries previous but A has no previous
        let result = DINCalculator.calculate(
            weightKg: 10, heightCm: 100, bslMm: 200, age: 8, ability: .beginner
        )
        XCTAssertEqual(result.code, "A")
        XCTAssertTrue(result.isJuniorAdjusted)
        // Code A, BSL ≤250, Type I → 0.75
        XCTAssertEqual(result.value, 0.75)
    }

    func testDINCappedAt12() {
        // Heavy adult, large BSL, advanced → should cap at 12.0
        let result = DINCalculator.calculate(
            weightKg: 100, heightCm: 185, bslMm: 340, age: 30, ability: .advanced
        )
        XCTAssertEqual(result.value, 12.0)
    }

    func testHighDINWarningForChild() {
        // 45kg → Code H, age 11, advanced, large BSL
        let result = DINCalculator.calculate(
            weightKg: 45, heightCm: 155, bslMm: 280, age: 11, ability: .advanced
        )
        // Code H, BSL 271-290, Type III → 7.50
        // But age 11 ≤ 12, height 155 ≤ 174 → no height adjustment
        XCTAssertTrue(result.value > 6.0)
        XCTAssertTrue(result.warnings.contains { $0.contains("junior bindings") })
    }

    func testLowWeightWarning() {
        let result = DINCalculator.calculate(
            weightKg: 8, heightCm: 90, bslMm: 170, age: 5, ability: .beginner
        )
        XCTAssertTrue(result.warnings.contains { $0.contains("Very low weight") })
    }

    func testRoundingToQuarter() {
        // Verify the rounding step works (all table values are already in 0.25 increments,
        // so this mainly guards against future changes)
        let result = DINCalculator.calculate(
            weightKg: 25, heightCm: 125, bslMm: 250, age: 12, ability: .beginner
        )
        // Code D, BSL ≤250, Type I → 2.00
        let remainder = result.value.truncatingRemainder(dividingBy: 0.25)
        XCTAssertEqual(remainder, 0.0, accuracy: 0.001)
    }

    // MARK: - Warnings

    func testWarnings_age3() {
        let warnings = DINCalculator.warnings(for: (
            age: 3, heightCm: 95, weightKg: 14, ability: .beginner, skiTypes: [.alpine]
        ))
        XCTAssertTrue(warnings.contains { $0.contains("under 3") })
    }

    func testWarnings_skateUnder8() {
        let warnings = DINCalculator.warnings(for: (
            age: 7, heightCm: 120, weightKg: 22, ability: .beginner, skiTypes: [.xcSkate]
        ))
        XCTAssertTrue(warnings.contains { $0.contains("8 and older") })
    }

    func testWarnings_advancedAge6() {
        let warnings = DINCalculator.warnings(for: (
            age: 6, heightCm: 115, weightKg: 20, ability: .advanced, skiTypes: [.alpine]
        ))
        XCTAssertTrue(warnings.contains { $0.contains("Intermediate sizing") })
    }

    func testWarnings_noWarningsForTypicalChild() {
        let warnings = DINCalculator.warnings(for: (
            age: 10, heightCm: 140, weightKg: 35, ability: .intermediate, skiTypes: [.alpine]
        ))
        XCTAssertTrue(warnings.isEmpty)
    }
}
