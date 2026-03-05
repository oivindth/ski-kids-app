import XCTest
@testable import SkiKids

final class SkiCalculatorTests: XCTestCase {

    // MARK: - Rounding

    func testRoundToNearestFive() {
        XCTAssertEqual(SkiCalculator.roundToNearestFive(102.0), 100)
        XCTAssertEqual(SkiCalculator.roundToNearestFive(103.0), 105)
        XCTAssertEqual(SkiCalculator.roundToNearestFive(107.5), 110)
        XCTAssertEqual(SkiCalculator.roundToNearestFive(100.0), 100)
        XCTAssertEqual(SkiCalculator.roundToNearestFive(112.4), 110)
        XCTAssertEqual(SkiCalculator.roundToNearestFive(112.5), 115)
    }

    func testRoundToNearestFiveInt() {
        XCTAssertEqual(SkiCalculator.roundToNearestFive(102), 100)
        XCTAssertEqual(SkiCalculator.roundToNearestFive(103), 105)
        XCTAssertEqual(SkiCalculator.roundToNearestFive(100), 100)
    }

    // MARK: - Alpine Ski Length

    func testAlpineAge3OrUnder_usesLearnerFormula() {
        let result = SkiCalculator.alpineSkiLength(heightCm: 95, age: 3, ability: .beginner)
        XCTAssertEqual(result.minCm, 80)  // 95-15=80
        XCTAssertEqual(result.maxCm, 85)  // 95-10=85
    }

    func testAlpineAge3_minimumFloor() {
        let result = SkiCalculator.alpineSkiLength(heightCm: 60, age: 2, ability: .beginner)
        XCTAssertEqual(result.minCm, 50)  // floor
        XCTAssertEqual(result.maxCm, 55)  // floor
    }

    func testAlpineAge4to6Beginner_uses080() {
        let result = SkiCalculator.alpineSkiLength(heightCm: 110, age: 5, ability: .beginner)
        // 110 * 0.80 = 88 → round to 90
        XCTAssertEqual(result.minCm, 90)
        XCTAssertEqual(result.maxCm, 90)
    }

    func testAlpineAge5Intermediate_uses080to085() {
        // Age 4-6 intermediate: 0.80–0.85
        let result = SkiCalculator.alpineSkiLength(heightCm: 110, age: 5, ability: .intermediate)
        // 110 * 0.80 = 88 → 90, 110 * 0.85 = 93.5 → 95
        XCTAssertEqual(result.minCm, 90)
        XCTAssertEqual(result.maxCm, 95)
    }

    func testAlpineAge6Advanced_downgradedToIntermediate() {
        let result = SkiCalculator.alpineSkiLength(heightCm: 115, age: 6, ability: .advanced)
        // Effective ability = intermediate, hits 4-6 intermediate: 0.80-0.85
        // 115 * 0.80 = 92 → 90, 115 * 0.85 = 97.75 → 100
        XCTAssertEqual(result.minCm, 90)
        XCTAssertEqual(result.maxCm, 100)
    }

    func testAlpineAge7Beginner_kidBracketBoundary() {
        // Age 7 is the first age in the 7-10 bracket
        let result = SkiCalculator.alpineSkiLength(heightCm: 120, age: 7, ability: .beginner)
        // 120 * 0.75 = 90, 120 * 0.85 = 102 → 100
        XCTAssertEqual(result.minCm, 90)
        XCTAssertEqual(result.maxCm, 100)
    }

    func testAlpineAge8Beginner_usesKidMultipliers() {
        // Age 7-10 beginner: 0.75–0.85
        let result = SkiCalculator.alpineSkiLength(heightCm: 130, age: 8, ability: .beginner)
        // 130 * 0.75 = 97.5 → 100, 130 * 0.85 = 110.5 → 110
        XCTAssertEqual(result.minCm, 100)
        XCTAssertEqual(result.maxCm, 110)
    }

    func testAlpineAge9Intermediate_usesKidMultipliers() {
        // Age 7-10 intermediate: 0.85–0.90
        let result = SkiCalculator.alpineSkiLength(heightCm: 135, age: 9, ability: .intermediate)
        // 135 * 0.85 = 114.75 → 115, 135 * 0.90 = 121.5 → 120
        XCTAssertEqual(result.minCm, 115)
        XCTAssertEqual(result.maxCm, 120)
    }

