export enum AbilityLevel {
  Beginner = "Beginner",
  Intermediate = "Intermediate",
  Advanced = "Advanced",
}

export enum SkiType {
  Alpine = "Alpine",
  XCClassic = "XC Classic",
  XCSkate = "XC Skate",
}

export enum BSLInputMode {
  Estimate = 0,
  ShoeSize = 1,
  BSL = 2,
}

export enum DINCode {
  A = "A",
  B = "B",
  C = "C",
  D = "D",
  E = "E",
  F = "F",
  G = "G",
  H = "H",
  I = "I",
  J = "J",
  K = "K",
  L = "L",
  M = "M",
}

export enum BSLRange {
  upTo250 = "upTo250",
  from251to270 = "from251to270",
  from271to290 = "from271to290",
  from291to310 = "from291to310",
  from311to330 = "from311to330",
  over330 = "over330",
}

export interface SkiLengthRange {
  minCm: number;
  maxCm: number;
}

export interface DINResult {
  value: number;
  code: string;
  skierType: string;
  isJuniorAdjusted: boolean;
  warnings: string[];
}

export interface DINTableEntry {
  code: DINCode;
  bslRange: BSLRange;
  typeI: number;
  typeII: number;
  typeIII: number;
}

export interface SkiRecommendation {
  childName: string;
  heightCm: number;
  weightKg: number;
  age: number;
  abilityLevel: AbilityLevel;
  skiTypes: SkiType[];
  alpineSkiLength: SkiLengthRange | null;
  dinResult: DINResult | null;
  xcClassicLength: SkiLengthRange | null;
  xcSkateLength: SkiLengthRange | null;
  alpinePoleLength: number | null;
  xcClassicPoleLength: number | null;
  xcSkatePoleLength: number | null;
  warnings: string[];
  calculatedAt: Date;
}

export interface Child {
  id: string;
  name: string;
  heightCm: number;
  weightKg: number;
  age: number;
  bslMm: number | null;
  bslInputModeRaw: number | null;
  shoeSize: number | null;
  abilityLevel: AbilityLevel;
  skiTypes: SkiType[];
  lastCalculated: Date | null;
  createdAt: Date;
}

export const INPUT_CONSTRAINTS = {
  height: { min: 60, max: 210 },
  weight: { min: 8, max: 120 },
  age: { min: 2, max: 99 },
  bsl: { min: 150, max: 380 },
  shoeSize: { min: 15, max: 50 },
  nameMaxLength: 50,
} as const;
