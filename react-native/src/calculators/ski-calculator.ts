import { AbilityLevel, SkiLengthRange } from "../models/types";

type AgeBracket = "under5" | "age5to7" | "age8to11" | "age12plus";

function ageBracketFrom(age: number): AgeBracket {
  if (age < 5) return "under5";
  if (age <= 7) return "age5to7";
  if (age <= 11) return "age8to11";
  return "age12plus";
}

export function roundToNearestFive(value: number): number {
  return Math.round(value / 5) * 5;
}

export function alpineSkiLength(
  heightCm: number,
  age: number,
  ability: AbilityLevel
): SkiLengthRange {
  let effectiveAbility = ability;
  if (age <= 6 && ability === AbilityLevel.Advanced) {
    effectiveAbility = AbilityLevel.Intermediate;
  }

  if (age <= 3) {
    const minLen = roundToNearestFive(heightCm - 15);
    const maxLen = roundToNearestFive(heightCm - 10);
    return { minCm: Math.max(minLen, 50), maxCm: Math.max(maxLen, 55) };
  }

  if (age >= 4 && age <= 6 && effectiveAbility === AbilityLevel.Beginner) {
    const len = roundToNearestFive(heightCm * 0.8);
    return { minCm: len, maxCm: len };
  }

  switch (effectiveAbility) {
    case AbilityLevel.Beginner: {
      const minLen = roundToNearestFive(heightCm * 0.85);
      const maxLen = roundToNearestFive(heightCm * 0.9);
      return { minCm: minLen, maxCm: maxLen };
    }
    case AbilityLevel.Intermediate: {
      const minLen = roundToNearestFive(heightCm * 0.9);
      const maxLen = roundToNearestFive(heightCm * 0.95);
      return { minCm: minLen, maxCm: maxLen };
    }
    case AbilityLevel.Advanced: {
      const minLen = roundToNearestFive(heightCm * 0.95);
      const maxLen = roundToNearestFive(heightCm * 1.0);
      return { minCm: minLen, maxCm: maxLen };
    }
  }
}

export function classicXCSkiLength(
  heightCm: number,
  age: number,
  ability: AbilityLevel
): SkiLengthRange {
  const bracket = ageBracketFrom(age);
  let rawMin: number;
  let rawMax: number;

  if (bracket === "under5") {
    rawMin = heightCm - 5;
    rawMax = heightCm;
  } else if (bracket === "age5to7") {
    if (ability === AbilityLevel.Beginner) {
      rawMin = heightCm;
      rawMax = heightCm + 5;
    } else {
      rawMin = heightCm + 5;
      rawMax = heightCm + 10;
    }
  } else if (bracket === "age8to11") {
    switch (ability) {
      case AbilityLevel.Beginner:
        rawMin = heightCm + 5;
        rawMax = heightCm + 10;
        break;
      case AbilityLevel.Intermediate:
        rawMin = heightCm + 10;
        rawMax = heightCm + 15;
        break;
      case AbilityLevel.Advanced:
        rawMin = heightCm + 15;
        rawMax = heightCm + 20;
        break;
    }
  } else {
    switch (ability) {
      case AbilityLevel.Beginner:
        rawMin = heightCm + 10;
        rawMax = heightCm + 15;
        break;
      case AbilityLevel.Intermediate:
        rawMin = heightCm + 15;
        rawMax = heightCm + 20;
        break;
      case AbilityLevel.Advanced:
        rawMin = heightCm + 20;
        rawMax = heightCm + 25;
        break;
    }
  }

  return {
    minCm: roundToNearestFive(rawMin!),
    maxCm: roundToNearestFive(rawMax!),
  };
}

