# Kids' Ski Equipment Sizing App — Product Requirements Document

**Version:** 1.4
**Date:** 2026-03-05
**Author:** Product Owner
**Status:** Updated — boot sizing: foot length input mode, mondo→BSL estimation, boot size recommendations

---

## Table of Contents

1. [Overview](#overview)
2. [App Structure](#app-structure)
3. [User Input Fields](#user-input-fields)
4. [Cross-Country Ski Length](#cross-country-ski-length)
5. [Alpine / Downhill Ski Length](#alpine--downhill-ski-length)
6. [DIN Settings (Alpine Bindings)](#din-settings-alpine-bindings)
7. [Ski Pole Length](#ski-pole-length)
8. [Boot Sizing](#boot-sizing)
9. [Additional Features](#additional-features)
10. [Appendix: Reference Tables](#appendix-reference-tables)

---

## Overview

This app helps parents size ski equipment for children using industry-standard formulas and lookup tables derived from ISO 11088 and widely adopted retailer guidelines (REI, Salomon, Nordica, Rossignol, and certified ski shop protocols). The app covers alpine/downhill skiing and cross-country (classic and skate) skiing.

Safety note: DIN settings in particular carry real liability. The app must display a disclaimer that all DIN values are recommendations only and should be verified and set by a certified ski technician.

---

## App Structure

The app uses a three-tab layout:

| Tab | Purpose |
|---|---|
| **My Kids** | Saved child profiles with persistent local storage. Tapping a profile shows results immediately. |
| **Quick Calc** | Ephemeral calculator for one-off sizing. Results are not saved. |
| **Tips & Info** | Static reference content: measuring guide, equipment tips, wax guide, packing checklist. |

### Navigation Flow — My Kids

1. **Profile list** — shows saved children sorted by creation date (newest first)
2. **Tap a profile** → navigates to **ChildResultsView** showing calculated recommendations immediately
3. **"Edit" toolbar button** → pushes **CalculatorFormView** for editing measurements
4. **Save** → pops back to results, which auto-recalculate from updated data
5. **"+" button** → opens calculator form as a modal/sheet for adding a new child
6. **New child flow**: fill form → Calculate → view results → Save Profile (persists locally) → dismiss

### Navigation Flow — Quick Calc

1. Fill form (same fields as My Kids)
2. Tap "Get Recommendations"
3. View results (no save option — results are ephemeral)
4. "Reset" toolbar button clears all fields

### Onboarding

First launch shows a full-screen onboarding view. Dismissed via "Get Started" button. State persisted locally (e.g., UserDefaults on iOS, SharedPreferences on Android).

### Appearance Setting

Manual dark/light mode control via a settings sheet (gear icon on My Kids tab):

| Mode | Behavior |
|---|---|
| System (default) | Follows device setting |
| Light | Forces light mode |
| Dark | Forces dark mode |

Persisted locally. Applied at the app root level (e.g., `.preferredColorScheme()` on iOS, `AppCompatDelegate.setDefaultNightMode()` on Android).

---

## User Input Fields

These are the inputs collected per child profile. All fields except name are required for full calculation output.

| Field | Type | Constraints | Notes |
|---|---|---|---|
| Child Name | Text (optional) | Max 50 chars | For profile identification |
| Height | Integer (cm) | 60–210 cm | Measured without shoes |
| Weight | Integer (kg) | 8–120 kg | Used for DIN and pole sizing |
| Age | Integer (years) | 2–99 | Used for DIN adjustment and age-bracket logic |
| Boot Sole Length (BSL) | Integer (mm) | 150–380 mm | Optional; needed for precise DIN lookup. Can be estimated from foot length, shoe size, or height if unknown |
| Foot Length | Integer (mm) | 100–310 mm | Optional; displayed as cm in UI. Equal to Mondo Point size. Used for boot sizing and BSL estimation |
| Ability Level | Enum | Beginner / Intermediate / Advanced | Used for ski length and DIN type |
| Ski Type | Enum (multi-select) | Alpine, XC Classic, XC Skate | Determines which calculations to show |

### BSL Input Modes

The app supports four BSL input modes, ordered from least to most accurate:

| Mode | Description |
|---|---|
| **Estimate** (default) | BSL estimated from height using lookup table. Warning shown in results. |
| **Shoe Size** | BSL estimated from EU shoe size. Warning shown in results. |
| **Foot Length** | User measures foot in cm (= Mondo Point). BSL estimated from foot length. Also enables boot size recommendation in results. Warning shown. |
| **BSL** | User enters actual BSL from inside the boot. Most accurate. |

### Ability Level Definitions (display in app)

- **Beginner:** Just starting out; cautious; mostly on groomed easy runs or flat terrain (DIN Type I)
- **Intermediate:** Comfortable on groomed runs; skiing most terrain; moderate speed (DIN Type II)
- **Advanced:** Aggressive; skiing all terrain including moguls, off-piste, or racing (DIN Type III)

### Boot Sole Length (BSL) Estimation — From EU Shoe Size

If BSL is unknown, estimate from EU shoe size. Show this as a helper in the app with a note that actual BSL varies by boot brand and must be confirmed from the boot.

| EU Size | Approx BSL (mm) |
|---|---|
| 15–16 | 150 |
| 17–18 | 165 |
| 19–20 | 178 |
| 21–22 | 192 |
| 23–24 | 207 |
| 25–26 | 217 |
| 27–28 | 228 |
| 29–30 | 238 |
| 31–32 | 258 |
| 33–34 | 268 |
| 35–36 | 285 |
| 37–38 | 298 |

### Boot Sole Length (BSL) Estimation — From Foot Length (Mondo Point)

If the user provides a foot length measurement in cm, this equals the Mondo Point size. BSL is estimated from Mondo Point using the following table (based on Head junior boot data, representative of industry averages):

| Foot Length / Mondo (cm) | Approx BSL (mm) |
|---|---|
| 15.0–16.0 | 205 |
| 16.5–17.0 | 215 |
| 17.5–18.5 | 225 |
| 19.0–19.5 | 237 |
| 20.0–20.5 | 245 |
| 21.0–21.5 | 257 |
| 22.0–22.5 | 265 |
| 23.0–23.5 | 277 |
| 24.0–24.5 | 285 |
| 25.0–25.5 | 297 |
| 26.0+ | 305 |

**Note:** BSL varies by boot brand and model (±5–10 mm at same Mondo size). This table provides an estimate for DIN calculations. For accurate DIN settings, always use the actual BSL printed on the boot.

**Implementation:** Store foot length as integer mm internally (e.g., 200 = 20.0 cm). Display as cm with one decimal in UI. Step size: 5 mm (= 0.5 cm half-sizes).

### Boot Sole Length (BSL) Estimation — From Height

When neither BSL nor shoe size is known, estimate from height. This is the least accurate method.

| Height (cm) | Approx BSL (mm) |
|---|---|
| ≤ 85 | 170 |
| 86–95 | 185 |
| 96–105 | 200 |
| 106–115 | 215 |
| 116–125 | 235 |
| 126–135 | 250 |
| 136–145 | 265 |
| 146–155 | 280 |
| 156–165 | 295 |
| 166–175 | 305 |
| 176+ | 315 |

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
| Under 5 yrs | Any | height – 5 to height (no offset or negative) | 105–110 cm |
| 5–7 yrs | Beginner | height + 0 to +5 cm | 110–115 cm |
| 5–7 yrs | Intermediate+ | height + 5 to +10 cm | 115–120 cm |
| 8–11 yrs | Beginner | height + 5 to +10 cm | 115–120 cm |
| 8–11 yrs | Intermediate | height + 10 to +15 cm | 120–125 cm |
| 8–11 yrs | Advanced | height + 15 to +20 cm | 125–130 cm |
| 12+ yrs | Beginner | height + 10 to +15 cm | — |
| 12+ yrs | Intermediate | height + 15 to +20 cm | — |
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
    case (.age12plus, .beginner):    return (heightCm + 10, heightCm + 15)
    case (.age12plus, .intermediate):return (heightCm + 15, heightCm + 20)
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

Skate skis are always shorter than classic skis for the same skier. Not appropriate for children under 8 years old; the app returns nil (no recommendation) for children under 8.

**General formula:**

```
Skate ski length = Child height (cm) + offset (cm)
```

| Age Group | Ability | Offset | Example (130 cm child) |
|---|---|---|---|
| 8–9 yrs | Beginner | height + 0 to +5 cm | 130–135 cm |
| 8–9 yrs | Intermediate+ | height + 5 cm | 135 cm |
| 10–11 yrs | Beginner | height + 5 cm | 135 cm |
| 10–11 yrs | Intermediate | height + 7.5 cm | ~138 cm |
| 10–11 yrs | Advanced | height + 10 cm | 140 cm |
| 12+ yrs | Beginner | height + 5 cm | — |
| 12+ yrs | Intermediate | height + 7.5 cm | — |
| 12+ yrs | Advanced | height + 10 cm | — |

### Rounding

Round all ski lengths to the nearest 5 cm, as skis are manufactured in 5 cm increments (e.g., 100, 105, 110, 115...).

```swift
func roundToNearestFive(_ value: Int) -> Int {
    return Int((Double(value) / 5.0).rounded()) * 5
}
```

---

## Alpine / Downhill Ski Length

### Method 1: Height-Based Body Reference (Industry Standard)

This is the most common method used in ski shops. The reference point varies by age — children should use proportionally shorter skis than adults for control and safety. Sources: REI, Rossignol, Salomon junior guides, PSIA fitting recommendations.

**Kids (ages 7–12) — chest to nose range:**

| Ability Level | Ski tip relative to child | Approximate formula |
|---|---|---|
| Beginner | Chest to chin | height × 0.75 to height × 0.85 |
| Intermediate | Chin to nose | height × 0.85 to height × 0.90 |
| Advanced | Nose to forehead | height × 0.88 to height × 0.93 |

**Preteens (ages 11–12) — transitional:**

| Ability Level | Ski tip relative to child | Approximate formula |
|---|---|---|
| Beginner | Chest to chin (upper) | height × 0.80 to height × 0.88 |
| Intermediate | Chin to nose | height × 0.88 to height × 0.93 |
| Advanced | Nose to forehead | height × 0.92 to height × 0.97 |

**Teens/Adults (ages 13+) — standard adult sizing:**

| Ability Level | Ski tip relative to skier | Approximate formula |
|---|---|---|
| Beginner | Chin to nose | height × 0.85 to height × 0.90 |
| Intermediate | Nose to forehead | height × 0.90 to height × 0.95 |
| Advanced | Forehead to top of head | height × 0.95 to height × 1.00 |

**Example for a 120 cm, 8-year-old child:**

| Level | Range | Example lengths |
|---|---|---|
| Beginner | 120 × 0.75 to 0.85 | 90–102 cm → round to 90–100 cm |
| Intermediate | 120 × 0.85 to 0.90 | 102–108 cm → round to 100–110 cm |
| Advanced | 120 × 0.88 to 0.93 | 106–112 cm → round to 105–110 cm |

**Example for a 165 cm, 15-year-old teen:**

| Level | Range | Example lengths |
|---|---|---|
| Beginner | 165 × 0.85 to 0.90 | 140–149 cm → round to 140–150 cm |
| Intermediate | 165 × 0.90 to 0.95 | 149–157 cm → round to 150–155 cm |
| Advanced | 165 × 0.95 to 1.00 | 157–165 cm → round to 155–165 cm |

### Method 2: Explicit Formulas by Age and Ability

The function uses age brackets to select appropriate multipliers. Younger children get proportionally shorter skis for control and safety.

```
alpineSkiLength(heightCm, age, ability) -> (min, max):

  // Special cases
  if age <= 3:       return (height - 15, height - 10), minimum 50 cm
  if age 4-6, beginner: return height × 0.80 (single value)
  if age <= 6, advanced: downgrade to intermediate

  // Age-bracketed multipliers
  Age 7-10:
    beginner:     height × 0.75 to 0.85
    intermediate: height × 0.85 to 0.90
    advanced:     height × 0.88 to 0.93

  Age 11-12:
    beginner:     height × 0.80 to 0.88
    intermediate: height × 0.88 to 0.93
    advanced:     height × 0.92 to 0.97

  Age 13+:
    beginner:     height × 0.85 to 0.90
    intermediate: height × 0.90 to 0.95
    advanced:     height × 0.95 to 1.00

  Round all results to nearest 5 cm.
```

### Age/Size Exceptions

- Children under 4 years (age ≤ 3): use learner ski packages sized at height – 15 to height – 10 cm (minimum 50 cm). These are often packaged as complete systems (skis + bindings) and do not require DIN setting.
- Children 4–6 years, beginner: override formula uses height × 0.80 to prioritize control and confidence.
- Children 4–6 years, intermediate: uses height × 0.80 to height × 0.85 (same bracket as 7–10 beginner upper range).
- Children 6 and under with "Advanced" ability: downgrade to Intermediate sizing for safety and manoeuvrability.

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
| Type J (Junior) | Children aged 9 and under | Applied when age ≤ 9 — shift one code up (lower/safer), per ISO 11088 |

**App mapping:**
- Beginner → Type I
- Intermediate → Type II
- Advanced → Type III
- If age ≤ 9: apply Junior adjustment (shift one DIN code up to a lower/safer value)

### Age ≤ 3 Exception

DIN settings are NOT calculated for children aged 3 and under. Instead, the app displays a warning: "DIN settings are not calculated for children age 3 and under. Please consult a certified ski school for binding setup."

### Step-by-Step DIN Calculation

The ISO 11088 standard uses a lookup table that cross-references:
1. Skier weight (kg) → selects a row group
2. Boot Sole Length (mm) → selects sub-row within the group
3. Height (cm) → may move to a higher code
4. Skier type → selects column

**Step 1: Determine the "code number" from weight**

| Code | Weight (kg) | Height threshold |
|---|---|---|
| A | 10–13 | ≤ 148 |
| B | 14–17 | ≤ 148 |
| C | 18–21 | ≤ 148 |
| D | 22–25 | ≤ 148 |
| E | 26–30 | ≤ 148 |
| F | 31–35 | ≤ 157 |
| G | 36–41 | ≤ 166 |
| H | 42–48 | ≤ 174 |
| I | 49–57 | ≤ 182 |
| J | 58–66 | ≤ 189 |
| K | 67–78 | ≤ 196 |
| L | 79–94 | ≤ 196 |
| M | 95+ | — |

**Step 2: Height adjustment**

If the skier's height exceeds the threshold for their weight-based code, adjust upward to the next code. Continue until the height is within the threshold.

**Child safety exception (age ≤ 12):** If the height-adjusted code is higher than the weight-based code, the app keeps the lower weight-based code. This is more conservative/safer for children.

**Step 3: Apply Boot Sole Length sub-lookup**

Each code has 6 BSL sub-rows with progressively higher DIN values:

| BSL Range | Sub-row |
|---|---|
| ≤ 250 mm | 1 (lowest DIN) |
| 251–270 mm | 2 |
| 271–290 mm | 3 |
| 291–310 mm | 4 |
| 311–330 mm | 5 |
| > 330 mm | 6 (highest DIN) |

**Step 4: Read DIN from the lookup table**

Cross-reference the code + BSL sub-row with the skier type column (Type I / II / III). See Appendix A for the full table.

**Step 5: Junior adjustment**

If age ≤ 9: shift one code up (e.g., F → E) before final lookup. This produces a lower, safer DIN setting per ISO 11088.

```swift
if age <= 9 {
    adjustedCode = adjustedCode.previous ?? adjustedCode
}
```

**Step 6: Round and cap**

- Round to nearest 0.25
- Cap at 12.0 (maximum DIN on most bindings)

### DIN Value Validity Check

Bindings have a range printed on them (e.g., "3–10" or "1–6"). The app warns when DIN > 6.0 for children aged 12 and under:

> "High DIN setting recommended. This should be verified by a certified ski technician. Some junior bindings do not support settings above 6."

---

## Ski Pole Length

### Alpine / Downhill Poles

**Method 1 (body reference — most reliable):**
Hold pole upside down with the tip pointing up. Grip the pole just below the basket. Elbow should form a 90-degree angle. This is the correct length.

**Method 2 (formula):**
```
Alpine pole length (cm) = height (cm) × 0.68
```

Rounded to nearest 5 cm.

```swift
func alpinePoleLength(heightCm: Int) -> Int {
    return roundToNearestFive(Double(heightCm) * 0.68)
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
XC Classic pole length (cm) = height (cm) × 0.84
```

The tip of the pole, when held normally, should reach the skier's armpit.

```swift
func xcClassicPoleLength(heightCm: Int) -> Int {
    return roundToNearestFive(Double(heightCm) * 0.84)
}
```

**Example table:**

| Child Height (cm) | Formula Result (× 0.84) | Recommended Pole |
|---|---|---|
| 90 | 76 cm | 75 cm |
| 100 | 84 cm | 85 cm |
| 110 | 92 cm | 90 cm |
| 120 | 101 cm | 100 cm |
| 130 | 109 cm | 110 cm |
| 140 | 118 cm | 120 cm |
| 150 | 126 cm | 125 cm |
| 160 | 134 cm | 135 cm |

### Cross-Country Skate Poles

Skate poles are significantly longer than classic poles to provide leverage for the skating push.

**Formula:**
```
XC Skate pole length (cm) = height (cm) × 0.89
```

The tip of the pole should reach between chin and nose when standing.

```swift
func xcSkatePoleLength(heightCm: Int) -> Int {
    return roundToNearestFive(Double(heightCm) * 0.89)
}
```

**Example table:**

| Child Height (cm) | Formula Result (× 0.89) | Recommended Pole |
|---|---|---|
| 100 | 89 cm | 90 cm |
| 110 | 98 cm | 100 cm |
| 120 | 107 cm | 105 cm |
| 130 | 116 cm | 115 cm |
| 140 | 125 cm | 125 cm |
| 150 | 134 cm | 135 cm |
| 160 | 142 cm | 140 cm |

**Note:** Skate skiing is not typically practiced by children under 8. App surfaces a note: "Skate skiing poles are suitable for children 8 years and older who have mastered classic technique."

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
| Under 6 | 1.0–1.5 cm |
| 6–10 | 1.0–1.5 cm |
| 10–14 | 0.5–1.0 cm |
| 14+ | 0–0.5 cm (fit closer for performance) |

**Display note in app:**
> "Ski boots should NOT have the same amount of room as regular shoes. Too much room causes foot movement leading to poor control and blisters. For children, 1–1.5 cm of growth room is appropriate. Never buy boots more than 1.5 cm too large."

### Boot Size Recommendation (Implemented)

When the user provides a foot length measurement (via the "Foot Length" BSL input mode), the app calculates and displays a boot size recommendation in the Equipment Guide section of results.

**Calculation:**

```
growthRoom = age < 6 ? 15mm : age <= 10 ? 10mm : age <= 14 ? 10mm : 5mm
recommendedMondo = footLengthMm + growthRoom  (in mm, display as cm)
euSize = lookup from Mondo Point table above
estimatedBSL = lookup from Mondo→BSL table above
```

**Growth room computation values** (midpoint of recommendation ranges):

| Age | Growth Room (mm) |
|---|---|
| Under 6 | 15 |
| 6–10 | 10 |
| 11–14 | 10 |
| 14+ | 5 |

**Display in results:**
- "Ski Boot Size" card showing:
  - Measured foot length (cm)
  - Recommended Mondo Point size (with growth room)
  - Equivalent EU ski boot size
  - Growth room applied
  - Estimated BSL (used for DIN)
  - Note about snug fit

**When foot length is NOT provided** (Estimate, Shoe Size, or BSL modes), the boot size recommendation card is not shown. The existing flex rating and growth room text are still displayed.

### Alpine Boot Flex Rating for Kids

The app shows boot flex recommendations in the results view based on age and ability:

| Age | Beginner | Intermediate | Advanced |
|---|---|---|---|
| Under 5 | Soft shell | Soft shell | Soft shell |
| 5–9 | 50–60 | 60–70 | 60–80 |
| 10–12 | 60–70 | 70–80 | 80–90 |
| 13+ | 70–80 | 80–100 | 90–110 |

### Cross-Country Ski Boots

XC boots are sized identically to Mondo point / EU sizing. Key differences:
- Classic boots: lower cut, flexible; sole compatible with NNN, Prolink, or Turnamic binding system
- Skate boots: higher cuff, stiffer; same binding systems
- Note in app: **NNN (Rottefella), Prolink (Salomon/Atomic), and Turnamic (Fischer) are cross-compatible. Only legacy SNS bindings are NOT compatible with NNN/Prolink/Turnamic.**

**Binding system note to display:**
> "NNN (Rottefella), Prolink (Salomon/Atomic), and Turnamic (Fischer) bindings are cross-compatible. Legacy SNS bindings are NOT compatible with these systems. Check that your boots and bindings use a compatible system."

---

## Additional Features

### 1. Child Profiles (Implemented)

- Multiple child profiles stored locally (SwiftData on iOS, Room on Android)
- Profile data: name (optional), height, weight, age, BSL (optional), ability level, ski types, last calculated date, created date
- Profiles sorted by creation date (newest first)
- Swipe-to-delete with confirmation alert
- Tapping a profile shows results immediately (ChildResultsView); "Edit" button pushes the form

### 2. Quick Calc (Implemented)

- Separate tab for one-off calculations without saving
- Same input fields as child profiles
- Results displayed but not persisted
- "Reset" button to clear all fields

### 3. Results View Features (Implemented)

The results view displays:
- **Header**: child name, height/weight/age summary, ability level badge, calculation date
- **Shop Mode**: full-screen view designed to show to ski shop staff (button in results)
- **Share**: generates formatted text summary for sharing
- **Alpine section**: ski length range with visual indicator, DIN card (tappable for details)
- **Cross-country section**: classic and skate ski lengths with visual indicators
- **Pole lengths**: alpine, XC classic, XC skate
- **Equipment guide**: boot flex recommendation (age/ability-based), helmet size estimate (age-based)
- **Safety disclaimer**: always shown when DIN is calculated
- **Save Profile button**: only shown for new children (not for existing profiles)

### 4. Helmet Size Estimates (Implemented)

The app estimates helmet size in the results view based on age:

| Age | Estimated Size |
|---|---|
| ≤ 3 | 47–51 cm (XS) |
| 4–6 | 51–55 cm (S) |
| 7–11 | 55–59 cm (M) |
| 12+ | 55–62 cm (M/L) |

Note: This is an estimate. The app advises measuring head circumference for accurate sizing.

### 5. Tips & Info Tab (Implemented)

Accordion-style reference content covering:
- How to Measure (height, weight, foot, BSL, head circumference)
- Alpine Equipment guide
- Cross-Country Equipment guide
- Helmet Sizing (with size chart)
- Boot Fitting (growth room guide, flex ratings)
- Understanding DIN
- Kick Wax Guide (temperature-based recommendations)
- Packing Essentials (interactive checklist with persistent checkmarks)

### 6. Appearance Setting (Implemented)

Manual dark/light/system mode toggle accessible from the gear icon on the My Kids tab. See [App Structure](#app-structure) for details.

### Future Features (Not Yet Implemented)

The following features from the original requirements are not yet implemented:

- **Growth tracking and upgrade alerts** — track measurements over time and alert when equipment is outgrown
- **Cloud sync** — sync profiles across devices (iCloud on iOS, platform-appropriate on Android)
- **Date of birth** — auto-update age from DOB
- **Per-child equipment checklists** — currently only a global checklist in Tips

---

## Appendix: Reference Tables

### Appendix A: Full DIN Table with BSL Sub-Rows

The app uses a detailed lookup table with 6 BSL sub-rows per code. Each code is determined by weight (with optional height adjustment), and the BSL sub-row refines the DIN value within that code.

```
CODE | BSL RANGE      | TYPE I  | TYPE II | TYPE III
-----|----------------|---------|---------|----------
 A   | ≤ 250 mm       |  0.75   |  0.75   |   1.00
 A   | 251–270 mm     |  0.75   |  0.75   |   1.00
 A   | 271–290 mm     |  0.75   |  1.00   |   1.25
 A   | 291–310 mm     |  0.75   |  1.00   |   1.25
 A   | 311–330 mm     |  0.75   |  1.00   |   1.50
 A   | > 330 mm       |  0.75   |  1.00   |   1.50
-----|----------------|---------|---------|----------
 B   | ≤ 250 mm       |  1.00   |  1.25   |   1.50
 B   | 251–270 mm     |  1.00   |  1.25   |   1.50
 B   | 271–290 mm     |  1.00   |  1.50   |   1.75
 B   | 291–310 mm     |  1.00   |  1.50   |   1.75
 B   | 311–330 mm     |  1.25   |  1.50   |   2.00
 B   | > 330 mm       |  1.25   |  1.50   |   2.00
-----|----------------|---------|---------|----------
 C   | ≤ 250 mm       |  1.50   |  1.75   |   2.25
 C   | 251–270 mm     |  1.50   |  1.75   |   2.25
 C   | 271–290 mm     |  1.50   |  2.00   |   2.50
 C   | 291–310 mm     |  1.50   |  2.00   |   2.50
 C   | 311–330 mm     |  1.75   |  2.25   |   3.00
 C   | > 330 mm       |  1.75   |  2.25   |   3.00
-----|----------------|---------|---------|----------
 D   | ≤ 250 mm       |  2.00   |  2.50   |   3.00
 D   | 251–270 mm     |  2.00   |  2.50   |   3.00
 D   | 271–290 mm     |  2.00   |  2.75   |   3.50
 D   | 291–310 mm     |  2.00   |  2.75   |   3.50
 D   | 311–330 mm     |  2.25   |  3.00   |   3.50
 D   | > 330 mm       |  2.25   |  3.00   |   3.50
-----|----------------|---------|---------|----------
 E   | ≤ 250 mm       |  2.50   |  3.00   |   3.50
 E   | 251–270 mm     |  2.50   |  3.00   |   3.50
 E   | 271–290 mm     |  2.75   |  3.50   |   4.00
 E   | 291–310 mm     |  2.75   |  3.50   |   4.00
 E   | 311–330 mm     |  3.00   |  3.50   |   4.50
 E   | > 330 mm       |  3.00   |  3.50   |   4.50
-----|----------------|---------|---------|----------
 F   | ≤ 250 mm       |  3.00   |  3.50   |   4.50
 F   | 251–270 mm     |  3.00   |  3.50   |   4.50
 F   | 271–290 mm     |  3.50   |  4.00   |   5.00
 F   | 291–310 mm     |  3.50   |  4.00   |   5.00
 F   | 311–330 mm     |  3.50   |  4.50   |   5.50
 F   | > 330 mm       |  3.50   |  4.50   |   5.50
-----|----------------|---------|---------|----------
 G   | ≤ 250 mm       |  3.50   |  4.50   |   5.50
 G   | 251–270 mm     |  3.50   |  4.50   |   5.50
 G   | 271–290 mm     |  4.00   |  5.00   |   6.00
 G   | 291–310 mm     |  4.00   |  5.00   |   6.00
 G   | 311–330 mm     |  4.50   |  5.50   |   6.50
 G   | > 330 mm       |  4.50   |  5.50   |   6.50
-----|----------------|---------|---------|----------
 H   | ≤ 250 mm       |  4.50   |  5.50   |   6.50
 H   | 251–270 mm     |  4.50   |  5.50   |   6.50
 H   | 271–290 mm     |  5.00   |  6.00   |   7.50
 H   | 291–310 mm     |  5.00   |  6.00   |   7.50
 H   | 311–330 mm     |  5.50   |  6.50   |   8.00
 H   | > 330 mm       |  5.50   |  6.50   |   8.00
-----|----------------|---------|---------|----------
 I   | ≤ 250 mm       |  5.50   |  6.50   |   8.00
 I   | 251–270 mm     |  5.50   |  6.50   |   8.00
 I   | 271–290 mm     |  6.00   |  7.50   |   9.00
 I   | 291–310 mm     |  6.00   |  7.50   |   9.00
 I   | 311–330 mm     |  6.50   |  8.00   |   9.50
 I   | > 330 mm       |  6.50   |  8.00   |   9.50
-----|----------------|---------|---------|----------
 J   | ≤ 250 mm       |  6.50   |  8.00   |   9.50
 J   | 251–270 mm     |  6.50   |  8.00   |   9.50
 J   | 271–290 mm     |  7.50   |  9.00   |  10.50
 J   | 291–310 mm     |  7.50   |  9.00   |  10.50
 J   | 311–330 mm     |  8.00   |  9.50   |  11.00
 J   | > 330 mm       |  8.00   |  9.50   |  11.00
-----|----------------|---------|---------|----------
 K   | ≤ 250 mm       |  8.00   |  9.50   |  11.00
 K   | 251–270 mm     |  8.00   |  9.50   |  11.00
 K   | 271–290 mm     |  8.50   | 10.00   |  12.00
 K   | 291–310 mm     |  8.50   | 10.00   |  12.00
 K   | 311–330 mm     |  9.00   | 11.00   |  12.00
 K   | > 330 mm       |  9.00   | 11.00   |  12.00
-----|----------------|---------|---------|----------
 L   | ≤ 250 mm       |  9.00   | 11.00   |  12.00
 L   | 251–270 mm     |  9.00   | 11.00   |  12.00
 L   | 271–290 mm     |  9.50   | 11.00   |  12.00
 L   | 291–310 mm     |  9.50   | 11.00   |  12.00
 L   | 311–330 mm     | 10.00   | 12.00   |  12.00
 L   | > 330 mm       | 10.00   | 12.00   |  12.00
-----|----------------|---------|---------|----------
 M   | ≤ 250 mm       | 10.00   | 12.00   |  12.00
 M   | 251–270 mm     | 10.00   | 12.00   |  12.00
 M   | 271–290 mm     | 11.00   | 12.00   |  12.00
 M   | 291–310 mm     | 11.00   | 12.00   |  12.00
 M   | 311–330 mm     | 12.00   | 12.00   |  12.00
 M   | > 330 mm       | 12.00   | 12.00   |  12.00
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
| Age ≤ 3 | DIN not calculated. Show warning: "For children under 3, consult a certified ski school. Sizing varies widely and individual assessment is recommended." Alpine ski length uses height – 15 to height – 10 formula. |
| Weight < 10 kg | DIN code A, apply junior adjustment, show warning about minimum binding DIN capability |
| BSL not provided | Use estimated BSL from height (or shoe size if selected) with disclaimer; flag that result is approximate |
| Skate XC selected for age < 8 | Returns nil (no recommendation). Show warning: "Skate skiing is generally recommended for children 8 and older. Classic technique should be learned first." |
| Advanced level + age ≤ 6 | Downgrade to Intermediate sizing. Show note: "For children 6 and under, we recommend starting at Intermediate sizing even if ability is advanced, to maintain manoeuvrability." |
| DIN result > 6.0 for age ≤ 12 | Flag: "High DIN setting recommended. This should be verified by a certified ski technician. Some junior bindings do not support settings above 6." |
| Height adjustment overridden for age ≤ 12 | Show: "Height suggests a higher DIN code, but the lower (weight-based) setting was kept for child safety." |

---

*End of Requirements Document*

*This document should be reviewed by a certified ski technician before the app is released to the public. DIN tables and sizing formulas are based on ISO 11088:2018 and widely adopted industry practice as of 2025. Values should be re-verified against the current ISO standard prior to implementation.*