    func testAlpineAge10Advanced_usesKidMultipliers() {
        // Age 7-10 advanced: 0.88–0.93
        let result = SkiCalculator.alpineSkiLength(heightCm: 140, age: 10, ability: .advanced)
        // 140 * 0.88 = 123.2 → 125, 140 * 0.93 = 130.2 → 130
        XCTAssertEqual(result.minCm, 125)
        XCTAssertEqual(result.maxCm, 130)
    }

    func testAlpineAge11Beginner_usesPreteenMultipliers() {
        // Age 11-12 beginner: 0.80–0.88
        let result = SkiCalculator.alpineSkiLength(heightCm: 145, age: 11, ability: .beginner)
        // 145 * 0.80 = 116 → 115, 145 * 0.88 = 127.6 → 130
        XCTAssertEqual(result.minCm, 115)
        XCTAssertEqual(result.maxCm, 130)
    }

    func testAlpineAge12Intermediate_usesPreteenMultipliers() {
        // Age 11-12 intermediate: 0.88–0.93
        let result = SkiCalculator.alpineSkiLength(heightCm: 150, age: 12, ability: .intermediate)
        // 150 * 0.88 = 132 → 130, 150 * 0.93 = 139.5 → 140
        XCTAssertEqual(result.minCm, 130)
        XCTAssertEqual(result.maxCm, 140)
    }

    func testAlpineAge13Intermediate_adultBracketBoundary() {
        // Age 13 is the first age in the 13+ bracket
        let result = SkiCalculator.alpineSkiLength(heightCm: 160, age: 13, ability: .intermediate)
        // 160 * 0.90 = 144 → 145, 160 * 0.95 = 152 → 150
        XCTAssertEqual(result.minCm, 145)
        XCTAssertEqual(result.maxCm, 150)
    }

    func testAlpineAge14Beginner_usesAdultMultipliers() {
        // Age 13+ beginner: 0.85–0.90
        let result = SkiCalculator.alpineSkiLength(heightCm: 165, age: 14, ability: .beginner)
        // 165 * 0.85 = 140.25 → 140, 165 * 0.90 = 148.5 → 150
        XCTAssertEqual(result.minCm, 140)
        XCTAssertEqual(result.maxCm, 150)
    }

    func testAlpineAge15Advanced_usesAdultMultipliers() {
        // Age 13+ advanced: 0.95–1.00
        let result = SkiCalculator.alpineSkiLength(heightCm: 170, age: 15, ability: .advanced)
        // 170 * 0.95 = 161.5 → 160, 170 * 1.00 = 170 → 170
        XCTAssertEqual(result.minCm, 160)
        XCTAssertEqual(result.maxCm, 170)
    }

    // MARK: - Classic XC Ski Length

    func testClassicXC_under5() {
        let result = SkiCalculator.classicXCSkiLength(heightCm: 100, age: 4, ability: .beginner)
        // height-5 to height: 95–100
        XCTAssertEqual(result.minCm, 95)
        XCTAssertEqual(result.maxCm, 100)
    }

    func testClassicXC_age5to7Beginner() {
        let result = SkiCalculator.classicXCSkiLength(heightCm: 115, age: 6, ability: .beginner)
        // height+0 to +5: 115–120
        XCTAssertEqual(result.minCm, 115)
        XCTAssertEqual(result.maxCm, 120)
    }

    func testClassicXC_age8to11Advanced() {
        let result = SkiCalculator.classicXCSkiLength(heightCm: 135, age: 10, ability: .advanced)
        // height+15 to +20: 150–155
        XCTAssertEqual(result.minCm, 150)
        XCTAssertEqual(result.maxCm, 155)
    }

    func testClassicXC_age12plusIntermediate() {
        let result = SkiCalculator.classicXCSkiLength(heightCm: 160, age: 13, ability: .intermediate)
        // height+15 to +20: 175–180
        XCTAssertEqual(result.minCm, 175)
        XCTAssertEqual(result.maxCm, 180)
    }

    // MARK: - Skate XC Ski Length

    func testSkateXC_under8ReturnsNil() {
        XCTAssertNil(SkiCalculator.skateXCSkiLength(heightCm: 120, age: 7, ability: .beginner))
    }

    func testSkateXC_age8Beginner() {
        let result = SkiCalculator.skateXCSkiLength(heightCm: 130, age: 8, ability: .beginner)
        // height+0 to +5: 130–135
        XCTAssertEqual(result?.minCm, 130)
        XCTAssertEqual(result?.maxCm, 135)
    }

