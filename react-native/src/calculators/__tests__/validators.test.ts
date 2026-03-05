import { SkiType } from "../../models/types";
import {
  validateHeight,
  validateWeight,
  validateAge,
  validateBSL,
  validateSkiTypes,
  validateAll,
} from "../validators";

describe("validateHeight", () => {
  it("returns null for valid height at minimum boundary (60)", () => {
    expect(validateHeight(60)).toBeNull();
  });

  it("returns null for valid height at maximum boundary (210)", () => {
    expect(validateHeight(210)).toBeNull();
  });

  it("returns null for valid height in range", () => {
    expect(validateHeight(130)).toBeNull();
  });

  it("returns error for height below minimum (59)", () => {
    expect(validateHeight(59)).not.toBeNull();
  });

  it("returns error for height above maximum (211)", () => {
    expect(validateHeight(211)).not.toBeNull();
  });

  it("returns error for non-integer height", () => {
    expect(validateHeight(130.5)).not.toBeNull();
  });
});

describe("validateWeight", () => {
  it("returns null for valid weight at minimum boundary (8)", () => {
    expect(validateWeight(8)).toBeNull();
  });

  it("returns null for valid weight at maximum boundary (120)", () => {
    expect(validateWeight(120)).toBeNull();
  });

  it("returns null for valid weight in range", () => {
    expect(validateWeight(30)).toBeNull();
  });

  it("returns error for weight below minimum (7)", () => {
    expect(validateWeight(7)).not.toBeNull();
  });

  it("returns error for weight above maximum (121)", () => {
    expect(validateWeight(121)).not.toBeNull();
  });

  it("returns error for non-integer weight", () => {
    expect(validateWeight(25.5)).not.toBeNull();
  });
});

describe("validateAge", () => {
  it("returns null for valid age at minimum boundary (2)", () => {
    expect(validateAge(2)).toBeNull();
  });

  it("returns null for valid age at maximum boundary (99)", () => {
    expect(validateAge(99)).toBeNull();
  });

  it("returns null for valid age in range", () => {
    expect(validateAge(10)).toBeNull();
  });

  it("returns error for age below minimum (1)", () => {
    expect(validateAge(1)).not.toBeNull();
  });

  it("returns error for age above maximum (100)", () => {
    expect(validateAge(100)).not.toBeNull();
  });

  it("returns error for non-integer age", () => {
    expect(validateAge(8.5)).not.toBeNull();
  });
});

describe("validateBSL", () => {
  it("returns null for valid BSL at minimum boundary (150)", () => {
    expect(validateBSL(150)).toBeNull();
  });

  it("returns null for valid BSL at maximum boundary (380)", () => {
    expect(validateBSL(380)).toBeNull();
  });

  it("returns null for valid BSL in range", () => {
    expect(validateBSL(250)).toBeNull();
  });

  it("returns error for BSL below minimum (149)", () => {
    expect(validateBSL(149)).not.toBeNull();
  });

  it("returns error for BSL above maximum (381)", () => {
    expect(validateBSL(381)).not.toBeNull();
  });

  it("returns error for non-integer BSL", () => {
    expect(validateBSL(250.5)).not.toBeNull();
  });
});

describe("validateSkiTypes", () => {
  it("returns null for valid single ski type", () => {
    expect(validateSkiTypes([SkiType.Alpine])).toBeNull();
  });

  it("returns null for multiple valid ski types", () => {
    expect(validateSkiTypes([SkiType.Alpine, SkiType.XCClassic])).toBeNull();
  });

  it("returns error for empty array", () => {
    expect(validateSkiTypes([])).not.toBeNull();
  });

  it("returns error for unknown ski type", () => {
    expect(validateSkiTypes(["Unknown" as SkiType])).not.toBeNull();
  });
});

describe("validateAll", () => {
  it("returns empty object for all valid inputs", () => {
    const errors = validateAll({
      heightCm: 130,
      weightKg: 30,
      age: 10,
      bslMm: 250,
      skiTypes: [SkiType.Alpine],
    });
    expect(Object.keys(errors)).toHaveLength(0);
  });

  it("returns errors for invalid height and weight", () => {
    const errors = validateAll({
      heightCm: 30,
      weightKg: 150,
      age: 10,
      skiTypes: [SkiType.Alpine],
    });
    expect(errors).toHaveProperty("heightCm");
    expect(errors).toHaveProperty("weightKg");
    expect(errors).not.toHaveProperty("age");
  });

  it("does not include bslMm error when bslMm is null", () => {
    const errors = validateAll({
      heightCm: 130,
      weightKg: 30,
      age: 10,
      bslMm: null,
      skiTypes: [SkiType.Alpine],
    });
    expect(errors).not.toHaveProperty("bslMm");
  });

  it("includes bslMm error when bslMm is out of range", () => {
    const errors = validateAll({
      heightCm: 130,
      weightKg: 30,
      age: 10,
      bslMm: 100,
      skiTypes: [SkiType.Alpine],
    });
    expect(errors).toHaveProperty("bslMm");
  });

  it("returns all errors when all fields are invalid", () => {
    const errors = validateAll({
      heightCm: 30,
      weightKg: 150,
      age: 0,
      bslMm: 50,
      skiTypes: [],
    });
    expect(errors).toHaveProperty("heightCm");
    expect(errors).toHaveProperty("weightKg");
    expect(errors).toHaveProperty("age");
    expect(errors).toHaveProperty("bslMm");
    expect(errors).toHaveProperty("skiTypes");
  });
});
