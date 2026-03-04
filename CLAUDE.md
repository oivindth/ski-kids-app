# SkiKids

iOS app helping parents find correct ski equipment sizes for their children.

## Tech Stack

- **Language:** Swift (iOS 17+)
- **UI:** SwiftUI with @Observable view models
- **Persistence:** SwiftData (@Model, @Query)
- **Build:** Xcode project (no SPM dependencies)

## Architecture

```
SkiKids/
  SkiKidsApp.swift          # Entry point, injects modelContainer
  Models/                   # SwiftData entities and value types
  Utilities/                # Pure calculation logic (no UI)
  ViewModels/               # @Observable classes bridging models ↔ views
  Views/                    # SwiftUI views organized by feature
    Home/                   # Child profile list
    Calculator/             # Form, results, DIN detail
    QuickCalc/              # Ephemeral calculator (no save)
    Components/             # Reusable UI components
    Tips/                   # Static info and checklists
```

## Key Design Decisions

- **Navigation:** Tab bar (My Kids / Quick Calc / Tips). HomeView owns the NavigationStack. CalculatorFormView wraps itself in NavigationStack only when presented as a sheet (new child), not when pushed (editing).
- **DIN calculations are safety-critical.** DINTable.swift contains the full ISO 11088 lookup table. DINCalculator.swift applies weight→code, height adjustment (conservative for children ≤12), BSL lookup, junior adjustment, and skier type. Always display the safety disclaimer.
- **BSL estimation fallback:** BSL → EU shoe size → height-based lookup table. The estimation method is tracked and shown in warnings.
- **Ski length rounding:** All ski lengths round to nearest 5cm via `SkiCalculator.roundToNearestFive` (accepts both Double and Int).
- **Age guards:** Skate XC returns nil for age < 8. Alpine ages ≤3 use height-based formula. Ages 4-6 beginner override uses height × 0.80.

## Conventions

- Colors defined in `AppColors` (ContentView.swift) using hex extension
- Reusable form components: `FormCard`, `StepperRow`, `AbilityRow`, `SkiTypeRow`
- Enums `AbilityLevel`, `SkiType`, `DINCode`, `BSLRange` defined in Models/
- Requirements and sizing formulas documented in REQUIREMENTS.md

## Testing DIN Values

When modifying DIN calculations, verify against the ISO 11088 table in REQUIREMENTS.md Appendix A. Key test cases:
- Child 25kg, 130cm, age 8, beginner → Code D, junior adjusted to Code C
- Junior adjustment: age ≤9 → shift one code up (lower/safer), per ISO 11088
- Height adjustment: for children ≤12, keep the weight-based (lower) code
