import Foundation

enum DINCode: String, CaseIterable {
    case A, B, C, D, E, F, G, H, I, J, K, L, M

    var weightRange: ClosedRange<Int> {
        switch self {
        case .A: return 0...10
        case .B: return 11...13
        case .C: return 14...17
        case .D: return 18...21
        case .E: return 22...25
        case .F: return 26...30
        case .G: return 31...35
        case .H: return 36...41
        case .I: return 42...48
        case .J: return 49...57
        case .K: return 58...66
        case .L: return 67...78
        case .M: return 79...200
        }
    }

    var heightThreshold: Int {
        switch self {
        case .A: return 148
        case .B: return 148
        case .C: return 148
        case .D: return 148
        case .E: return 148
        case .F: return 157
        case .G: return 166
        case .H: return 174
        case .I: return 182
        case .J: return 189
        case .K: return 196
        case .L: return 196
        case .M: return Int.max
        }
    }

    var next: DINCode? {
        let all = DINCode.allCases
        guard let idx = all.firstIndex(of: self), idx + 1 < all.count else { return nil }
        return all[idx + 1]
    }
}

enum BSLRange {
    case upTo230
    case from231to270
    case from271to310
    case over310

    static func from(_ bsl: Int) -> BSLRange {
        if bsl <= 230 { return .upTo230 }
        if bsl <= 270 { return .from231to270 }
        if bsl <= 310 { return .from271to310 }
        return .over310
    }
}

struct DINTableEntry {
    let code: DINCode
    let bslRange: BSLRange
    let typeI: Double
    let typeII: Double
    let typeIII: Double
}

