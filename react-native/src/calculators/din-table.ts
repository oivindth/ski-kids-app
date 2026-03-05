import { AbilityLevel, BSLRange, DINCode, DINTableEntry } from "../models/types";

export const DIN_CODE_ORDER: DINCode[] = [
  DINCode.A,
  DINCode.B,
  DINCode.C,
  DINCode.D,
  DINCode.E,
  DINCode.F,
  DINCode.G,
  DINCode.H,
  DINCode.I,
  DINCode.J,
  DINCode.K,
  DINCode.L,
  DINCode.M,
];

export interface DINCodeMetadata {
  weightMin: number;
  weightMax: number;
  heightThreshold: number;
}

export const DIN_CODE_METADATA: Record<DINCode, DINCodeMetadata> = {
  [DINCode.A]: { weightMin: 10, weightMax: 13, heightThreshold: 148 },
  [DINCode.B]: { weightMin: 14, weightMax: 17, heightThreshold: 148 },
  [DINCode.C]: { weightMin: 18, weightMax: 21, heightThreshold: 148 },
  [DINCode.D]: { weightMin: 22, weightMax: 25, heightThreshold: 148 },
  [DINCode.E]: { weightMin: 26, weightMax: 30, heightThreshold: 148 },
  [DINCode.F]: { weightMin: 31, weightMax: 35, heightThreshold: 157 },
  [DINCode.G]: { weightMin: 36, weightMax: 41, heightThreshold: 166 },
  [DINCode.H]: { weightMin: 42, weightMax: 48, heightThreshold: 174 },
  [DINCode.I]: { weightMin: 49, weightMax: 57, heightThreshold: 182 },
  [DINCode.J]: { weightMin: 58, weightMax: 66, heightThreshold: 189 },
  [DINCode.K]: { weightMin: 67, weightMax: 78, heightThreshold: 196 },
  [DINCode.L]: { weightMin: 79, weightMax: 94, heightThreshold: 196 },
  [DINCode.M]: { weightMin: 95, weightMax: 200, heightThreshold: Number.MAX_SAFE_INTEGER },
};

