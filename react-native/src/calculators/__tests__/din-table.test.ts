import { AbilityLevel, BSLRange, DINCode } from "../../models/types";
import { bslRangeFrom, dinTableLookup, DIN_TABLE } from "../din-table";

describe("bslRangeFrom", () => {
  it("returns upTo250 for bsl <= 250", () => {
    expect(bslRangeFrom(200)).toBe(BSLRange.upTo250);
    expect(bslRangeFrom(250)).toBe(BSLRange.upTo250);
  });

  it("returns from251to270 for bsl 251-270", () => {
    expect(bslRangeFrom(251)).toBe(BSLRange.from251to270);
    expect(bslRangeFrom(270)).toBe(BSLRange.from251to270);
  });

  it("returns from271to290 for bsl 271-290", () => {
    expect(bslRangeFrom(271)).toBe(BSLRange.from271to290);
    expect(bslRangeFrom(290)).toBe(BSLRange.from271to290);
  });

  it("returns from291to310 for bsl 291-310", () => {
    expect(bslRangeFrom(291)).toBe(BSLRange.from291to310);
    expect(bslRangeFrom(310)).toBe(BSLRange.from291to310);
  });

  it("returns from311to330 for bsl 311-330", () => {
    expect(bslRangeFrom(311)).toBe(BSLRange.from311to330);
    expect(bslRangeFrom(330)).toBe(BSLRange.from311to330);
  });

  it("returns over330 for bsl > 330", () => {
    expect(bslRangeFrom(331)).toBe(BSLRange.over330);
    expect(bslRangeFrom(400)).toBe(BSLRange.over330);
  });
});

describe("DIN_TABLE completeness", () => {
  it("has exactly 78 entries (13 codes × 6 BSL ranges)", () => {
    expect(DIN_TABLE.length).toBe(78);
  });

  it("has 6 entries for each DIN code", () => {
    const codes = Object.values(DINCode);
    for (const code of codes) {
      const entries = DIN_TABLE.filter((e) => e.code === code);
      expect(entries).toHaveLength(6);
    }
  });
});

describe("dinTableLookup", () => {
  it("Code A, upTo250, beginner => 0.75", () => {
    expect(dinTableLookup(DINCode.A, 240, AbilityLevel.Beginner)).toBe(0.75);
  });

  it("Code A, upTo250, intermediate => 0.75", () => {
    expect(dinTableLookup(DINCode.A, 240, AbilityLevel.Intermediate)).toBe(0.75);
  });

  it("Code A, upTo250, advanced => 1.00", () => {
    expect(dinTableLookup(DINCode.A, 240, AbilityLevel.Advanced)).toBe(1.0);
  });

  it("Code A, from271to290, intermediate => 1.00", () => {
    expect(dinTableLookup(DINCode.A, 280, AbilityLevel.Intermediate)).toBe(1.0);
  });

  it("Code D, upTo250, beginner => 2.00", () => {
    expect(dinTableLookup(DINCode.D, 250, AbilityLevel.Beginner)).toBe(2.0);
  });

  it("Code D, upTo250, intermediate => 2.50", () => {
    expect(dinTableLookup(DINCode.D, 250, AbilityLevel.Intermediate)).toBe(2.5);
  });

  it("Code D, from271to290, advanced => 3.50", () => {
    expect(dinTableLookup(DINCode.D, 280, AbilityLevel.Advanced)).toBe(3.5);
  });

  it("Code M, from311to330, beginner => 12.00", () => {
    expect(dinTableLookup(DINCode.M, 320, AbilityLevel.Beginner)).toBe(12.0);
  });

  it("Code M, upTo250, intermediate => 12.00", () => {
    expect(dinTableLookup(DINCode.M, 240, AbilityLevel.Intermediate)).toBe(12.0);
  });

  it("Code K, from271to290, advanced => 12.00", () => {
    expect(dinTableLookup(DINCode.K, 280, AbilityLevel.Advanced)).toBe(12.0);
  });

  it("Code L, over330, beginner => 10.00", () => {
    expect(dinTableLookup(DINCode.L, 340, AbilityLevel.Beginner)).toBe(10.0);
  });

  it("Code C, from311to330, intermediate => 2.25", () => {
    expect(dinTableLookup(DINCode.C, 320, AbilityLevel.Intermediate)).toBe(2.25);
  });

  it("Code J, from271to290, beginner => 7.50", () => {
    expect(dinTableLookup(DINCode.J, 280, AbilityLevel.Beginner)).toBe(7.5);
  });
});
