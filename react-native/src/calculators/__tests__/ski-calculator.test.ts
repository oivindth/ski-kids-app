import { AbilityLevel } from "../../models/types";
import {
  roundToNearestFive,
  alpineSkiLength,
  classicXCSkiLength,
  skateXCSkiLength,
  alpinePoleLength,
  xcClassicPoleLength,
  xcSkatePoleLength,
  estimatedBSLFromEUSize,
  estimatedBSLFromHeight,
  helmetSizeEstimate,
  bootFlexRecommendation,
  growthRoomGuide,
} from "../ski-calculator";

describe("roundToNearestFive", () => {
  it("rounds 2 down to 0", () => {
    expect(roundToNearestFive(2)).toBe(0);
  });

  it("rounds 3 up to 5", () => {
    expect(roundToNearestFive(3)).toBe(5);
  });

  it("rounds 7 down to 5", () => {
    expect(roundToNearestFive(7)).toBe(5);
  });

  it("rounds 8 up to 10", () => {
    expect(roundToNearestFive(8)).toBe(10);
  });

  it("rounds exact multiple of 5 unchanged", () => {
    expect(roundToNearestFive(100)).toBe(100);
    expect(roundToNearestFive(85)).toBe(85);
  });

  it("rounds 2.5 to 5 (halfway rounds up)", () => {
    expect(roundToNearestFive(2.5)).toBe(5);
  });
});

describe("alpineSkiLength — age <= 3", () => {
  it("age 3, height 100cm: min=85, max=90", () => {
    const result = alpineSkiLength(100, 3, AbilityLevel.Beginner);
    expect(result.minCm).toBe(85);
    expect(result.maxCm).toBe(90);
  });

  it("age 2, height 75cm: height-15=60, height-10=65, both above floor", () => {
    const result = alpineSkiLength(75, 2, AbilityLevel.Beginner);
    expect(result.minCm).toBe(60);
    expect(result.maxCm).toBe(65);
  });

  it("age 3, height 60cm: floors at min=50, max=55", () => {
    // height 60 - 15 = 45, rounds to 45 -> max(45, 50) = 50
    // height 60 - 10 = 50, rounds to 50 -> max(50, 55) = 55
    const result = alpineSkiLength(60, 3, AbilityLevel.Beginner);
    expect(result.minCm).toBe(50);
    expect(result.maxCm).toBe(55);
  });

  it("floors apply regardless of ability level at age <= 3", () => {
    const result = alpineSkiLength(60, 2, AbilityLevel.Advanced);
    expect(result.minCm).toBe(50);
    expect(result.maxCm).toBe(55);
  });
});

describe("alpineSkiLength — age 4-6 beginner: height × 0.80", () => {
  it("age 5, height 110cm, beginner: 110*0.80=88 -> rounds to 90", () => {
    const result = alpineSkiLength(110, 5, AbilityLevel.Beginner);
    expect(result.minCm).toBe(90);
    expect(result.maxCm).toBe(90);
  });

  it("age 4, height 100cm, beginner: 100*0.80=80 -> rounds to 80", () => {
    const result = alpineSkiLength(100, 4, AbilityLevel.Beginner);
    expect(result.minCm).toBe(80);
    expect(result.maxCm).toBe(80);
  });

  it("age 6, height 115cm, beginner: 115*0.80=92 -> rounds to 90", () => {
    const result = alpineSkiLength(115, 6, AbilityLevel.Beginner);
    expect(result.minCm).toBe(90);
    expect(result.maxCm).toBe(90);
  });
});

