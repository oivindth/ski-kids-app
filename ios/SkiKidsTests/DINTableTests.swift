import XCTest
@testable import SkiKids

final class DINTableTests: XCTestCase {

    // MARK: - Spot-check DIN table values against ISO 11088 appendix

    func testCodeA_lowestValues() {
        XCTAssertEqual(DINTable.lookup(code: .A, bsl: 200, ability: .beginner), 0.75)
        XCTAssertEqual(DINTable.lookup(code: .A, bsl: 200, ability: .intermediate), 0.75)
        XCTAssertEqual(DINTable.lookup(code: .A, bsl: 200, ability: .advanced), 1.00)
    }

    func testCodeA_highBSL() {
        XCTAssertEqual(DINTable.lookup(code: .A, bsl: 320, ability: .beginner), 0.75)
        XCTAssertEqual(DINTable.lookup(code: .A, bsl: 320, ability: .intermediate), 1.00)
        XCTAssertEqual(DINTable.lookup(code: .A, bsl: 320, ability: .advanced), 1.50)
    }

    func testCodeD_midRange() {
        // Code D, BSL ≤250, Type I/II/III
        XCTAssertEqual(DINTable.lookup(code: .D, bsl: 240, ability: .beginner), 2.00)
        XCTAssertEqual(DINTable.lookup(code: .D, bsl: 240, ability: .intermediate), 2.50)
        XCTAssertEqual(DINTable.lookup(code: .D, bsl: 240, ability: .advanced), 3.00)

        // Code D, BSL 271-290
        XCTAssertEqual(DINTable.lookup(code: .D, bsl: 280, ability: .beginner), 2.00)
        XCTAssertEqual(DINTable.lookup(code: .D, bsl: 280, ability: .intermediate), 2.75)
        XCTAssertEqual(DINTable.lookup(code: .D, bsl: 280, ability: .advanced), 3.50)
    }

    func testCodeG_usedForTypicalPreteen() {
        // Code G (36-41kg), BSL 251-270
        XCTAssertEqual(DINTable.lookup(code: .G, bsl: 260, ability: .beginner), 3.50)
        XCTAssertEqual(DINTable.lookup(code: .G, bsl: 260, ability: .intermediate), 4.50)
        XCTAssertEqual(DINTable.lookup(code: .G, bsl: 260, ability: .advanced), 5.50)
    }

    func testCodeM_highestValues() {
        XCTAssertEqual(DINTable.lookup(code: .M, bsl: 340, ability: .beginner), 12.00)
        XCTAssertEqual(DINTable.lookup(code: .M, bsl: 340, ability: .intermediate), 12.00)
        XCTAssertEqual(DINTable.lookup(code: .M, bsl: 340, ability: .advanced), 12.00)
    }

    func testCodeM_lowBSL() {
        XCTAssertEqual(DINTable.lookup(code: .M, bsl: 240, ability: .beginner), 10.00)
        XCTAssertEqual(DINTable.lookup(code: .M, bsl: 240, ability: .intermediate), 12.00)
        XCTAssertEqual(DINTable.lookup(code: .M, bsl: 240, ability: .advanced), 12.00)
    }

    // MARK: - BSL Range boundaries

    func testBSLRangeBoundary_250() {
        // BSL 250 → ≤250 range
        XCTAssertEqual(DINTable.lookup(code: .B, bsl: 250, ability: .beginner), 1.00)
        // BSL 251 → 251-270 range
        XCTAssertEqual(DINTable.lookup(code: .B, bsl: 251, ability: .beginner), 1.00)
    }

    func testBSLRangeBoundary_330() {
        // BSL 330 → 311-330 range
        XCTAssertEqual(DINTable.lookup(code: .B, bsl: 330, ability: .advanced), 2.00)
        // BSL 331 → >330 range
        XCTAssertEqual(DINTable.lookup(code: .B, bsl: 331, ability: .advanced), 2.00)
    }

    // MARK: - DIN Code properties

    func testDINCodeWeightRanges_noGaps() {
        // Verify weight ranges are contiguous from 10 to 200
        let allCases = DINCode.allCases
        for i in 0..<allCases.count - 1 {
            let current = allCases[i]
            let next = allCases[i + 1]
            XCTAssertEqual(current.weightRange.upperBound + 1, next.weightRange.lowerBound,
                          "Gap between \(current) and \(next)")
        }
    }

    func testDINCodeNext() {
        XCTAssertEqual(DINCode.A.next, .B)
        XCTAssertEqual(DINCode.L.next, .M)
        XCTAssertNil(DINCode.M.next)
    }

    func testDINCodePrevious() {
        XCTAssertNil(DINCode.A.previous)
        XCTAssertEqual(DINCode.B.previous, .A)
        XCTAssertEqual(DINCode.M.previous, .L)
    }

    // MARK: - Table completeness

    func testAllCodesHaveEntries() {
        // Every code should have exactly 6 BSL sub-rows
        for code in DINCode.allCases {
            let entries = DINTable.entries.filter { $0.code == code }
            XCTAssertEqual(entries.count, 6, "Code \(code) should have 6 BSL entries")
        }
    }

    func testTotalEntryCount() {
        // 13 codes × 6 BSL ranges = 78 entries
        XCTAssertEqual(DINTable.entries.count, 78)
    }
}
