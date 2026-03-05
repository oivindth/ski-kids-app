import { AbilityLevel, DINCode, DINResult, SkiType } from "../models/types";
import { DIN_CODE_METADATA, DIN_CODE_ORDER, dinTableLookup } from "./din-table";

export function codeFromWeight(weightKg: number): DINCode {
  for (const code of DIN_CODE_ORDER) {
    const meta = DIN_CODE_METADATA[code];
    if (weightKg >= meta.weightMin && weightKg <= meta.weightMax) {
      return code;
    }
  }
  return DINCode.A;
}

export function adjustCodeForHeight(code: DINCode, heightCm: number): DINCode {
  let currentCode = code;
  while (heightCm > DIN_CODE_METADATA[currentCode].heightThreshold) {
    const idx = DIN_CODE_ORDER.indexOf(currentCode);
    if (idx + 1 >= DIN_CODE_ORDER.length) break;
    currentCode = DIN_CODE_ORDER[idx + 1];
  }
  return currentCode;
}

export function calculate(
  weightKg: number,
  heightCm: number,
  bslMm: number,
  age: number,
  ability: AbilityLevel
): DINResult {
  const baseCode = codeFromWeight(weightKg);
  const heightAdjustedCode = adjustCodeForHeight(baseCode, heightCm);

  const warnings: string[] = [];
  let adjustedCode: DINCode;

  if (age <= 12 && heightAdjustedCode !== baseCode) {
    adjustedCode = baseCode;
    warnings.push(
      "Height suggests a higher DIN code, but the lower (weight-based) setting was kept for child safety."
    );
  } else {
    adjustedCode = heightAdjustedCode;
  }

  let dinValue = dinTableLookup(adjustedCode, bslMm, ability);

  let isJuniorAdjusted = false;
  let lookupCode = adjustedCode;

  if (age <= 9) {
    const idx = DIN_CODE_ORDER.indexOf(adjustedCode);
    if (idx > 0) {
      lookupCode = DIN_CODE_ORDER[idx - 1];
      dinValue = dinTableLookup(lookupCode, bslMm, ability);
    }
    isJuniorAdjusted = true;
  }

  dinValue = Math.min(dinValue, 12.0);
  dinValue = Math.round(dinValue * 4) / 4;

  let skierType: string;
  switch (ability) {
    case AbilityLevel.Beginner:
      skierType = "Type I";
      break;
    case AbilityLevel.Intermediate:
      skierType = "Type II";
      break;
    case AbilityLevel.Advanced:
      skierType = "Type III";
      break;
    default:
      skierType = "Type I";
  }

  if (dinValue > 6.0 && age <= 12) {
    warnings.push(
      "High DIN setting recommended. This should be verified by a certified ski technician. Some junior bindings do not support settings above 6."
    );
  }

  if (weightKg < 10) {
    warnings.push(
      "Very low weight detected. Verify minimum binding DIN capability with your ski technician."
    );
  }

  return {
    value: dinValue,
    code: lookupCode,
    skierType,
    isJuniorAdjusted,
    warnings,
  };
}

export function getWarnings(child: {
  age: number;
  heightCm: number;
  weightKg: number;
  ability: AbilityLevel;
  skiTypes: SkiType[];
}): string[] {
  const warnings: string[] = [];

  if (child.age <= 3) {
    warnings.push(
      "For children under 3, consult a certified ski school. Sizing varies widely and individual assessment is recommended."
    );
  }

  if (child.skiTypes.includes(SkiType.XCSkate) && child.age < 8) {
    warnings.push(
      "Skate skiing is generally recommended for children 8 and older. Classic technique should be learned first."
    );
  }

  if (child.ability === AbilityLevel.Advanced && child.age <= 6) {
    warnings.push(
      "For children 6 and under, we recommend starting at Intermediate sizing even if ability is advanced, to maintain manoeuvrability."
    );
  }

  return warnings;
}