describe("alpineSkiLength — advanced <= 6 downgraded to intermediate", () => {
  it("age 5, advanced -> uses intermediate formula (0.90-0.95)", () => {
    const advanced = alpineSkiLength(110, 5, AbilityLevel.Advanced);
    const intermediate = alpineSkiLength(110, 5, AbilityLevel.Intermediate);
    expect(advanced.minCm).toBe(intermediate.minCm);
    expect(advanced.maxCm).toBe(intermediate.maxCm);
  });

  it("age 6, advanced -> intermediate, NOT beginner (height*0.80)", () => {
    // Intermediate at age 5-6 falls into standard formula (0.90-0.95), not 0.80
    // height 120cm: 120*0.90=108->110, 120*0.95=114->115
    const result = alpineSkiLength(120, 6, AbilityLevel.Advanced);
    expect(result.minCm).toBe(110);
    expect(result.maxCm).toBe(115);
  });

  it("age 7, advanced -> uses advanced formula (0.95-1.00)", () => {
    const result = alpineSkiLength(120, 7, AbilityLevel.Advanced);
    // 120*0.95=114->115, 120*1.00=120->120
    expect(result.minCm).toBe(115);
    expect(result.maxCm).toBe(120);
  });
});

describe("alpineSkiLength — standard formulas", () => {
  it("beginner age 10, height 140cm: 0.85*140=119->120, 0.90*140=126->125", () => {
    const result = alpineSkiLength(140, 10, AbilityLevel.Beginner);
    expect(result.minCm).toBe(120);
    expect(result.maxCm).toBe(125);
  });

  it("intermediate age 10, height 140cm: 0.90*140=126->125, 0.95*140=133->135", () => {
    const result = alpineSkiLength(140, 10, AbilityLevel.Intermediate);
    expect(result.minCm).toBe(125);
    expect(result.maxCm).toBe(135);
  });

  it("advanced age 14, height 160cm: 0.95*160=152->150, 1.00*160=160->160", () => {
    const result = alpineSkiLength(160, 14, AbilityLevel.Advanced);
    expect(result.minCm).toBe(150);
    expect(result.maxCm).toBe(160);
  });
});

describe("classicXCSkiLength", () => {
  it("under 5, height 90cm: 85-90", () => {
    const result = classicXCSkiLength(90, 4, AbilityLevel.Beginner);
    expect(result.minCm).toBe(85);
    expect(result.maxCm).toBe(90);
  });

  it("age 5-7, beginner: height to height+5", () => {
    const result = classicXCSkiLength(110, 6, AbilityLevel.Beginner);
    expect(result.minCm).toBe(110);
    expect(result.maxCm).toBe(115);
  });

  it("age 5-7, intermediate: height+5 to height+10", () => {
    const result = classicXCSkiLength(110, 6, AbilityLevel.Intermediate);
    expect(result.minCm).toBe(115);
    expect(result.maxCm).toBe(120);
  });

  it("age 5-7, advanced: height+5 to height+10 (same as intermediate)", () => {
    const result = classicXCSkiLength(110, 7, AbilityLevel.Advanced);
    expect(result.minCm).toBe(115);
    expect(result.maxCm).toBe(120);
  });

  it("age 8-11, beginner: height+5 to height+10", () => {
    const result = classicXCSkiLength(130, 9, AbilityLevel.Beginner);
    expect(result.minCm).toBe(135);
    expect(result.maxCm).toBe(140);
  });

  it("age 8-11, intermediate: height+10 to height+15", () => {
    const result = classicXCSkiLength(130, 9, AbilityLevel.Intermediate);
    expect(result.minCm).toBe(140);
    expect(result.maxCm).toBe(145);
  });

  it("age 8-11, advanced: height+15 to height+20", () => {
    const result = classicXCSkiLength(130, 11, AbilityLevel.Advanced);
    expect(result.minCm).toBe(145);
    expect(result.maxCm).toBe(150);
  });

  it("age 12+, beginner: height+10 to height+15", () => {
    const result = classicXCSkiLength(150, 13, AbilityLevel.Beginner);
    expect(result.minCm).toBe(160);
    expect(result.maxCm).toBe(165);
  });

  it("age 12+, intermediate: height+15 to height+20", () => {
    const result = classicXCSkiLength(150, 14, AbilityLevel.Intermediate);
    expect(result.minCm).toBe(165);
    expect(result.maxCm).toBe(170);
  });

  it("age 12+, advanced: height+20 to height+25", () => {
    const result = classicXCSkiLength(150, 15, AbilityLevel.Advanced);
    expect(result.minCm).toBe(170);
    expect(result.maxCm).toBe(175);
  });
});

