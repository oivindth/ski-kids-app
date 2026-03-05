import { AbilityLevel, DINCode, SkiType } from "../../models/types";
import {
  calculate,
  codeFromWeight,
  adjustCodeForHeight,
  getWarnings,
} from "../din-calculator";

describe("codeFromWeight", () => {
  it("returns A for 10kg (min of A range)", () => {
    expect(codeFromWeight(10)).toBe(DINCode.A);
  });

  it("returns A for 13kg (max of A range)", () => {
    expect(codeFromWeight(13)).toBe(DINCode.A);
  });

  it("returns B for 14kg", () => {
    expect(codeFromWeight(14)).toBe(DINCode.B);
  });

  it("returns D for 25kg (critical test weight)", () => {
    expect(codeFromWeight(25)).toBe(DINCode.D);
  });

  it("returns E for 26kg", () => {
    expect(codeFromWeight(26)).toBe(DINCode.E);
  });

  it("returns M for 95kg", () => {
    expect(codeFromWeight(95)).toBe(DINCode.M);
  });

  it("returns M for 200kg", () => {
    expect(codeFromWeight(200)).toBe(DINCode.M);
  });

  it("returns A (fallback) for weight below range (e.g. 5kg)", () => {
    expect(codeFromWeight(5)).toBe(DINCode.A);
  });
});

describe("adjustCodeForHeight", () => {
  it("does not advance code if height is at or below threshold", () => {
    // Code D threshold is 148 — height 130 should not advance
    expect(adjustCodeForHeight(DINCode.D, 130)).toBe(DINCode.D);
  });

  it("does not advance code E (threshold 148) for height 148", () => {
    expect(adjustCodeForHeight(DINCode.E, 148)).toBe(DINCode.E);
  });

  it("advances code E (threshold 148) for height 149", () => {
    // E threshold is 148, F threshold is 157 — height 149 advances to F
    expect(adjustCodeForHeight(DINCode.E, 149)).toBe(DINCode.F);
  });

  it("advances code F (threshold 157) for height 158", () => {
    expect(adjustCodeForHeight(DINCode.F, 158)).toBe(DINCode.G);
  });

  it("does not advance code M (no threshold)", () => {
    expect(adjustCodeForHeight(DINCode.M, 999)).toBe(DINCode.M);
  });

  it("advances multiple codes when height far exceeds thresholds", () => {
    // Code A threshold 148, B 148, C 148, D 148, E 148 — height 200 advances through all
    const result = adjustCodeForHeight(DINCode.A, 200);
    // After A->B->C->D->E (all threshold 148), then E->F (157<200)->G (166<200)->H (174<200)->I (182<200)->J(189<200)->K(196<200), then K threshold 196, 200>196 -> L (196 threshold), 200>196 -> M (MAX)
    expect(result).toBe(DINCode.M);
  });
});

describe("calculate — critical test case", () => {
  // Child 25kg, 130cm, age 8, beginner
  // Expected: Code D from weight, height 130 < threshold 148 so no height adjustment
  // Age 8 <= 9: junior adjustment -> shift to Code C, re-lookup
  // BSL 250 (upTo250), Code C, beginner (TypeI) = 1.50
  // isJuniorAdjusted = true
  it("25kg, 130cm, age 8, beginner, BSL 250 -> DIN 1.50, code C, junior adjusted", () => {
    const result = calculate(25, 130, 250, 8, AbilityLevel.Beginner);
    expect(result.code).toBe(DINCode.C);
    expect(result.value).toBe(1.5);
    expect(result.isJuniorAdjusted).toBe(true);
    expect(result.skierType).toBe("Type I");
  });
});

describe("calculate — junior adjustment", () => {
  it("age 9 triggers junior adjustment (age <= 9)", () => {
    const result = calculate(25, 130, 250, 9, AbilityLevel.Beginner);
    expect(result.isJuniorAdjusted).toBe(true);
    expect(result.code).toBe(DINCode.C);
  });

  it("age 10 does NOT trigger junior adjustment", () => {
    const result = calculate(25, 130, 250, 10, AbilityLevel.Beginner);
    expect(result.isJuniorAdjusted).toBe(false);
    expect(result.code).toBe(DINCode.D);
  });

  it("age 9, code A — cannot shift further up, stays at A with isJuniorAdjusted true", () => {
    // 10kg -> Code A, no previous code — stays at A
    const result = calculate(10, 80, 250, 9, AbilityLevel.Beginner);
    expect(result.isJuniorAdjusted).toBe(true);
    expect(result.code).toBe(DINCode.A);
  });
});

