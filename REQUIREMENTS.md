# Kids' Ski Equipment Sizing App — Product Requirements Document

**Version:** 1.0  
**Date:** 2026-03-03  
**Author:** Product Owner  
**Status:** Draft for iOS Development

---

## Table of Contents

1. [Overview](#overview)
2. [User Input Fields](#user-input-fields)
3. [Cross-Country Ski Length](#cross-country-ski-length)
4. [Alpine / Downhill Ski Length](#alpine--downhill-ski-length)
5. [DIN Settings (Alpine Bindings)](#din-settings-alpine-bindings)
6. [Ski Pole Length](#ski-pole-length)
7. [Boot Sizing](#boot-sizing)
8. [Additional Features](#additional-features)
9. [Appendix: Reference Tables](#appendix-reference-tables)

---

## Overview

This app helps parents size ski equipment for children using industry-standard formulas and lookup tables derived from ISO 11088 and widely adopted retailer guidelines (REI, Salomon, Nordica, Rossignol, and certified ski shop protocols). The app covers alpine/downhill skiing and cross-country (classic and skate) skiing.

Safety note: DIN settings in particular carry real liability. The app must display a disclaimer that all DIN values are recommendations only and should be verified and set by a certified ski technician.

---

## User Input Fields

These are the inputs collected per child profile. All fields except name are required for full calculation output.

| Field | Type | Constraints | Notes |
|---|---|---|---|
| Child Name | Text (optional) | Max 50 chars | For profile identification |
| Height | Integer (cm) | 60–200 cm | Measured without shoes |
| Weight | Integer (kg) | 8–80 kg | Used for DIN and pole sizing |
| Age | Integer (years) | 2–17 | Used for DIN adjustment and age-bracket logic |
| Boot Sole Length (BSL) | Integer (mm) | 150–330 mm | Optional; needed for precise DIN lookup. Can be estimated from shoe size if unknown |
| Ability Level | Enum | Beginner / Intermediate / Advanced | Used for ski length and DIN type |
| Ski Type | Enum (multi-select) | Alpine, XC Classic, XC Skate | Determines which calculations to show |

### Ability Level Definitions (display in app)

- **Beginner:** Just starting out; cautious; mostly on groomed easy runs or flat terrain (DIN Type I)
- **Intermediate:** Comfortable on groomed runs; skiing most terrain; moderate speed (DIN Type II)
- **Advanced:** Aggressive; skiing all terrain including moguls, off-piste, or racing (DIN Type III)

### Boot Sole Length (BSL) Estimation Table

If BSL is unknown, estimate from EU shoe size. Show this as a helper in the app with a note that actual BSL varies by boot brand and must be confirmed from the boot.

| EU Size | Approx BSL (mm) |
|---|---|
| 15–16 | 150–165 |
| 17–18 | 166–180 |
| 19–20 | 181–195 |
| 21–22 | 196–210 |
| 23–24 | 211–225 |
| 25–26 | 226–240 |
| 27–28 | 241–255 |
| 29–30 | 256–270 |
| 31–32 | 271–285 |
| 33–34 | 286–300 |
| 35–36 | 301–315 |
| 37–38 | 316–330 |

---

## Cross-Country Ski Length

### Background

Cross-country ski sizing depends primarily on height, but also on ski type (classic vs. skate), the specific technique being used, and whether the child is a beginner. Classic skis have a kick zone and need to grip the snow, so they are longer. Skate skis have no kick zone and are shorter for better edge control.

For young children (under 5–6), sizing precision matters less because they ski on very gentle terrain with short skis designed for balance. The priority is manageability.

### Classic Cross-Country Ski Sizing

**General formula:**

```
Recommended ski length = Child height (cm) + offset (cm)
```

| Age Group | Ability | Offset | Example (110 cm child) |
|---|---|---|---|
| Under 5 yrs | Any | height – 5 to height (no offset or negative) | 100–110 cm |
| 5–7 yrs | Beginner | height + 0 to +5 cm | 110–115 cm |
| 5–7 yrs | Intermediate+ | height + 5 to +10 cm | 115–120 cm |
| 8–11 yrs | Beginner | height + 5 to +10 cm | 115–120 cm |
| 8–11 yrs | Intermediate | height + 10 to +15 cm | 120–125 cm |
| 8–11 yrs | Advanced | height + 15 to +20 cm | 125–130 cm |
| 12+ yrs | Beginner | height + 10 cm | — |
| 12+ yrs | Intermediate | height + 15 cm | — |
| 12+ yrs | Advanced | height + 20 to +25 cm | — |

**Simplified formula for app output (two values: min and max):**

```swift
// Classic XC - returns a range [minLength, maxLength] in cm
func classicXCSkiLength(heightCm: Int, ageBracket: AgeBracket, ability: Ability) -> (Int, Int) {
    switch (ageBracket, ability) {
    case (.under5, _):       return (heightCm - 5, heightCm)
    case (.age5to7, .beginner):      return (heightCm, heightCm + 5)
    case (.age5to7, .intermediate),
         (.age5to7, .advanced):      return (heightCm + 5, heightCm + 10)
    case (.age8to11, .beginner):     return (heightCm + 5, heightCm + 10)
    case (.age8to11, .intermediate): return (heightCm + 10, heightCm + 15)
    case (.age8to11, .advanced):     return (heightCm + 15, heightCm + 20)
    case (.age12plus, .beginner):    return (heightCm + 10, heightCm + 10)
    case (.age12plus, .intermediate):return (heightCm + 15, heightCm + 15)
    case (.age12plus, .advanced):    return (heightCm + 20, heightCm + 25)
    }
}
```

**Age bracket thresholds:**
- under5: age < 5
- age5to7: age >= 5 && age <= 7
- age8to11: age >= 8 && age <= 11
- age12plus: age >= 12

### Skate Cross-Country Ski Sizing

Skate skis are always shorter than classic skis for the same skier. Not appropriate for children under ~7–8 years old; the app should warn or hide this option for children under 7.

**General formula:**

```
Skate ski length = Child height (cm) + offset (cm)
```

| Age Group | Ability | Offset | Example (130 cm child) |
|---|---|---|---|
| 7–9 yrs | Beginner | height + 0 to +5 cm | 130–135 cm |
| 7–9 yrs | Intermediate | height + 5 cm | 135 cm |
| 10–11 yrs | Beginner | height + 5 cm | 135 cm |
| 10–11 yrs | Intermediate | height + 7.5 cm | ~137 cm |
| 10–11 yrs | Advanced | height + 10 cm | 140 cm |
| 12+ yrs | Beginner | height + 5 cm | — |
| 12+ yrs | Intermediate | height + 7.5 cm | — |
| 12+ yrs | Advanced | height + 10 cm | — |

**Simplified formula:**

```
Skate ski length ≈ height × 1.04 to height × 1.08
```

- Beginners and younger kids: multiply height × 1.04
- Intermediate: multiply height × 1.05–1.06
- Advanced: multiply height × 1.07–1.08

### Rounding

Round all ski lengths to the nearest 5 cm, as skis are manufactured in 5 cm increments (e.g., 100, 105, 110, 115...). Display both the calculated value and the rounded "buy this size" recommendation.

```swift
func roundToNearestFive(_ value: Int) -> Int {
    return Int((Double(value) / 5.0).rounded()) * 5
}
```

---

## Alpine / Downhill Ski Length

### Method 1: Height-Based Body Reference (Industry Standard)

This is the most common method used in ski shops and is the primary method for children who do not yet have a precise ability classification.

| Ability Level | Ski tip relative to child | Approximate formula |
|---|---|---|
| Beginner | Chin to nose height | height × 0.85 to height × 0.90 |
| Intermediate | Nose to forehead | height × 0.90 to height × 0.95 |
| Advanced | Forehead to top of head, or taller | height × 0.95 to height × 1.00 |

**Example for a 120 cm child:**

| Level | Range | Example lengths |
|---|---|---|
| Beginner | 120 × 0.85 to 0.90 | 102–108 cm → round to 100–110 cm |
| Intermediate | 120 × 0.90 to 0.95 | 108–114 cm → round to 110–115 cm |
| Advanced | 120 × 0.95 to 1.00 | 114–120 cm → round to 115–120 cm |

### Method 2: Explicit Formulas by Ability

```swift
func alpineSkiLength(heightCm: Int, ability: Ability) -> (min: Int, max: Int) {
    switch ability {
    case .beginner:
        let min = Int(Double(heightCm) * 0.85)
        let max = Int(Double(heightCm) * 0.90)
        return (roundToNearestFive(min), roundToNearestFive(max))
    case .intermediate:
        let min = Int(Double(heightCm) * 0.90)
        let max = Int(Double(heightCm) * 0.95)
        return (roundToNearestFive(min), roundToNearestFive(max))
    case .advanced:
        let min = Int(Double(heightCm) * 0.95)
        let max = Int(Double(heightCm) * 1.00)
        return (roundToNearestFive(min), roundToNearestFive(max))
    }
}
```

### Age/Size Exceptions

- Children under 4–5 years: use "learner/pizza wedge" ski packages sized at height – 10 to height – 15 cm. These are often packaged as complete systems (skis + bindings) and do not require DIN setting.
- Children 4–6 years: ski length can be significantly shorter (chin height or below) to prioritize control and confidence. Override formula: height × 0.80 for beginners.

### Soft vs. Stiff Flex Note

Display in app: "Younger and lighter children should choose softer-flex skis at the lower end of the size range. Heavier or more advanced children can use the upper end of the range."

---

## DIN Settings (Alpine Bindings)

### Critical Safety Disclaimer

**MUST be displayed prominently in the app:**

> DIN release values shown are recommendations based on the ISO 11088 standard lookup table. They must be verified and set by a certified ski technician. Incorrect DIN settings can result in serious injury. The app developer and publisher accept no liability for binding settings applied without professional verification.

### What is DIN?

DIN (Deutsches Institut für Normung) is the release force setting on alpine ski bindings. It controls how easily the binding releases during a fall to prevent injury. Too low = skis release too easily (falls from normal skiing). Too high = skis don't release in a dangerous fall (risk of knee/leg injury).

### Skier Type Classification (ISO 11088)

| Type | Description | Who it fits |
|---|---|---|
| Type I | Cautious; prefers low speeds; easy slopes; willing to accept a higher rate of inadvertent release | Beginners, very young children, elderly |
| Type II | Moderate speeds; variety of slopes; willing to accept some inadvertent release | Most recreational skiers |
| Type III | High speeds; steep/aggressive terrain; prefers low release rate | Advanced, aggressive, racers |
| Type J (Junior) | Children below a specific weight/height threshold | Applied when age ≤ 12 AND weight ≤ 30 kg — subtract 1 from calculated DIN |

**App mapping:**
- Beginner → Type I
- Intermediate → Type II
- Advanced → Type III
- If age ≤ 12: apply Junior adjustment (subtract 1 from final DIN, minimum 0.75)

### Step-by-Step DIN Calculation

The ISO 11088 standard uses a lookup table that cross-references:
1. Skier weight (kg) → selects a row group
2. Boot Sole Length (mm) → adjusts within group
3. Height (cm) → may move row up or down
4. Skier type → selects column

**Step 1: Determine the "code number" from weight and height**

Look up the code number from the table below. If the skier's height places them in a higher row than their weight, use the higher row (more conservative is safer for children — use the lower of the two resulting code numbers when in doubt).

| Code | Weight (kg) | Height (cm) — use higher code if height exceeds |
|---|---|---|
| A | ≤ 10 | ≤ 148 |
| B | 11–13 | ≤ 148 |
| C | 14–17 | ≤ 148 |
| D | 18–21 | ≤ 148 |
| E | 22–25 | ≤ 148 |
| F | 26–30 | ≤ 157 |
| G | 31–35 | ≤ 166 |
| H | 36–41 | ≤ 174 |
| I | 42–48 | ≤ 182 |
| J | 49–57 | ≤ 189 |
| K | 58–66 | ≤ 196 |
| L | 67–78 | ≤ 196 |
| M | 79–94 | > 196 |

**Height adjustment rule:** If the skier's height places them in a higher code letter than their weight alone, use the higher code letter. Example: weight = 28 kg (code F), height = 160 cm (above 157 cm threshold for F) → use code G.

**Step 2: Apply Boot Sole Length (BSL) sub-adjustment**

Within each code group, BSL further refines the DIN value. This is reflected in the full table below.

**Step 3: Read DIN from the master lookup table**

| Code | BSL ≤ 230 mm | BSL 231–270 mm | BSL 271–310 mm | BSL > 310 mm | → Type I | Type II | Type III |
|---|---|---|---|---|---|---|---|
| A | A1 | A2 | A3 | A3 | 0.75 | 1.00 | 1.50 |
| B | B1 | B2 | B3 | B3 | 1.00 | 1.25 | 1.75 |
| C | C1 | C2 | C3 | C3 | 1.25 | 1.50 | 2.00 |
| D | D1 | D2 | D3 | D3 | 1.50 | 2.00 | 2.50 |
| E | E1 | E2 | E3 | E3 | 2.00 | 2.50 | 3.00 |
| F | F1 | F2 | F3 | F3 | 2.50 | 3.00 | 3.50 |
| G | G1 | G2 | G3 | G3 | 3.00 | 3.50 | 4.50 |
| H | H1 | H2 | H3 | H3 | 3.50 | 4.50 | 5.50 |
| I | I1 | I2 | I3 | I3 | 4.50 | 5.50 | 6.50 |
| J | J1 | J2 | J3 | J3 | 5.50 | 6.50 | 7.50 |
| K | K1 | K2 | K3 | K3 | 6.50 | 7.50 | 8.50 |
| L | L1 | L2 | L3 | L3 | 7.50 | 8.50 | 10.0 |
| M | M1 | M2 | M3 | M3 | 8.50 | 10.0 | 12.0 |

**Simplified DIN lookup table (combined, most practical for app implementation):**

This is the standard table used by certified ski shops, based on ISO 11088 / DIN 7881. The primary variables are weight and BSL. Height is used only for upward code adjustment.

```
DIN MASTER TABLE
================
Rows = Code (weight + height adjusted)
Columns = Skier Type I / II / III

Code | Weight(kg) | BSL ≤230 | BSL 231-270 | BSL 271-310 | BSL >310 | Type I | Type II | Type III
-----|------------|----------|-------------|-------------|----------|--------|---------|----------
 A   |  ≤ 10      |  A1      |   A2        |   A3        |  A3      |  0.75  |  1.00   |   1.50
 B   |  11–13     |  B1      |   B2        |   B3        |  B3      |  1.00  |  1.25   |   1.75
 C   |  14–17     |  C1      |   C2        |   C3        |  C3      |  1.25  |  1.50   |   2.00
 D   |  18–21     |  D1      |   D2        |   D3        |  D3      |  1.50  |  2.00   |   2.50
 E   |  22–25     |  E1      |   E2        |   E3        |  E3      |  2.00  |  2.50   |   3.00
 F   |  26–30     |  F1      |   F2        |   F3        |  F3      |  2.50  |  3.00   |   3.50
 G   |  31–35     |  G1      |   G2        |   G3        |  G3      |  3.00  |  3.50   |   4.50
 H   |  36–41     |  H1      |   H2        |   H3        |  H3      |  3.50  |  4.50   |   5.50
 I   |  42–48     |  I1      |   I2        |   I3        |  I3      |  4.50  |  5.50   |   6.50
 J   |  49–57     |  J1      |   J2        |   J3        |  J3      |  5.50  |  6.50   |   7.50
 K   |  58–66     |  K1      |   K2        |   K3        |  K3      |  6.50  |  7.50   |   8.50
 L   |  67–78     |  L1      |   L2        |   L3        |  L3      |  7.50  |  8.50   |  10.00
 M   |  79–94     |  M1      |   M2        |   M3        |  M3      |  8.50  | 10.00   |  12.00
```

**BSL adjustment (refines DIN within code row):**

| BSL Range | Adjustment to Type I/II/III value |
|---|---|
| ≤ 230 mm | Use base value as-is (or subtract 0.25 for smallest BSL values) |
| 231–270 mm | Use base value |
| 271–310 mm | Add 0.25–0.5 |
| > 310 mm | Add 0.5 |

For the app: the simplified approach is to use the base Type I/II/III values from the code row. For professional-grade precision, the full BSL-adjusted sub-table should be used (see Appendix).

### Junior Adjustment (Type J)

Apply this rule if: `age <= 12 AND weight <= 30 kg`

```swift
if age <= 12 && weightKg <= 30 {
    din = max(0.75, din - 1.0)
}
```

This reflects the ISO 11088 recommendation that young children's bindings should be set more conservatively.

### DIN Calculation Algorithm (Swift pseudocode)

```swift
func calculateDIN(
    weightKg: Int,
    heightCm: Int,
    bslMm: Int,
    age: Int,
    ability: Ability
) -> Double {

    // Step 1: Determine base code from weight
    let baseCode = codeFromWeight(weightKg)

    // Step 2: Adjust code upward if height exceeds threshold for that code
    let heightAdjustedCode = adjustCodeForHeight(baseCode, heightCm: heightCm)

    // Step 3: Map ability to skier type
    let skierType = skierType(from: ability)  // .typeI, .typeII, .typeIII

    // Step 4: Look up base DIN from table
    var din = dinLookup[heightAdjustedCode][skierType]

    // Step 5: BSL fine-tuning (optional enhancement)
    din = adjustForBSL(din, bslMm: bslMm, code: heightAdjustedCode)

    // Step 6: Junior adjustment
    if age <= 12 && weightKg <= 30 {
        din = max(0.75, din - 1.0)
    }

    // Step 7: Round to nearest 0.25
    din = (din * 4).rounded() / 4

    return din
}
```

### DIN Value Validity Check

Bindings have a range printed on them (e.g., "3–10" or "1–6"). The app should warn:

> "Recommended DIN of [X] is outside the range of many junior bindings ([typical range 0.75–6]). Consult your ski technician about whether your child's bindings can be set to this value."

### Full DIN Reference Table with BSL Sub-Adjustments (Appendix-level detail)

See Appendix A for the complete ISO 11088-derived table with BSL sub-rows. The developer should implement this as a 2D lookup with interpolation disabled (use exact table values, no linear interpolation).

---

## Ski Pole Length

### Alpine / Downhill Poles

**Method 1 (body reference — most reliable):**
Hold pole upside down with the tip pointing up. Grip the pole just below the basket. Elbow should form a 90-degree angle. This is the correct length.

**Method 2 (formula):**
```
Alpine pole length (cm) = height (cm) × 0.68 to 0.70
```

Typical rounding: to nearest 5 cm.

```swift
func alpinePoleLength(heightCm: Int) -> Int {
    let calculated = Double(heightCm) * 0.68
    return roundToNearestFive(Int(calculated))
}
```

**Example table:**

| Child Height (cm) | Formula Result (× 0.68) | Recommended Pole |
|---|---|---|
| 90 | 61 cm | 60 cm |
| 100 | 68 cm | 70 cm |
| 110 | 75 cm | 75 cm |
| 120 | 82 cm | 80 cm |
| 130 | 88 cm | 90 cm |
| 140 | 95 cm | 95 cm |
| 150 | 102 cm | 100 cm |
| 160 | 109 cm | 110 cm |

### Cross-Country Classic Poles

**Formula:**
```
XC Classic pole length (cm) = height (cm) × 0.82 to 0.83
```

The tip of the pole, when held normally, should reach the skier's armpit.

```swift
func xcClassicPoleLength(heightCm: Int) -> Int {
    let calculated = Double(heightCm) * 0.83
    return roundToNearestFive(Int(calculated))
}
```

**Example table:**

| Child Height (cm) | Formula Result (× 0.83) | Recommended Pole |
|---|---|---|
| 90 | 75 cm | 75 cm |
| 100 | 83 cm | 85 cm |
| 110 | 91 cm | 90 cm |
| 120 | 100 cm | 100 cm |
| 130 | 108 cm | 110 cm |
| 140 | 116 cm | 115 cm |
| 150 | 125 cm | 125 cm |
| 160 | 133 cm | 135 cm |

### Cross-Country Skate Poles

Skate poles are significantly longer than classic poles to provide leverage for the skating push.

**Formula:**
```
XC Skate pole length (cm) = height (cm) × 0.87 to 0.90
```

The tip of the pole should reach between chin and nose when standing.

```swift
func xcSkatePoleLength(heightCm: Int) -> Int {
    let calculated = Double(heightCm) * 0.88
    return roundToNearestFive(Int(calculated))
}
```

**Example table:**

| Child Height (cm) | Formula Result (× 0.88) | Recommended Pole |
|---|---|---|
| 100 | 88 cm | 90 cm |
| 110 | 97 cm | 95 cm |
| 120 | 106 cm | 105 cm |
| 130 | 114 cm | 115 cm |
| 140 | 123 cm | 125 cm |
| 150 | 132 cm | 130 cm |
| 160 | 141 cm | 140 cm |

**Note:** Skate skiing is not typically practiced by children under 7–8. App should surface a note: "Skate skiing poles are suitable for children 7 years and older who have mastered classic technique."

---

## Boot Sizing

### The Mondo Point System

Mondo point (MP) is the international standard for ski boot sizing. It represents the foot length in centimeters, measured from heel to the tip of the longest toe.

| Mondo Point | Approximate EU Size | Approximate US Size (kids) |
|---|---|---|
| 15.0 | EU 24 | US 8.5 toddler |
| 15.5 | EU 24.5 | US 9 toddler |
| 16.0 | EU 25 | US 9.5 toddler |
| 16.5 | EU 26 | US 10 toddler |
| 17.0 | EU 27 | US 10.5 toddler |
| 17.5 | EU 28 | US 11 kids |
| 18.0 | EU 29 | US 12 kids |
| 18.5 | EU 29.5 | US 12.5 kids |
| 19.0 | EU 30 | US 13 kids |
| 19.5 | EU 31 | US 1 youth |
| 20.0 | EU 32 | US 2 youth |
| 20.5 | EU 33 | US 2.5 youth |
| 21.0 | EU 33.5 | US 3 youth |
| 21.5 | EU 34 | US 3.5 youth |
| 22.0 | EU 35 | US 4 youth |
| 22.5 | EU 36 | US 4.5 youth |
| 23.0 | EU 37 | US 5 youth |
| 23.5 | EU 38 | US 6 youth |
| 24.0 | EU 38.5 | US 6.5 youth |

### How to Measure Foot Length (show in app as instructions)

1. Place the child's foot on a piece of paper with the heel against a wall.
2. Mark the tip of the longest toe.
3. Measure from the wall to the mark in centimeters.
4. This measurement in cm = Mondo Point size.

### Growth Room Recommendations

| Child Age | Recommended growth room |
|---|---|
| Under 6 | 1.5 cm (15mm) |
| 6–10 | 1.0–1.5 cm |
| 10–14 | 0.5–1.0 cm |
| 14+ | 0–0.5 cm (fit closer for performance) |

**App logic:**
```swift
func recommendedBootMondoPoint(footLengthCm: Double, age: Int) -> (min: Double, max: Double) {
    let growth: Double
    switch age {
    case ..<6:   growth = 1.5
    case 6...10: growth = 1.25
    case 11...13: growth = 0.75
    default:     growth = 0.5
    }
    // Boot shell is typically 0.5–1.0 cm larger than mondo point
    // So recommended mondo = foot length + growth room - liner thickness offset (~0.5)
    let recommendedMin = footLengthCm
    let recommendedMax = footLengthCm + growth
    return (recommendedMin, recommendedMax)
}
```

**Display note in app:**
> "Ski boots should NOT have the same amount of room as regular shoes. Too much room causes foot movement leading to poor control and blisters. For children, 1–1.5 cm of growth room is appropriate. Never buy boots more than 1.5 cm too large."

### Alpine Boot Flex Rating for Kids

| Flex Rating | Suitable For |
|---|---|
| 50–60 | Beginner children, ages 5–9 |
| 60–80 | Intermediate children, ages 8–12 |
| 80–100 | Advanced/teen skiers, ages 12+ |

Display in app as a recommendation alongside the size.

### Cross-Country Ski Boots

XC boots are sized identically to Mondo point / EU sizing. Key differences:
- Classic boots: lower cut, flexible; sole compatible with NNN or SNS binding system
- Skate boots: higher cuff, stiffer; same binding systems
- Note in app: **NNN and SNS bindings are NOT compatible with each other.** Skis, boots, and bindings must match the same system.

**Binding system note to display:**
> "Make sure your boots and bindings use the same system: NNN (Rottefella) or SNS/Prolink (Salomon). These are NOT interchangeable."

---

## Additional Features

### 1. Child Profiles

- Support saving multiple child profiles (minimum 5 profiles, ideally unlimited with iCloud sync)
- Profile data: name, date of birth (used to auto-update age), height, weight, boot size (mondo), last updated date
- Show "Last measured: [date]" on each profile

### 2. Growth Tracking and Upgrade Alerts

Track measurements over time and alert parents when equipment is likely outgrown.

**Alpine ski upgrade trigger:**
```
Alert when: current ski length < (current height × abilityMinFactor - 10 cm)
```
i.e., when the child has grown enough that their skis are now more than 10 cm too short.

**XC ski upgrade trigger:**
```
Alert when: current ski length < (current height + minimumOffset - 5 cm)
```

**Boot upgrade trigger:**
```
Alert when: foot length > (current boot mondo point + 0.5 cm)
```
i.e., the child is within 0.5 cm of outgrowing the boot.

**Pole upgrade trigger:**
```
Alert when: recommended pole length differs from current by more than 5 cm
```

**Notification copy examples:**
- "Sofia may have outgrown her skis! She has grown 8 cm since her last measurement. Tap to see new recommendations."
- "Time to check Erik's boots — his foot may be approaching the end of the growth room."

### 3. Equipment Checklist

Provide a pre-season checklist for parents. Display as a checklist screen per child.

**Alpine Checklist:**

- [ ] Helmet (certified: EN 1077 or ASTM F2040) — sized to head circumference
- [ ] Goggles (UV protection, fog-resistant lens)
- [ ] Ski jacket (waterproof, windproof)
- [ ] Ski pants (waterproof, reinforced knees)
- [ ] Gloves or mittens (waterproof, warm)
- [ ] Ski socks (wool or synthetic, NOT cotton)
- [ ] Neck gaiter or balaclava
- [ ] Back protector (recommended for off-piste / racing)
- [ ] Wrist guards (recommended for beginners)
- [ ] Skis sized correctly
- [ ] Boots sized correctly
- [ ] Bindings DIN set by certified technician
- [ ] Poles sized correctly

**Cross-Country Checklist:**

- [ ] Helmet (optional but recommended for young children)
- [ ] Goggles or sunglasses (UV protection)
- [ ] XC ski jacket (lighter than alpine; wind-resistant)
- [ ] XC ski pants / tights (stretchy)
- [ ] Gloves (thinner than alpine; XC-specific)
- [ ] XC ski socks
- [ ] Skis sized correctly
- [ ] Boots (correct binding system: NNN or SNS)
- [ ] Bindings (matching system)
- [ ] Poles sized correctly
- [ ] Kick wax or waxless skis (for classic)

### 4. Helmet Sizing (bonus)

Measure head circumference at the widest point (just above eyebrows and ears).

| Head Circumference (cm) | Helmet Size |
|---|---|
| 44–48 | XXS / Kids XS |
| 48–52 | XS / Kids S |
| 52–56 | S / Kids M |
| 56–59 | M / Kids L |
| 59–62 | L |

Helmet fit check: "The helmet should sit level, two finger-widths above the eyebrows. The chinstrap should be snug — only one finger should fit between strap and chin."

### 5. Wax Recommendation (Cross-Country Classic, bonus)

For classic skiing with kick wax, display a simple temperature-based recommendation. Waxless skis eliminate this need.

| Snow Temperature | Recommended Kick Wax Colour (general) |
|---|---|
| Above 0°C (wet snow) | Klister (red or silver) |
| -1 to -3°C | Red hard wax |
| -3 to -7°C | Violet/purple hard wax |
| -7 to -12°C | Blue hard wax |
| Below -12°C | Green hard wax / polar wax |

Display only if user selects XC Classic. Note: "Wax brands and specific temperatures vary. Always check the wax manufacturer's temperature guide."

---

## Appendix: Reference Tables

### Appendix A: Full DIN Table with BSL Sub-Rows (ISO 11088-derived)

The following is the detailed table used by certified ski shops. Each code row is split into three sub-rows (1, 2, 3) based on Boot Sole Length. BSL sub-row 1 is the shortest BSL range, sub-row 3 is the longest.

```
CODE | BSL RANGE  | TYPE I  | TYPE II | TYPE III
-----|------------|---------|---------|----------
 A1  | ≤ 230 mm   |  0.75   |  1.00   |   1.50
 A2  | 231–270 mm |  0.75   |  1.00   |   1.50
 A3  | 271–310 mm |  1.00   |  1.25   |   1.75
-----|------------|---------|---------|----------
 B1  | ≤ 230 mm   |  1.00   |  1.25   |   1.75
 B2  | 231–270 mm |  1.00   |  1.25   |   1.75
 B3  | 271–310 mm |  1.25   |  1.50   |   2.00
-----|------------|---------|---------|----------
 C1  | ≤ 230 mm   |  1.25   |  1.50   |   2.00
 C2  | 231–270 mm |  1.50   |  2.00   |   2.50
 C3  | 271–310 mm |  1.75   |  2.25   |   3.00
-----|------------|---------|---------|----------
 D1  | ≤ 230 mm   |  1.50   |  2.00   |   2.50
 D2  | 231–270 mm |  1.75   |  2.25   |   3.00
 D3  | 271–310 mm |  2.00   |  2.50   |   3.50
-----|------------|---------|---------|----------
 E1  | ≤ 230 mm   |  2.00   |  2.50   |   3.00
 E2  | 231–270 mm |  2.25   |  3.00   |   3.50
 E3  | 271–310 mm |  2.50   |  3.50   |   4.00
-----|------------|---------|---------|----------
 F1  | ≤ 230 mm   |  2.50   |  3.00   |   3.50
 F2  | 231–270 mm |  3.00   |  3.50   |   4.50
 F3  | 271–310 mm |  3.50   |  4.00   |   5.00
-----|------------|---------|---------|----------
 G1  | ≤ 230 mm   |  3.00   |  3.50   |   4.50
 G2  | 231–270 mm |  3.50   |  4.00   |   5.00
 G3  | 271–310 mm |  4.00   |  4.50   |   5.50
-----|------------|---------|---------|----------
 H1  | ≤ 230 mm   |  3.50   |  4.50   |   5.50
 H2  | 231–270 mm |  4.00   |  5.00   |   6.00
 H3  | 271–310 mm |  4.50   |  5.50   |   6.50
-----|------------|---------|---------|----------
 I1  | ≤ 230 mm   |  4.50   |  5.50   |   6.50
 I2  | 231–270 mm |  5.00   |  6.00   |   7.00
 I3  | 271–310 mm |  5.50   |  6.50   |   7.50
-----|------------|---------|---------|----------
 J1  | ≤ 230 mm   |  5.50   |  6.50   |   7.50
 J2  | 231–270 mm |  6.00   |  7.00   |   8.00
 J3  | 271–310 mm |  6.50   |  7.50   |   8.50
-----|------------|---------|---------|----------
 K1  | ≤ 230 mm   |  6.50   |  7.50   |   8.50
 K2  | 231–270 mm |  7.00   |  8.00   |   9.00
 K3  | 271–310 mm |  7.50   |  8.50   |  10.00
-----|------------|---------|---------|----------
 L1  | ≤ 230 mm   |  7.50   |  8.50   |  10.00
 L2  | 231–270 mm |  8.00   |  9.00   |  11.00
 L3  | 271–310 mm |  8.50   |  10.00  |  12.00
-----|------------|---------|---------|----------
 M1  | ≤ 230 mm   |  8.50   |  10.00  |  12.00
 M2  | 231–270 mm |  9.00   |  11.00  |  12.00 (max)
 M3  | > 310 mm   |  10.00  |  12.00  |  12.00 (max)
```

Notes on the table:
- Most children's bindings top out at DIN 6 or 7. For code H and above with Type III, recommend professional shop verification and possible adult binding upgrade.
- DIN 12.0 is the maximum setting on most adult racing bindings and is never appropriate for children.
- Minimum DIN setting on most bindings is 0.75.

### Appendix B: Quick Reference — Typical Settings by Child Size

This table is for illustrative purposes in-app ("ballpark check") only. The full algorithm should always be used for actual recommendations.

| Child Age | Typical Weight | Typical Height | Ability | Approx DIN |
|---|---|---|---|---|
| 4–5 yrs | 15–18 kg | 100–110 cm | Beginner | 0.75 |
| 5–6 yrs | 18–22 kg | 108–118 cm | Beginner | 0.75–1.00 |
| 6–7 yrs | 20–25 kg | 115–122 cm | Beginner | 1.00 |
| 7–8 yrs | 22–27 kg | 120–128 cm | Beginner | 1.00–1.25 |
| 8–10 yrs | 25–35 kg | 128–138 cm | Intermediate | 1.50–2.50 |
| 10–12 yrs | 30–45 kg | 138–150 cm | Intermediate | 2.00–3.50 |
| 12–14 yrs | 40–55 kg | 150–165 cm | Intermediate | 3.00–5.00 |
| 14–16 yrs | 50–65 kg | 160–175 cm | Intermediate | 4.00–6.00 |

### Appendix C: Sources and Standards

- **ISO 11088:2018** — Mechanical and physical requirements for alpine ski binding systems
- **DIN 7881** — Original German standard (now superseded by ISO 11088, but table values remain widely referenced)
- **ASTM F939** — Standard practice for alpine ski binding release/retention
- Salomon Binding System Adjustment Guide
- Nordica Junior Boot Fitting Guide
- Rossignol Ski Sizing Charts (Junior Range)
- REI Expert Advice: How to Choose Ski Poles
- Swix Cross-Country Ski Sizing Guide
- PSIA (Professional Ski Instructors of America) equipment fitting recommendations

### Appendix D: Edge Cases and App Validation Rules

| Scenario | App Behaviour |
|---|---|
| Age ≤ 3 | Show warning: "For children under 3, consult a certified ski school. Sizing varies widely and individual assessment is recommended." |
| Weight < 10 kg | DIN code A, apply junior adjustment, show warning about minimum binding DIN capability |
| BSL not provided | Use estimated BSL from EU shoe size with disclaimer; flag that result is approximate |
| Skate XC selected for age < 7 | Show warning: "Skate skiing is generally not recommended for children under 7. Classic technique should be learned first." |
| Advanced level + age ≤ 6 | Show note: "For children 6 and under, we recommend starting at Intermediate sizing even if ability is advanced, to maintain manoeuvrability." |
| DIN result > 6.0 for age ≤ 12 | Flag: "High DIN setting recommended. This should be verified by a certified ski technician. Some junior bindings do not support settings above 6." |
| Ski length recommendation > 200 cm | This would only occur for very tall advanced teenagers; cap display and recommend adult sizing consultation. |

---

*End of Requirements Document*

*This document should be reviewed by a certified ski technician before the app is released to the public. DIN tables and sizing formulas are based on ISO 11088:2018 and widely adopted industry practice as of 2025. Values should be re-verified against the current ISO standard prior to implementation.*
