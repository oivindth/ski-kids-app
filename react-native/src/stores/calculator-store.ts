import { create } from 'zustand';
import {
  AbilityLevel,
  BSLInputMode,
  Child,
  DINResult,
  SkiRecommendation,
  SkiType,
} from '../models/types';
import { calculate as dinCalculate, getWarnings } from '../calculators/din-calculator';
import {
  alpineSkiLength,
  alpinePoleLength,
  classicXCSkiLength,
  estimatedBSLFromEUSize,
  estimatedBSLFromHeight,
  skateXCSkiLength,
  xcClassicPoleLength,
  xcSkatePoleLength,
} from '../calculators/ski-calculator';
import {
  validateAge,
  validateBSL,
  validateHeight,
  validateSkiTypes,
  validateWeight,
} from '../calculators/validators';

interface CalculatorState {
  name: string;
  heightCm: number;
  weightKg: number;
  age: number;
  bslMm: number;
  bslInputMode: BSLInputMode;
  shoeSize: number;
  abilityLevel: AbilityLevel;
  selectedSkiTypes: SkiType[];

  recommendation: SkiRecommendation | null;
  hasAttemptedCalculation: boolean;

  setName: (name: string) => void;
  setHeightCm: (height: number) => void;
  setWeightKg: (weight: number) => void;
  setAge: (age: number) => void;
  setBslMm: (bsl: number) => void;
  setBslInputMode: (mode: BSLInputMode) => void;
  setShoeSize: (size: number) => void;
  setAbilityLevel: (level: AbilityLevel) => void;
  toggleSkiType: (type: SkiType) => void;

  calculate: () => boolean;
  populateFromChild: (child: Child) => void;
  reset: () => void;

  getHeightError: () => string | null;
  getWeightError: () => string | null;
  getAgeError: () => string | null;
  getBslError: () => string | null;
  getSkiTypeError: () => string | null;
  getValidationErrors: () => string[];
  isValid: () => boolean;
}

const DEFAULT_STATE = {
  name: '',
  heightCm: 120,
  weightKg: 25,
  age: 8,
  bslMm: 230,
  bslInputMode: BSLInputMode.Estimate,
  shoeSize: 32,
  abilityLevel: AbilityLevel.Beginner,
  selectedSkiTypes: [SkiType.Alpine] as SkiType[],
  recommendation: null,
  hasAttemptedCalculation: false,
};

