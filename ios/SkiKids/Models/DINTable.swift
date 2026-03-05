import Foundation

enum DINCode: String, CaseIterable {
    case A, B, C, D, E, F, G, H, I, J, K, L, M

    var weightRange: ClosedRange<Int> {
        switch self {
        case .A: return 10...13
        case .B: return 14...17
        case .C: return 18...21
        case .D: return 22...25
        case .E: return 26...30
        case .F: return 31...35
        case .G: return 36...41
        case .H: return 42...48
        case .I: return 49...57
        case .J: return 58...66
        case .K: return 67...78
        case .L: return 79...94
        case .M: return 95...200
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

    var previous: DINCode? {
        let all = DINCode.allCases
        guard let idx = all.firstIndex(of: self), idx > 0 else { return nil }
        return all[idx - 1]
    }
}

enum BSLRange: Equatable {
    case upTo250
    case from251to270
    case from271to290
    case from291to310
    case from311to330
    case over330

    static func from(_ bsl: Int) -> BSLRange {
        if bsl <= 250 { return .upTo250 }
        if bsl <= 270 { return .from251to270 }
        if bsl <= 290 { return .from271to290 }
        if bsl <= 310 { return .from291to310 }
        if bsl <= 330 { return .from311to330 }
        return .over330
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
        // Code A (10-13kg)
        DINTableEntry(code: .A, bslRange: .upTo250,      typeI: 0.75, typeII: 0.75, typeIII: 1.00),
        DINTableEntry(code: .A, bslRange: .from251to270, typeI: 0.75, typeII: 0.75, typeIII: 1.00),
        DINTableEntry(code: .A, bslRange: .from271to290, typeI: 0.75, typeII: 1.00, typeIII: 1.25),
        DINTableEntry(code: .A, bslRange: .from291to310, typeI: 0.75, typeII: 1.00, typeIII: 1.25),
        DINTableEntry(code: .A, bslRange: .from311to330, typeI: 0.75, typeII: 1.00, typeIII: 1.50),
        DINTableEntry(code: .A, bslRange: .over330,      typeI: 0.75, typeII: 1.00, typeIII: 1.50),

        // Code B (14-17kg)
        DINTableEntry(code: .B, bslRange: .upTo250,      typeI: 1.00, typeII: 1.25, typeIII: 1.50),
        DINTableEntry(code: .B, bslRange: .from251to270, typeI: 1.00, typeII: 1.25, typeIII: 1.50),
        DINTableEntry(code: .B, bslRange: .from271to290, typeI: 1.00, typeII: 1.50, typeIII: 1.75),
        DINTableEntry(code: .B, bslRange: .from291to310, typeI: 1.00, typeII: 1.50, typeIII: 1.75),
        DINTableEntry(code: .B, bslRange: .from311to330, typeI: 1.25, typeII: 1.50, typeIII: 2.00),
        DINTableEntry(code: .B, bslRange: .over330,      typeI: 1.25, typeII: 1.50, typeIII: 2.00),

        // Code C (18-21kg)
        DINTableEntry(code: .C, bslRange: .upTo250,      typeI: 1.50, typeII: 1.75, typeIII: 2.25),
        DINTableEntry(code: .C, bslRange: .from251to270, typeI: 1.50, typeII: 1.75, typeIII: 2.25),
        DINTableEntry(code: .C, bslRange: .from271to290, typeI: 1.50, typeII: 2.00, typeIII: 2.50),
        DINTableEntry(code: .C, bslRange: .from291to310, typeI: 1.50, typeII: 2.00, typeIII: 2.50),
        DINTableEntry(code: .C, bslRange: .from311to330, typeI: 1.75, typeII: 2.25, typeIII: 3.00),
        DINTableEntry(code: .C, bslRange: .over330,      typeI: 1.75, typeII: 2.25, typeIII: 3.00),

        // Code D (22-25kg)
        DINTableEntry(code: .D, bslRange: .upTo250,      typeI: 2.00, typeII: 2.50, typeIII: 3.00),
        DINTableEntry(code: .D, bslRange: .from251to270, typeI: 2.00, typeII: 2.50, typeIII: 3.00),
        DINTableEntry(code: .D, bslRange: .from271to290, typeI: 2.00, typeII: 2.75, typeIII: 3.50),
        DINTableEntry(code: .D, bslRange: .from291to310, typeI: 2.00, typeII: 2.75, typeIII: 3.50),
        DINTableEntry(code: .D, bslRange: .from311to330, typeI: 2.25, typeII: 3.00, typeIII: 3.50),
        DINTableEntry(code: .D, bslRange: .over330,      typeI: 2.25, typeII: 3.00, typeIII: 3.50),

        // Code E (26-30kg)
        DINTableEntry(code: .E, bslRange: .upTo250,      typeI: 2.50, typeII: 3.00, typeIII: 3.50),
        DINTableEntry(code: .E, bslRange: .from251to270, typeI: 2.50, typeII: 3.00, typeIII: 3.50),
        DINTableEntry(code: .E, bslRange: .from271to290, typeI: 2.75, typeII: 3.50, typeIII: 4.00),
        DINTableEntry(code: .E, bslRange: .from291to310, typeI: 2.75, typeII: 3.50, typeIII: 4.00),
        DINTableEntry(code: .E, bslRange: .from311to330, typeI: 3.00, typeII: 3.50, typeIII: 4.50),
        DINTableEntry(code: .E, bslRange: .over330,      typeI: 3.00, typeII: 3.50, typeIII: 4.50),

        // Code F (31-35kg)
        DINTableEntry(code: .F, bslRange: .upTo250,      typeI: 3.00, typeII: 3.50, typeIII: 4.50),
        DINTableEntry(code: .F, bslRange: .from251to270, typeI: 3.00, typeII: 3.50, typeIII: 4.50),
        DINTableEntry(code: .F, bslRange: .from271to290, typeI: 3.50, typeII: 4.00, typeIII: 5.00),
        DINTableEntry(code: .F, bslRange: .from291to310, typeI: 3.50, typeII: 4.00, typeIII: 5.00),
        DINTableEntry(code: .F, bslRange: .from311to330, typeI: 3.50, typeII: 4.50, typeIII: 5.50),
        DINTableEntry(code: .F, bslRange: .over330,      typeI: 3.50, typeII: 4.50, typeIII: 5.50),

        // Code G (36-41kg)
        DINTableEntry(code: .G, bslRange: .upTo250,      typeI: 3.50, typeII: 4.50, typeIII: 5.50),
        DINTableEntry(code: .G, bslRange: .from251to270, typeI: 3.50, typeII: 4.50, typeIII: 5.50),
        DINTableEntry(code: .G, bslRange: .from271to290, typeI: 4.00, typeII: 5.00, typeIII: 6.00),
        DINTableEntry(code: .G, bslRange: .from291to310, typeI: 4.00, typeII: 5.00, typeIII: 6.00),
        DINTableEntry(code: .G, bslRange: .from311to330, typeI: 4.50, typeII: 5.50, typeIII: 6.50),
        DINTableEntry(code: .G, bslRange: .over330,      typeI: 4.50, typeII: 5.50, typeIII: 6.50),

        // Code H (42-48kg)
        DINTableEntry(code: .H, bslRange: .upTo250,      typeI: 4.50, typeII: 5.50, typeIII: 6.50),
        DINTableEntry(code: .H, bslRange: .from251to270, typeI: 4.50, typeII: 5.50, typeIII: 6.50),
        DINTableEntry(code: .H, bslRange: .from271to290, typeI: 5.00, typeII: 6.00, typeIII: 7.50),
        DINTableEntry(code: .H, bslRange: .from291to310, typeI: 5.00, typeII: 6.00, typeIII: 7.50),
        DINTableEntry(code: .H, bslRange: .from311to330, typeI: 5.50, typeII: 6.50, typeIII: 8.00),
        DINTableEntry(code: .H, bslRange: .over330,      typeI: 5.50, typeII: 6.50, typeIII: 8.00),

        // Code I (49-57kg)
        DINTableEntry(code: .I, bslRange: .upTo250,      typeI: 5.50, typeII: 6.50, typeIII: 8.00),
        DINTableEntry(code: .I, bslRange: .from251to270, typeI: 5.50, typeII: 6.50, typeIII: 8.00),
        DINTableEntry(code: .I, bslRange: .from271to290, typeI: 6.00, typeII: 7.50, typeIII: 9.00),
        DINTableEntry(code: .I, bslRange: .from291to310, typeI: 6.00, typeII: 7.50, typeIII: 9.00),
        DINTableEntry(code: .I, bslRange: .from311to330, typeI: 6.50, typeII: 8.00, typeIII: 9.50),
        DINTableEntry(code: .I, bslRange: .over330,      typeI: 6.50, typeII: 8.00, typeIII: 9.50),

        // Code J (58-66kg)
        DINTableEntry(code: .J, bslRange: .upTo250,      typeI: 6.50, typeII: 8.00, typeIII: 9.50),
        DINTableEntry(code: .J, bslRange: .from251to270, typeI: 6.50, typeII: 8.00, typeIII: 9.50),
        DINTableEntry(code: .J, bslRange: .from271to290, typeI: 7.50, typeII: 9.00, typeIII: 10.50),
        DINTableEntry(code: .J, bslRange: .from291to310, typeI: 7.50, typeII: 9.00, typeIII: 10.50),
        DINTableEntry(code: .J, bslRange: .from311to330, typeI: 8.00, typeII: 9.50, typeIII: 11.00),
        DINTableEntry(code: .J, bslRange: .over330,      typeI: 8.00, typeII: 9.50, typeIII: 11.00),

        // Code K (67-78kg)
        DINTableEntry(code: .K, bslRange: .upTo250,      typeI: 8.00,  typeII: 9.50,  typeIII: 11.00),
        DINTableEntry(code: .K, bslRange: .from251to270, typeI: 8.00,  typeII: 9.50,  typeIII: 11.00),
        DINTableEntry(code: .K, bslRange: .from271to290, typeI: 8.50,  typeII: 10.00, typeIII: 12.00),
        DINTableEntry(code: .K, bslRange: .from291to310, typeI: 8.50,  typeII: 10.00, typeIII: 12.00),
        DINTableEntry(code: .K, bslRange: .from311to330, typeI: 9.00,  typeII: 11.00, typeIII: 12.00),
        DINTableEntry(code: .K, bslRange: .over330,      typeI: 9.00,  typeII: 11.00, typeIII: 12.00),

        // Code L (79-94kg)
        DINTableEntry(code: .L, bslRange: .upTo250,      typeI: 9.00,  typeII: 11.00, typeIII: 12.00),
        DINTableEntry(code: .L, bslRange: .from251to270, typeI: 9.00,  typeII: 11.00, typeIII: 12.00),
        DINTableEntry(code: .L, bslRange: .from271to290, typeI: 9.50,  typeII: 11.00, typeIII: 12.00),
        DINTableEntry(code: .L, bslRange: .from291to310, typeI: 9.50,  typeII: 11.00, typeIII: 12.00),
        DINTableEntry(code: .L, bslRange: .from311to330, typeI: 10.00, typeII: 12.00, typeIII: 12.00),
        DINTableEntry(code: .L, bslRange: .over330,      typeI: 10.00, typeII: 12.00, typeIII: 12.00),

        // Code M (95+kg)
        DINTableEntry(code: .M, bslRange: .upTo250,      typeI: 10.00, typeII: 12.00, typeIII: 12.00),
        DINTableEntry(code: .M, bslRange: .from251to270, typeI: 10.00, typeII: 12.00, typeIII: 12.00),
        DINTableEntry(code: .M, bslRange: .from271to290, typeI: 11.00, typeII: 12.00, typeIII: 12.00),
        DINTableEntry(code: .M, bslRange: .from291to310, typeI: 11.00, typeII: 12.00, typeIII: 12.00),
        DINTableEntry(code: .M, bslRange: .from311to330, typeI: 12.00, typeII: 12.00, typeIII: 12.00),
        DINTableEntry(code: .M, bslRange: .over330,      typeI: 12.00, typeII: 12.00, typeIII: 12.00),
    ]

    static func lookup(code: DINCode, bsl: Int, ability: AbilityLevel) -> Double {
        let bslRange = BSLRange.from(bsl)
        guard let entry = entries.first(where: { $0.code == code && $0.bslRange == bslRange }) else {
            return 1.0
        }
        switch ability {
        case .beginner: return entry.typeI
        case .intermediate: return entry.typeII
        case .advanced: return entry.typeIII
        }
    }

}