    func testSkateXC_age10Intermediate() {
        let result = SkiCalculator.skateXCSkiLength(heightCm: 140, age: 10, ability: .intermediate)
        // height+7.5: 147.5 → 150 (single value)
        XCTAssertEqual(result?.minCm, 150)
        XCTAssertEqual(result?.maxCm, 150)
    }

    func testSkateXC_age13Advanced() {
        let result = SkiCalculator.skateXCSkiLength(heightCm: 165, age: 13, ability: .advanced)
        // height+10: 175 (single value)
        XCTAssertEqual(result?.minCm, 175)
        XCTAssertEqual(result?.maxCm, 175)
    }

    // MARK: - Pole Lengths

    func testAlpinePoleLength_fromRequirementsTable() {
        // Requirements example table: height → recommended pole
        XCTAssertEqual(SkiCalculator.alpinePoleLength(heightCm: 90), 60)
        XCTAssertEqual(SkiCalculator.alpinePoleLength(heightCm: 100), 70)
        XCTAssertEqual(SkiCalculator.alpinePoleLength(heightCm: 110), 75)
        XCTAssertEqual(SkiCalculator.alpinePoleLength(heightCm: 120), 80)
        XCTAssertEqual(SkiCalculator.alpinePoleLength(heightCm: 130), 90)
        XCTAssertEqual(SkiCalculator.alpinePoleLength(heightCm: 140), 95)
        XCTAssertEqual(SkiCalculator.alpinePoleLength(heightCm: 150), 100)
        XCTAssertEqual(SkiCalculator.alpinePoleLength(heightCm: 160), 110)
    }

    func testXCClassicPoleLength_fromRequirementsTable() {
        XCTAssertEqual(SkiCalculator.xcClassicPoleLength(heightCm: 90), 75)
        XCTAssertEqual(SkiCalculator.xcClassicPoleLength(heightCm: 100), 85)
        XCTAssertEqual(SkiCalculator.xcClassicPoleLength(heightCm: 110), 90)
        XCTAssertEqual(SkiCalculator.xcClassicPoleLength(heightCm: 120), 100)
        XCTAssertEqual(SkiCalculator.xcClassicPoleLength(heightCm: 130), 110)
        XCTAssertEqual(SkiCalculator.xcClassicPoleLength(heightCm: 140), 120)
        XCTAssertEqual(SkiCalculator.xcClassicPoleLength(heightCm: 150), 125)
    }

    func testXCSkatePoleLength_fromRequirementsTable() {
        XCTAssertEqual(SkiCalculator.xcSkatePoleLength(heightCm: 100), 90)
        XCTAssertEqual(SkiCalculator.xcSkatePoleLength(heightCm: 110), 100)
        XCTAssertEqual(SkiCalculator.xcSkatePoleLength(heightCm: 120), 105)
        XCTAssertEqual(SkiCalculator.xcSkatePoleLength(heightCm: 130), 115)
        XCTAssertEqual(SkiCalculator.xcSkatePoleLength(heightCm: 140), 125)
        XCTAssertEqual(SkiCalculator.xcSkatePoleLength(heightCm: 150), 135)
        XCTAssertEqual(SkiCalculator.xcSkatePoleLength(heightCm: 160), 140)
    }

    // MARK: - BSL Estimation

    func testEstimatedBSLFromShoeSize() {
        XCTAssertEqual(SkiCalculator.estimatedBSL(fromEUSize: 15), 150)
        XCTAssertEqual(SkiCalculator.estimatedBSL(fromEUSize: 25), 217)
        XCTAssertEqual(SkiCalculator.estimatedBSL(fromEUSize: 32), 258)
        XCTAssertEqual(SkiCalculator.estimatedBSL(fromEUSize: 38), 298)
    }

    func testEstimatedBSLFromShoeSize_belowRange() {
        XCTAssertEqual(SkiCalculator.estimatedBSL(fromEUSize: 10), 145)
    }

    func testEstimatedBSLFromShoeSize_aboveRange() {
        XCTAssertEqual(SkiCalculator.estimatedBSL(fromEUSize: 42), 310)
    }

    func testEstimatedBSLFromHeight() {
        XCTAssertEqual(SkiCalculator.estimatedBSLFromHeight(heightCm: 80), 170)
        XCTAssertEqual(SkiCalculator.estimatedBSLFromHeight(heightCm: 120), 235)
        XCTAssertEqual(SkiCalculator.estimatedBSLFromHeight(heightCm: 150), 280)
        XCTAssertEqual(SkiCalculator.estimatedBSLFromHeight(heightCm: 180), 315)
    }
}