export const useCalculatorStore = create<CalculatorState>()((set, get) => ({
  ...DEFAULT_STATE,

  setName: (name) => set({ name }),
  setHeightCm: (heightCm) => set({ heightCm }),
  setWeightKg: (weightKg) => set({ weightKg }),
  setAge: (age) => set({ age }),
  setBslMm: (bslMm) => set({ bslMm }),
  setBslInputMode: (bslInputMode) => set({ bslInputMode }),
  setShoeSize: (shoeSize) => set({ shoeSize }),
  setAbilityLevel: (abilityLevel) => set({ abilityLevel }),

  toggleSkiType: (type) =>
    set((state) => {
      const exists = state.selectedSkiTypes.includes(type);
      if (exists) {
        return { selectedSkiTypes: state.selectedSkiTypes.filter((t) => t !== type) };
      }
      return { selectedSkiTypes: [...state.selectedSkiTypes, type] };
    }),

  getHeightError: () => validateHeight(get().heightCm),
  getWeightError: () => validateWeight(get().weightKg),
  getAgeError: () => validateAge(get().age),
  getBslError: () => {
    const { bslInputMode, bslMm } = get();
    if (bslInputMode === BSLInputMode.BSL) {
      return validateBSL(bslMm);
    }
    return null;
  },
  getSkiTypeError: () => validateSkiTypes(get().selectedSkiTypes),

  getValidationErrors: () => {
    const state = get();
    const errors: string[] = [];

    const heightError = validateHeight(state.heightCm);
    if (heightError) errors.push(heightError);

    const weightError = validateWeight(state.weightKg);
    if (weightError) errors.push(weightError);

    const ageError = validateAge(state.age);
    if (ageError) errors.push(ageError);

    if (state.bslInputMode === BSLInputMode.BSL) {
      const bslError = validateBSL(state.bslMm);
      if (bslError) errors.push(bslError);
    }

    const skiTypeError = validateSkiTypes(state.selectedSkiTypes);
    if (skiTypeError) errors.push(skiTypeError);

    return errors;
  },

  isValid: () => get().getValidationErrors().length === 0,

  calculate: () => {
    set({ hasAttemptedCalculation: true });

    const state = get();
    if (!state.isValid()) {
      return false;
    }

    const { heightCm, weightKg, age, bslMm, bslInputMode, shoeSize, abilityLevel, selectedSkiTypes, name } = state;

    let effectiveBSL: number;
    let bslEstimationMethod: string | null = null;

    if (bslInputMode === BSLInputMode.BSL) {
      effectiveBSL = bslMm;
    } else if (bslInputMode === BSLInputMode.ShoeSize) {
      effectiveBSL = estimatedBSLFromEUSize(shoeSize);
      bslEstimationMethod = `shoe size (EU ${shoeSize})`;
    } else {
      effectiveBSL = estimatedBSLFromHeight(heightCm);
      bslEstimationMethod = `height (${heightCm} cm)`;
    }

    const globalWarnings: string[] = getWarnings({
      age,
      heightCm,
      weightKg,
      ability: abilityLevel,
      skiTypes: selectedSkiTypes,
    });

    const alpineLength = selectedSkiTypes.includes(SkiType.Alpine)
      ? alpineSkiLength(heightCm, age, abilityLevel)
      : null;

    let dinResult: DINResult | null = null;
    if (selectedSkiTypes.includes(SkiType.Alpine)) {
      if (age <= 3) {
        globalWarnings.push(
          'DIN settings are not calculated for children age 3 and under. Please consult a certified ski school for binding setup.'
        );
      } else {
        const result = dinCalculate(weightKg, heightCm, effectiveBSL, age, abilityLevel);
        dinResult = result;
        globalWarnings.push(...result.warnings);
      }
    }

    const xcClassicLength = selectedSkiTypes.includes(SkiType.XCClassic)
      ? classicXCSkiLength(heightCm, age, abilityLevel)
      : null;

    const xcSkateLength = selectedSkiTypes.includes(SkiType.XCSkate)
      ? skateXCSkiLength(heightCm, age, abilityLevel)
      : null;

    const alpinePole = selectedSkiTypes.includes(SkiType.Alpine)
      ? alpinePoleLength(heightCm)
      : null;

    const xcClassicPole = selectedSkiTypes.includes(SkiType.XCClassic)
      ? xcClassicPoleLength(heightCm)
      : null;

    const xcSkatePole =
      selectedSkiTypes.includes(SkiType.XCSkate) && xcSkateLength !== null
        ? xcSkatePoleLength(heightCm)
        : null;

    if (bslInputMode !== BSLInputMode.BSL && selectedSkiTypes.includes(SkiType.Alpine)) {
      if (bslEstimationMethod) {
        globalWarnings.unshift(
          `Boot sole length not provided. BSL was estimated from ${bslEstimationMethod}. Provide the actual Boot Sole Length (printed inside the boot) for accurate DIN results.`
        );
      }
    }

    const deduplicatedWarnings = globalWarnings.reduce<string[]>((acc, warning) => {
      if (!acc.includes(warning)) acc.push(warning);
      return acc;
    }, []);

    const recommendation: SkiRecommendation = {
      childName: name,
      heightCm,
      weightKg,
      age,
      abilityLevel,
      skiTypes: selectedSkiTypes,
      alpineSkiLength: alpineLength,
      dinResult,
      xcClassicLength,
      xcSkateLength,
      alpinePoleLength: alpinePole,
      xcClassicPoleLength: xcClassicPole,
      xcSkatePoleLength: xcSkatePole,
      warnings: deduplicatedWarnings,
      calculatedAt: new Date(),
    };

    set({ recommendation });
    return true;
  },

  populateFromChild: (child) => {
    const mode: BSLInputMode = (child.bslInputModeRaw ?? BSLInputMode.Estimate) as BSLInputMode;

    const update: Partial<CalculatorState> = {
      name: child.name,
      heightCm: child.heightCm,
      weightKg: child.weightKg,
      age: child.age,
      bslInputMode: mode,
      bslMm: DEFAULT_STATE.bslMm,
      shoeSize: DEFAULT_STATE.shoeSize,
      abilityLevel: child.abilityLevel,
      selectedSkiTypes: child.skiTypes,
      recommendation: null,
      hasAttemptedCalculation: false,
    };

    if (mode === BSLInputMode.ShoeSize && child.shoeSize != null) {
      update.shoeSize = child.shoeSize;
    } else if (mode === BSLInputMode.BSL && child.bslMm != null) {
      update.bslMm = child.bslMm;
    }

    set(update);
  },

  reset: () => set({ ...DEFAULT_STATE, selectedSkiTypes: [...DEFAULT_STATE.selectedSkiTypes] }),
}));