export function skateXCSkiLength(
  heightCm: number,
  age: number,
  ability: AbilityLevel
): SkiLengthRange | null {
  if (age < 8) return null;

  let rawMin: number;
  let rawMax: number;

  if (age >= 8 && age <= 9) {
    switch (ability) {
      case AbilityLevel.Beginner:
        rawMin = heightCm;
        rawMax = heightCm + 5;
        break;
      case AbilityLevel.Intermediate:
      case AbilityLevel.Advanced:
        rawMin = heightCm + 5;
        rawMax = heightCm + 5;
        break;
    }
  } else if (age >= 10 && age <= 11) {
    switch (ability) {
      case AbilityLevel.Beginner:
        rawMin = heightCm + 5;
        rawMax = heightCm + 5;
        break;
      case AbilityLevel.Intermediate:
        rawMin = heightCm + 7.5;
        rawMax = heightCm + 7.5;
        break;
      case AbilityLevel.Advanced:
        rawMin = heightCm + 10;
        rawMax = heightCm + 10;
        break;
    }
  } else {
    switch (ability) {
      case AbilityLevel.Beginner:
        rawMin = heightCm + 5;
        rawMax = heightCm + 5;
        break;
      case AbilityLevel.Intermediate:
        rawMin = heightCm + 7.5;
        rawMax = heightCm + 7.5;
        break;
      case AbilityLevel.Advanced:
        rawMin = heightCm + 10;
        rawMax = heightCm + 10;
        break;
    }
  }

  return {
    minCm: roundToNearestFive(rawMin!),
    maxCm: roundToNearestFive(rawMax!),
  };
}

export function alpinePoleLength(heightCm: number): number {
  return roundToNearestFive(heightCm * 0.68);
}

export function xcClassicPoleLength(heightCm: number): number {
  return roundToNearestFive(heightCm * 0.84);
}

export function xcSkatePoleLength(heightCm: number): number {
  return roundToNearestFive(heightCm * 0.89);
}

export function estimatedBSLFromEUSize(euSize: number): number {
  if (euSize < 15) return 145;
  if (euSize <= 16) return 150;
  if (euSize <= 18) return 165;
  if (euSize <= 20) return 178;
  if (euSize <= 22) return 192;
  if (euSize <= 24) return 207;
  if (euSize <= 26) return 217;
  if (euSize <= 28) return 228;
  if (euSize <= 30) return 238;
  if (euSize <= 32) return 258;
  if (euSize <= 34) return 268;
  if (euSize <= 36) return 285;
  if (euSize <= 38) return 298;
  return 310;
}

export function estimatedBSLFromHeight(heightCm: number): number {
  if (heightCm <= 85) return 170;
  if (heightCm <= 95) return 185;
  if (heightCm <= 105) return 200;
  if (heightCm <= 115) return 215;
  if (heightCm <= 125) return 235;
  if (heightCm <= 135) return 250;
  if (heightCm <= 145) return 265;
  if (heightCm <= 155) return 280;
  if (heightCm <= 165) return 295;
  if (heightCm <= 175) return 305;
  return 315;
}

export function helmetSizeEstimate(age: number): string {
  if (age <= 3) return "47–51 cm (XS)";
  if (age <= 6) return "51–55 cm (S)";
  if (age <= 11) return "55–59 cm (M)";
  return "55–62 cm (M/L)";
}

export function bootFlexRecommendation(age: number, ability: AbilityLevel): string {
  if (age < 5) return "Soft shell";
  if (age <= 9) {
    switch (ability) {
      case AbilityLevel.Beginner:
        return "50–60";
      case AbilityLevel.Intermediate:
        return "60–70";
      case AbilityLevel.Advanced:
        return "60–80";
      default:
        return "50–60";
    }
  }
  if (age <= 12) {
    switch (ability) {
      case AbilityLevel.Beginner:
        return "60–70";
      case AbilityLevel.Intermediate:
        return "70–80";
      case AbilityLevel.Advanced:
        return "80–90";
      default:
        return "60–70";
    }
  }
  switch (ability) {
    case AbilityLevel.Beginner:
      return "70–80";
    case AbilityLevel.Intermediate:
      return "80–100";
    case AbilityLevel.Advanced:
      return "90–110";
    default:
      return "70–80";
  }
}

export function growthRoomGuide(age: number): string {
  if (age <= 10) return "1.0–1.5 cm";
  if (age <= 14) return "0.5–1.0 cm";
  return "0–0.5 cm";
}