describe("skateXCSkiLength", () => {
  it("returns null for age < 8", () => {
    expect(skateXCSkiLength(120, 7, AbilityLevel.Beginner)).toBeNull();
    expect(skateXCSkiLength(110, 5, AbilityLevel.Advanced)).toBeNull();
  });

  it("age 8-9, beginner: height to height+5", () => {
    const result = skateXCSkiLength(130, 8, AbilityLevel.Beginner);
    expect(result).not.toBeNull();
    expect(result!.minCm).toBe(130);
    expect(result!.maxCm).toBe(135);
  });

  it("age 8-9, intermediate: height+5 (single point)", () => {
    const result = skateXCSkiLength(130, 9, AbilityLevel.Intermediate);
    expect(result!.minCm).toBe(135);
    expect(result!.maxCm).toBe(135);
  });

  it("age 8-9, advanced: height+5 (single point)", () => {
    const result = skateXCSkiLength(130, 8, AbilityLevel.Advanced);
    expect(result!.minCm).toBe(135);
    expect(result!.maxCm).toBe(135);
  });

  it("age 10-11, beginner: height+5 (single point)", () => {
    const result = skateXCSkiLength(140, 10, AbilityLevel.Beginner);
    expect(result!.minCm).toBe(145);
    expect(result!.maxCm).toBe(145);
  });

  it("age 10-11, intermediate: height+7.5 -> rounds to nearest 5", () => {
    // 140 + 7.5 = 147.5 -> rounds to 150
    const result = skateXCSkiLength(140, 11, AbilityLevel.Intermediate);
    expect(result!.minCm).toBe(150);
    expect(result!.maxCm).toBe(150);
  });

  it("age 10-11, advanced: height+10", () => {
    const result = skateXCSkiLength(140, 10, AbilityLevel.Advanced);
    expect(result!.minCm).toBe(150);
    expect(result!.maxCm).toBe(150);
  });

  it("age 12+, intermediate: height+7.5 -> rounds to nearest 5", () => {
    const result = skateXCSkiLength(150, 14, AbilityLevel.Intermediate);
    // 150 + 7.5 = 157.5 -> rounds to 160
    expect(result!.minCm).toBe(160);
    expect(result!.maxCm).toBe(160);
  });

  it("age 12+, advanced: height+10", () => {
    const result = skateXCSkiLength(160, 16, AbilityLevel.Advanced);
    expect(result!.minCm).toBe(170);
    expect(result!.maxCm).toBe(170);
  });
});

describe("pole lengths", () => {
  it("alpinePoleLength: height 120 -> 120*0.68=81.6 -> rounds to 80", () => {
    expect(alpinePoleLength(120)).toBe(80);
  });

  it("xcClassicPoleLength: height 130 -> 130*0.84=109.2 -> rounds to 110", () => {
    expect(xcClassicPoleLength(130)).toBe(110);
  });

  it("xcSkatePoleLength: height 140 -> 140*0.89=124.6 -> rounds to 125", () => {
    expect(xcSkatePoleLength(140)).toBe(125);
  });
});

describe("estimatedBSLFromEUSize", () => {
  it("EU 15 -> 150", () => expect(estimatedBSLFromEUSize(15)).toBe(150));
  it("EU 16 -> 150", () => expect(estimatedBSLFromEUSize(16)).toBe(150));
  it("EU 17 -> 165", () => expect(estimatedBSLFromEUSize(17)).toBe(165));
  it("EU 24 -> 207", () => expect(estimatedBSLFromEUSize(24)).toBe(207));
  it("EU 25 -> 217", () => expect(estimatedBSLFromEUSize(25)).toBe(217));
  it("EU 31 -> 258", () => expect(estimatedBSLFromEUSize(31)).toBe(258));
  it("EU 37 -> 298", () => expect(estimatedBSLFromEUSize(37)).toBe(298));
  it("EU 14 (below 15) -> 145", () => expect(estimatedBSLFromEUSize(14)).toBe(145));
  it("EU 39 (above 38) -> 310", () => expect(estimatedBSLFromEUSize(39)).toBe(310));
});