describe("calculate — conservative height rule for children <= 12", () => {
  it("keeps weight-based code for child age 12 when height pushes code higher", () => {
    // Use a weight that maps to code E (26-30kg), and a height > 148 to trigger height adjustment
    // weight 28kg -> code E, threshold 148; if height 155 -> advances to F (threshold 157, 155<=157 so stops at F? no...)
    // E threshold is 148. height 155 > 148 -> advance to F. F threshold 157. 155 <= 157 -> stop. so heightAdjustedCode = F
    // age 12 <= 12 and F != E, so keep E (base code)
    const result = calculate(28, 155, 260, 12, AbilityLevel.Beginner);
    expect(result.code).toBe(DINCode.E);
    expect(result.warnings).toContain(
      "Height suggests a higher DIN code, but the lower (weight-based) setting was kept for child safety."
    );
  });

  it("does NOT apply conservative rule when height does not advance code", () => {
    // weight 25kg -> D, height 130 < 148 -> no advancement, both codes same, no warning
    const result = calculate(25, 130, 250, 12, AbilityLevel.Beginner);
    expect(result.warnings).not.toContain(
      "Height suggests a higher DIN code, but the lower (weight-based) setting was kept for child safety."
    );
  });

  it("age 13 does NOT apply conservative rule (applies height adjustment)", () => {
    // weight 28kg -> code E, height 155 -> advances to F, age 13 > 12, no conservative rule
    const result = calculate(28, 155, 260, 13, AbilityLevel.Beginner);
    // Junior adjustment doesn't apply (age > 9), height adjusted code F is used
    expect(result.code).toBe(DINCode.F);
    expect(result.warnings).not.toContain(
      "Height suggests a higher DIN code, but the lower (weight-based) setting was kept for child safety."
    );
  });
});

describe("calculate — DIN value rounding", () => {
  it("rounds to nearest 0.25", () => {
    // All DIN table values are already multiples of 0.25, so test the cap and rounding behavior
    const result = calculate(25, 130, 250, 10, AbilityLevel.Beginner);
    // Code D, upTo250, beginner = 2.00
    expect(result.value % 0.25).toBeCloseTo(0);
  });

  it("caps at 12.0", () => {
    // Very heavy adult, advanced — should never exceed 12.0
    const result = calculate(100, 180, 320, 20, AbilityLevel.Advanced);
    expect(result.value).toBeLessThanOrEqual(12.0);
  });
});

describe("calculate — warnings", () => {
  it("warns for high DIN (> 6.0) for age <= 12", () => {
    // Code H (42-48kg), advanced, BSL 330 -> typeIII = 8.00, age 12
    const result = calculate(45, 170, 330, 12, AbilityLevel.Advanced);
    expect(result.warnings.some((w) => w.includes("High DIN setting"))).toBe(true);
  });

  it("does NOT warn high DIN for age > 12", () => {
    const result = calculate(45, 170, 330, 13, AbilityLevel.Advanced);
    expect(result.warnings.some((w) => w.includes("High DIN setting"))).toBe(false);
  });

  it("warns for very low weight (< 10kg)", () => {
    const result = calculate(8, 80, 200, 5, AbilityLevel.Beginner);
    expect(result.warnings.some((w) => w.includes("Very low weight"))).toBe(true);
  });
});

describe("getWarnings", () => {
  it("warns for age <= 3", () => {
    const warnings = getWarnings({
      age: 3,
      heightCm: 90,
      weightKg: 15,
      ability: AbilityLevel.Beginner,
      skiTypes: [SkiType.Alpine],
    });
    expect(warnings.some((w) => w.includes("under 3"))).toBe(true);
  });

  it("does NOT warn for age 4", () => {
    const warnings = getWarnings({
      age: 4,
      heightCm: 100,
      weightKg: 17,
      ability: AbilityLevel.Beginner,
      skiTypes: [SkiType.Alpine],
    });
    expect(warnings.some((w) => w.includes("under 3"))).toBe(false);
  });

  it("warns for XC Skate age < 8", () => {
    const warnings = getWarnings({
      age: 7,
      heightCm: 120,
      weightKg: 22,
      ability: AbilityLevel.Beginner,
      skiTypes: [SkiType.XCSkate],
    });
    expect(warnings.some((w) => w.includes("8 and older"))).toBe(true);
  });

  it("does NOT warn for XC Skate age >= 8", () => {
    const warnings = getWarnings({
      age: 8,
      heightCm: 125,
      weightKg: 25,
      ability: AbilityLevel.Beginner,
      skiTypes: [SkiType.XCSkate],
    });
    expect(warnings.some((w) => w.includes("8 and older"))).toBe(false);
  });

  it("warns for advanced ability age <= 6", () => {
    const warnings = getWarnings({
      age: 6,
      heightCm: 115,
      weightKg: 20,
      ability: AbilityLevel.Advanced,
      skiTypes: [SkiType.Alpine],
    });
    expect(warnings.some((w) => w.includes("Intermediate sizing"))).toBe(true);
  });

  it("does NOT warn for advanced ability age 7", () => {
    const warnings = getWarnings({
      age: 7,
      heightCm: 120,
      weightKg: 22,
      ability: AbilityLevel.Advanced,
      skiTypes: [SkiType.Alpine],
    });
    expect(warnings.some((w) => w.includes("Intermediate sizing"))).toBe(false);
  });
});