struct DINTable {
    static let entries: [DINTableEntry] = [
        DINTableEntry(code: .A, bslRange: .upTo230,      typeI: 0.75,  typeII: 1.00,  typeIII: 1.50),
        DINTableEntry(code: .A, bslRange: .from231to270, typeI: 0.75,  typeII: 1.00,  typeIII: 1.50),
        DINTableEntry(code: .A, bslRange: .from271to310, typeI: 1.00,  typeII: 1.25,  typeIII: 1.75),
        DINTableEntry(code: .A, bslRange: .over310,      typeI: 1.00,  typeII: 1.25,  typeIII: 1.75),

        DINTableEntry(code: .B, bslRange: .upTo230,      typeI: 1.00,  typeII: 1.25,  typeIII: 1.75),
        DINTableEntry(code: .B, bslRange: .from231to270, typeI: 1.00,  typeII: 1.25,  typeIII: 1.75),
        DINTableEntry(code: .B, bslRange: .from271to310, typeI: 1.25,  typeII: 1.50,  typeIII: 2.00),
        DINTableEntry(code: .B, bslRange: .over310,      typeI: 1.25,  typeII: 1.50,  typeIII: 2.00),

        DINTableEntry(code: .C, bslRange: .upTo230,      typeI: 1.25,  typeII: 1.50,  typeIII: 2.00),
        DINTableEntry(code: .C, bslRange: .from231to270, typeI: 1.50,  typeII: 2.00,  typeIII: 2.50),
        DINTableEntry(code: .C, bslRange: .from271to310, typeI: 1.75,  typeII: 2.25,  typeIII: 3.00),
        DINTableEntry(code: .C, bslRange: .over310,      typeI: 1.75,  typeII: 2.25,  typeIII: 3.00),

        DINTableEntry(code: .D, bslRange: .upTo230,      typeI: 1.50,  typeII: 2.00,  typeIII: 2.50),
        DINTableEntry(code: .D, bslRange: .from231to270, typeI: 1.75,  typeII: 2.25,  typeIII: 3.00),
        DINTableEntry(code: .D, bslRange: .from271to310, typeI: 2.00,  typeII: 2.50,  typeIII: 3.50),
        DINTableEntry(code: .D, bslRange: .over310,      typeI: 2.00,  typeII: 2.50,  typeIII: 3.50),

        DINTableEntry(code: .E, bslRange: .upTo230,      typeI: 2.00,  typeII: 2.50,  typeIII: 3.00),
        DINTableEntry(code: .E, bslRange: .from231to270, typeI: 2.25,  typeII: 3.00,  typeIII: 3.50),
        DINTableEntry(code: .E, bslRange: .from271to310, typeI: 2.50,  typeII: 3.50,  typeIII: 4.00),
        DINTableEntry(code: .E, bslRange: .over310,      typeI: 2.50,  typeII: 3.50,  typeIII: 4.00),

        DINTableEntry(code: .F, bslRange: .upTo230,      typeI: 2.50,  typeII: 3.00,  typeIII: 3.50),
        DINTableEntry(code: .F, bslRange: .from231to270, typeI: 3.00,  typeII: 3.50,  typeIII: 4.50),
        DINTableEntry(code: .F, bslRange: .from271to310, typeI: 3.50,  typeII: 4.00,  typeIII: 5.00),
        DINTableEntry(code: .F, bslRange: .over310,      typeI: 3.50,  typeII: 4.00,  typeIII: 5.00),

        DINTableEntry(code: .G, bslRange: .upTo230,      typeI: 3.00,  typeII: 3.50,  typeIII: 4.50),
        DINTableEntry(code: .G, bslRange: .from231to270, typeI: 3.50,  typeII: 4.00,  typeIII: 5.00),
        DINTableEntry(code: .G, bslRange: .from271to310, typeI: 4.00,  typeII: 4.50,  typeIII: 5.50),
        DINTableEntry(code: .G, bslRange: .over310,      typeI: 4.00,  typeII: 4.50,  typeIII: 5.50),

        DINTableEntry(code: .H, bslRange: .upTo230,      typeI: 3.50,  typeII: 4.50,  typeIII: 5.50),
        DINTableEntry(code: .H, bslRange: .from231to270, typeI: 4.00,  typeII: 5.00,  typeIII: 6.00),
        DINTableEntry(code: .H, bslRange: .from271to310, typeI: 4.50,  typeII: 5.50,  typeIII: 6.50),
        DINTableEntry(code: .H, bslRange: .over310,      typeI: 4.50,  typeII: 5.50,  typeIII: 6.50),

        DINTableEntry(code: .I, bslRange: .upTo230,      typeI: 4.50,  typeII: 5.50,  typeIII: 6.50),
        DINTableEntry(code: .I, bslRange: .from231to270, typeI: 5.00,  typeII: 6.00,  typeIII: 7.00),
        DINTableEntry(code: .I, bslRange: .from271to310, typeI: 5.50,  typeII: 6.50,  typeIII: 7.50),
        DINTableEntry(code: .I, bslRange: .over310,      typeI: 5.50,  typeII: 6.50,  typeIII: 7.50),

        DINTableEntry(code: .J, bslRange: .upTo230,      typeI: 5.50,  typeII: 6.50,  typeIII: 7.50),
        DINTableEntry(code: .J, bslRange: .from231to270, typeI: 6.00,  typeII: 7.00,  typeIII: 8.00),
        DINTableEntry(code: .J, bslRange: .from271to310, typeI: 6.50,  typeII: 7.50,  typeIII: 8.50),
        DINTableEntry(code: .J, bslRange: .over310,      typeI: 6.50,  typeII: 7.50,  typeIII: 8.50),

        DINTableEntry(code: .K, bslRange: .upTo230,      typeI: 6.50,  typeII: 7.50,  typeIII: 8.50),
        DINTableEntry(code: .K, bslRange: .from231to270, typeI: 7.00,  typeII: 8.00,  typeIII: 9.00),
        DINTableEntry(code: .K, bslRange: .from271to310, typeI: 7.50,  typeII: 8.50,  typeIII: 10.00),
        DINTableEntry(code: .K, bslRange: .over310,      typeI: 7.50,  typeII: 8.50,  typeIII: 10.00),

        DINTableEntry(code: .L, bslRange: .upTo230,      typeI: 7.50,  typeII: 8.50,  typeIII: 10.00),
        DINTableEntry(code: .L, bslRange: .from231to270, typeI: 8.00,  typeII: 9.00,  typeIII: 11.00),
        DINTableEntry(code: .L, bslRange: .from271to310, typeI: 8.50,  typeII: 10.00, typeIII: 12.00),
        DINTableEntry(code: .L, bslRange: .over310,      typeI: 8.50,  typeII: 10.00, typeIII: 12.00),

        DINTableEntry(code: .M, bslRange: .upTo230,      typeI: 8.50,  typeII: 10.00, typeIII: 12.00),
        DINTableEntry(code: .M, bslRange: .from231to270, typeI: 9.00,  typeII: 11.00, typeIII: 12.00),
        DINTableEntry(code: .M, bslRange: .from271to310, typeI: 10.00, typeII: 12.00, typeIII: 12.00),
        DINTableEntry(code: .M, bslRange: .over310,      typeI: 10.00, typeII: 12.00, typeIII: 12.00),
    ]

    static func lookup(code: DINCode, bsl: Int, ability: AbilityLevel) -> Double {
        let bslRange = BSLRange.from(bsl)
        guard let entry = entries.first(where: { $0.code == code && bslRangeMatches($0.bslRange, bslRange) }) else {
            return 1.0
        }
        switch ability {
        case .beginner: return entry.typeI
        case .intermediate: return entry.typeII
        case .advanced: return entry.typeIII
        }
    }

    private static func bslRangeMatches(_ a: BSLRange, _ b: BSLRange) -> Bool {
        switch (a, b) {
        case (.upTo230, .upTo230): return true
        case (.from231to270, .from231to270): return true
        case (.from271to310, .from271to310): return true
        case (.over310, .over310): return true
        default: return false
        }
    }
}