describe("estimatedBSLFromHeight", () => {
  it("height 80 (<= 85) -> 170", () => expect(estimatedBSLFromHeight(80)).toBe(170));
  it("height 85 -> 170", () => expect(estimatedBSLFromHeight(85)).toBe(170));
  it("height 86 -> 185", () => expect(estimatedBSLFromHeight(86)).toBe(185));
  it("height 120 -> 235", () => expect(estimatedBSLFromHeight(120)).toBe(235));
  it("height 130 -> 250", () => expect(estimatedBSLFromHeight(130)).toBe(250));
  it("height 135 -> 250", () => expect(estimatedBSLFromHeight(135)).toBe(250));
  it("height 136 -> 265", () => expect(estimatedBSLFromHeight(136)).toBe(265));
  it("height 176 (> 175) -> 315", () => expect(estimatedBSLFromHeight(176)).toBe(315));
});

describe("helmetSizeEstimate", () => {
  it("age 3 -> XS", () => expect(helmetSizeEstimate(3)).toBe("47–51 cm (XS)"));
  it("age 4 -> S", () => expect(helmetSizeEstimate(4)).toBe("51–55 cm (S)"));
  it("age 6 -> S", () => expect(helmetSizeEstimate(6)).toBe("51–55 cm (S)"));
  it("age 7 -> M", () => expect(helmetSizeEstimate(7)).toBe("55–59 cm (M)"));
  it("age 11 -> M", () => expect(helmetSizeEstimate(11)).toBe("55–59 cm (M)"));
  it("age 12 -> M/L", () => expect(helmetSizeEstimate(12)).toBe("55–62 cm (M/L)"));
});

describe("bootFlexRecommendation", () => {
  it("age 4 (< 5) -> Soft shell", () => {
    expect(bootFlexRecommendation(4, AbilityLevel.Beginner)).toBe("Soft shell");
  });

  it("age 5, beginner -> 50-60", () => {
    expect(bootFlexRecommendation(5, AbilityLevel.Beginner)).toBe("50–60");
  });

  it("age 9, advanced -> 60-80", () => {
    expect(bootFlexRecommendation(9, AbilityLevel.Advanced)).toBe("60–80");
  });

  it("age 10, beginner -> 60-70", () => {
    expect(bootFlexRecommendation(10, AbilityLevel.Beginner)).toBe("60–70");
  });

  it("age 12, advanced -> 80-90", () => {
    expect(bootFlexRecommendation(12, AbilityLevel.Advanced)).toBe("80–90");
  });

  it("age 13, beginner -> 70-80", () => {
    expect(bootFlexRecommendation(13, AbilityLevel.Beginner)).toBe("70–80");
  });

  it("age 17, intermediate -> 80-100", () => {
    expect(bootFlexRecommendation(17, AbilityLevel.Intermediate)).toBe("80–100");
  });

  it("age 17, advanced -> 90-110", () => {
    expect(bootFlexRecommendation(17, AbilityLevel.Advanced)).toBe("90–110");
  });
});

describe("growthRoomGuide", () => {
  it("age 10 -> 1.0-1.5 cm", () => expect(growthRoomGuide(10)).toBe("1.0–1.5 cm"));
  it("age 11 -> 0.5-1.0 cm", () => expect(growthRoomGuide(11)).toBe("0.5–1.0 cm"));
  it("age 14 -> 0.5-1.0 cm", () => expect(growthRoomGuide(14)).toBe("0.5–1.0 cm"));
  it("age 15 -> 0-0.5 cm", () => expect(growthRoomGuide(15)).toBe("0–0.5 cm"));
});