export const DIN_TABLE: DINTableEntry[] = [
  // Code A (10-13kg)
  { code: DINCode.A, bslRange: BSLRange.upTo250,      typeI: 0.75, typeII: 0.75, typeIII: 1.00 },
  { code: DINCode.A, bslRange: BSLRange.from251to270, typeI: 0.75, typeII: 0.75, typeIII: 1.00 },
  { code: DINCode.A, bslRange: BSLRange.from271to290, typeI: 0.75, typeII: 1.00, typeIII: 1.25 },
  { code: DINCode.A, bslRange: BSLRange.from291to310, typeI: 0.75, typeII: 1.00, typeIII: 1.25 },
  { code: DINCode.A, bslRange: BSLRange.from311to330, typeI: 0.75, typeII: 1.00, typeIII: 1.50 },
  { code: DINCode.A, bslRange: BSLRange.over330,      typeI: 0.75, typeII: 1.00, typeIII: 1.50 },

  // Code B (14-17kg)
  { code: DINCode.B, bslRange: BSLRange.upTo250,      typeI: 1.00, typeII: 1.25, typeIII: 1.50 },
  { code: DINCode.B, bslRange: BSLRange.from251to270, typeI: 1.00, typeII: 1.25, typeIII: 1.50 },
  { code: DINCode.B, bslRange: BSLRange.from271to290, typeI: 1.00, typeII: 1.50, typeIII: 1.75 },
  { code: DINCode.B, bslRange: BSLRange.from291to310, typeI: 1.00, typeII: 1.50, typeIII: 1.75 },
  { code: DINCode.B, bslRange: BSLRange.from311to330, typeI: 1.25, typeII: 1.50, typeIII: 2.00 },
  { code: DINCode.B, bslRange: BSLRange.over330,      typeI: 1.25, typeII: 1.50, typeIII: 2.00 },

  // Code C (18-21kg)
  { code: DINCode.C, bslRange: BSLRange.upTo250,      typeI: 1.50, typeII: 1.75, typeIII: 2.25 },
  { code: DINCode.C, bslRange: BSLRange.from251to270, typeI: 1.50, typeII: 1.75, typeIII: 2.25 },
  { code: DINCode.C, bslRange: BSLRange.from271to290, typeI: 1.50, typeII: 2.00, typeIII: 2.50 },
  { code: DINCode.C, bslRange: BSLRange.from291to310, typeI: 1.50, typeII: 2.00, typeIII: 2.50 },
  { code: DINCode.C, bslRange: BSLRange.from311to330, typeI: 1.75, typeII: 2.25, typeIII: 3.00 },
  { code: DINCode.C, bslRange: BSLRange.over330,      typeI: 1.75, typeII: 2.25, typeIII: 3.00 },

  // Code D (22-25kg)
  { code: DINCode.D, bslRange: BSLRange.upTo250,      typeI: 2.00, typeII: 2.50, typeIII: 3.00 },
  { code: DINCode.D, bslRange: BSLRange.from251to270, typeI: 2.00, typeII: 2.50, typeIII: 3.00 },
  { code: DINCode.D, bslRange: BSLRange.from271to290, typeI: 2.00, typeII: 2.75, typeIII: 3.50 },
  { code: DINCode.D, bslRange: BSLRange.from291to310, typeI: 2.00, typeII: 2.75, typeIII: 3.50 },
  { code: DINCode.D, bslRange: BSLRange.from311to330, typeI: 2.25, typeII: 3.00, typeIII: 3.50 },
  { code: DINCode.D, bslRange: BSLRange.over330,      typeI: 2.25, typeII: 3.00, typeIII: 3.50 },

  // Code E (26-30kg)
  { code: DINCode.E, bslRange: BSLRange.upTo250,      typeI: 2.50, typeII: 3.00, typeIII: 3.50 },
  { code: DINCode.E, bslRange: BSLRange.from251to270, typeI: 2.50, typeII: 3.00, typeIII: 3.50 },
  { code: DINCode.E, bslRange: BSLRange.from271to290, typeI: 2.75, typeII: 3.50, typeIII: 4.00 },
  { code: DINCode.E, bslRange: BSLRange.from291to310, typeI: 2.75, typeII: 3.50, typeIII: 4.00 },
  { code: DINCode.E, bslRange: BSLRange.from311to330, typeI: 3.00, typeII: 3.50, typeIII: 4.50 },
  { code: DINCode.E, bslRange: BSLRange.over330,      typeI: 3.00, typeII: 3.50, typeIII: 4.50 },

  // Code F (31-35kg)
  { code: DINCode.F, bslRange: BSLRange.upTo250,      typeI: 3.00, typeII: 3.50, typeIII: 4.50 },
  { code: DINCode.F, bslRange: BSLRange.from251to270, typeI: 3.00, typeII: 3.50, typeIII: 4.50 },
  { code: DINCode.F, bslRange: BSLRange.from271to290, typeI: 3.50, typeII: 4.00, typeIII: 5.00 },
  { code: DINCode.F, bslRange: BSLRange.from291to310, typeI: 3.50, typeII: 4.00, typeIII: 5.00 },
  { code: DINCode.F, bslRange: BSLRange.from311to330, typeI: 3.50, typeII: 4.50, typeIII: 5.50 },
  { code: DINCode.F, bslRange: BSLRange.over330,      typeI: 3.50, typeII: 4.50, typeIII: 5.50 },

  // Code G (36-41kg)
  { code: DINCode.G, bslRange: BSLRange.upTo250,      typeI: 3.50, typeII: 4.50, typeIII: 5.50 },
  { code: DINCode.G, bslRange: BSLRange.from251to270, typeI: 3.50, typeII: 4.50, typeIII: 5.50 },
  { code: DINCode.G, bslRange: BSLRange.from271to290, typeI: 4.00, typeII: 5.00, typeIII: 6.00 },
  { code: DINCode.G, bslRange: BSLRange.from291to310, typeI: 4.00, typeII: 5.00, typeIII: 6.00 },
  { code: DINCode.G, bslRange: BSLRange.from311to330, typeI: 4.50, typeII: 5.50, typeIII: 6.50 },
  { code: DINCode.G, bslRange: BSLRange.over330,      typeI: 4.50, typeII: 5.50, typeIII: 6.50 },

  // Code H (42-48kg)
  { code: DINCode.H, bslRange: BSLRange.upTo250,      typeI: 4.50, typeII: 5.50, typeIII: 6.50 },
  { code: DINCode.H, bslRange: BSLRange.from251to270, typeI: 4.50, typeII: 5.50, typeIII: 6.50 },
  { code: DINCode.H, bslRange: BSLRange.from271to290, typeI: 5.00, typeII: 6.00, typeIII: 7.50 },
  { code: DINCode.H, bslRange: BSLRange.from291to310, typeI: 5.00, typeII: 6.00, typeIII: 7.50 },
  { code: DINCode.H, bslRange: BSLRange.from311to330, typeI: 5.50, typeII: 6.50, typeIII: 8.00 },
  { code: DINCode.H, bslRange: BSLRange.over330,      typeI: 5.50, typeII: 6.50, typeIII: 8.00 },

  // Code I (49-57kg)
  { code: DINCode.I, bslRange: BSLRange.upTo250,      typeI: 5.50, typeII: 6.50, typeIII: 8.00 },
  { code: DINCode.I, bslRange: BSLRange.from251to270, typeI: 5.50, typeII: 6.50, typeIII: 8.00 },
  { code: DINCode.I, bslRange: BSLRange.from271to290, typeI: 6.00, typeII: 7.50, typeIII: 9.00 },
  { code: DINCode.I, bslRange: BSLRange.from291to310, typeI: 6.00, typeII: 7.50, typeIII: 9.00 },
  { code: DINCode.I, bslRange: BSLRange.from311to330, typeI: 6.50, typeII: 8.00, typeIII: 9.50 },
  { code: DINCode.I, bslRange: BSLRange.over330,      typeI: 6.50, typeII: 8.00, typeIII: 9.50 },

  // Code J (58-66kg)
  { code: DINCode.J, bslRange: BSLRange.upTo250,      typeI: 6.50, typeII: 8.00, typeIII: 9.50 },
  { code: DINCode.J, bslRange: BSLRange.from251to270, typeI: 6.50, typeII: 8.00, typeIII: 9.50 },
  { code: DINCode.J, bslRange: BSLRange.from271to290, typeI: 7.50, typeII: 9.00, typeIII: 10.50 },
  { code: DINCode.J, bslRange: BSLRange.from291to310, typeI: 7.50, typeII: 9.00, typeIII: 10.50 },
  { code: DINCode.J, bslRange: BSLRange.from311to330, typeI: 8.00, typeII: 9.50, typeIII: 11.00 },
  { code: DINCode.J, bslRange: BSLRange.over330,      typeI: 8.00, typeII: 9.50, typeIII: 11.00 },

  // Code K (67-78kg)
  { code: DINCode.K, bslRange: BSLRange.upTo250,      typeI: 8.00,  typeII: 9.50,  typeIII: 11.00 },
  { code: DINCode.K, bslRange: BSLRange.from251to270, typeI: 8.00,  typeII: 9.50,  typeIII: 11.00 },
  { code: DINCode.K, bslRange: BSLRange.from271to290, typeI: 8.50,  typeII: 10.00, typeIII: 12.00 },
  { code: DINCode.K, bslRange: BSLRange.from291to310, typeI: 8.50,  typeII: 10.00, typeIII: 12.00 },
  { code: DINCode.K, bslRange: BSLRange.from311to330, typeI: 9.00,  typeII: 11.00, typeIII: 12.00 },
  { code: DINCode.K, bslRange: BSLRange.over330,      typeI: 9.00,  typeII: 11.00, typeIII: 12.00 },

  // Code L (79-94kg)
  { code: DINCode.L, bslRange: BSLRange.upTo250,      typeI: 9.00,  typeII: 11.00, typeIII: 12.00 },
  { code: DINCode.L, bslRange: BSLRange.from251to270, typeI: 9.00,  typeII: 11.00, typeIII: 12.00 },
  { code: DINCode.L, bslRange: BSLRange.from271to290, typeI: 9.50,  typeII: 11.00, typeIII: 12.00 },
  { code: DINCode.L, bslRange: BSLRange.from291to310, typeI: 9.50,  typeII: 11.00, typeIII: 12.00 },
  { code: DINCode.L, bslRange: BSLRange.from311to330, typeI: 10.00, typeII: 12.00, typeIII: 12.00 },
  { code: DINCode.L, bslRange: BSLRange.over330,      typeI: 10.00, typeII: 12.00, typeIII: 12.00 },

  // Code M (95+kg)
  { code: DINCode.M, bslRange: BSLRange.upTo250,      typeI: 10.00, typeII: 12.00, typeIII: 12.00 },
  { code: DINCode.M, bslRange: BSLRange.from251to270, typeI: 10.00, typeII: 12.00, typeIII: 12.00 },
  { code: DINCode.M, bslRange: BSLRange.from271to290, typeI: 11.00, typeII: 12.00, typeIII: 12.00 },
  { code: DINCode.M, bslRange: BSLRange.from291to310, typeI: 11.00, typeII: 12.00, typeIII: 12.00 },
  { code: DINCode.M, bslRange: BSLRange.from311to330, typeI: 12.00, typeII: 12.00, typeIII: 12.00 },
  { code: DINCode.M, bslRange: BSLRange.over330,      typeI: 12.00, typeII: 12.00, typeIII: 12.00 },
];

export function bslRangeFrom(bslMm: number): BSLRange {
  if (bslMm <= 250) return BSLRange.upTo250;
  if (bslMm <= 270) return BSLRange.from251to270;
  if (bslMm <= 290) return BSLRange.from271to290;
  if (bslMm <= 310) return BSLRange.from291to310;
  if (bslMm <= 330) return BSLRange.from311to330;
  return BSLRange.over330;
}

export function dinTableLookup(code: DINCode, bslMm: number, ability: AbilityLevel): number {
  const range = bslRangeFrom(bslMm);
  const entry = DIN_TABLE.find((e) => e.code === code && e.bslRange === range);
  if (!entry) return 1.0;
  switch (ability) {
    case AbilityLevel.Beginner:
      return entry.typeI;
    case AbilityLevel.Intermediate:
      return entry.typeII;
    case AbilityLevel.Advanced:
      return entry.typeIII;
  }
}
