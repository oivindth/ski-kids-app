import { INPUT_CONSTRAINTS, SkiType } from "../models/types";

export function validateHeight(cm: number): string | null {
  const { min, max } = INPUT_CONSTRAINTS.height;
  if (!Number.isInteger(cm)) return "Height must be a whole number.";
  if (cm < min || cm > max) return `Height must be between ${min} and ${max} cm.`;
  return null;
}

export function validateWeight(kg: number): string | null {
  const { min, max } = INPUT_CONSTRAINTS.weight;
  if (!Number.isInteger(kg)) return "Weight must be a whole number.";
  if (kg < min || kg > max) return `Weight must be between ${min} and ${max} kg.`;
  return null;
}

export function validateAge(age: number): string | null {
  const { min, max } = INPUT_CONSTRAINTS.age;
  if (!Number.isInteger(age)) return "Age must be a whole number.";
  if (age < min || age > max) return `Age must be between ${min} and ${max} years.`;
  return null;
}

export function validateBSL(bslMm: number): string | null {
  const { min, max } = INPUT_CONSTRAINTS.bsl;
  if (!Number.isInteger(bslMm)) return "BSL must be a whole number.";
  if (bslMm < min || bslMm > max) return `BSL must be between ${min} and ${max} mm.`;
  return null;
}

export function validateSkiTypes(types: SkiType[]): string | null {
  if (!types || types.length === 0) return "At least one ski type must be selected.";
  const valid = Object.values(SkiType) as string[];
  for (const t of types) {
    if (!valid.includes(t)) return `Unknown ski type: ${t}`;
  }
  return null;
}

export function validateAll(input: {
  heightCm: number;
  weightKg: number;
  age: number;
  bslMm?: number | null;
  skiTypes: SkiType[];
}): Record<string, string> {
  const errors: Record<string, string> = {};

  const heightError = validateHeight(input.heightCm);
  if (heightError) errors.heightCm = heightError;

  const weightError = validateWeight(input.weightKg);
  if (weightError) errors.weightKg = weightError;

  const ageError = validateAge(input.age);
  if (ageError) errors.age = ageError;

  if (input.bslMm != null) {
    const bslError = validateBSL(input.bslMm);
    if (bslError) errors.bslMm = bslError;
  }

  const skiTypesError = validateSkiTypes(input.skiTypes);
  if (skiTypesError) errors.skiTypes = skiTypesError;

  return errors;
}
