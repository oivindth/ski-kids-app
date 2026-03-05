import React, { useState } from 'react';
import {
  LayoutAnimation,
  Platform,
  Pressable,
  ScrollView,
  Text,
  UIManager,
  View,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { useAppSettingsStore } from '@/src/stores/app-settings-store';
import { ChecklistItem } from '@/src/components/ChecklistItem';
import { AppColors, useThemeColors } from '@/src/theme/colors';

if (Platform.OS === 'android' && UIManager.setLayoutAnimationEnabledExperimental) {
  UIManager.setLayoutAnimationEnabledExperimental(true);
}

type SectionKey =
  | 'measuring'
  | 'alpine'
  | 'xc'
  | 'helmet'
  | 'boots'
  | 'din'
  | 'wax'
  | 'checklist';

interface Section {
  key: SectionKey;
  title: string;
  iconFamily: 'ionicons' | 'material';
  iconName: string;
  color: string;
}

const SECTIONS: Section[] = [
  {
    key: 'measuring',
    title: 'How to Measure',
    iconFamily: 'ionicons',
    iconName: 'resize',
    color: AppColors.secondary,
  },
  {
    key: 'alpine',
    title: 'Alpine Equipment',
    iconFamily: 'material',
    iconName: 'ski',
    color: AppColors.primary,
  },
  {
    key: 'xc',
    title: 'Cross-Country Equipment',
    iconFamily: 'material',
    iconName: 'ski-cross-country',
    color: AppColors.secondary,
  },
  {
    key: 'helmet',
    title: 'Helmet Sizing',
    iconFamily: 'material',
    iconName: 'hard-hat',
    color: '#9C27B0',
  },
  {
    key: 'boots',
    title: 'Boot Fitting',
    iconFamily: 'material',
    iconName: 'shoe-formal',
    color: '#795548',
  },
  {
    key: 'din',
    title: 'Understanding DIN',
    iconFamily: 'material',
    iconName: 'speedometer',
    color: AppColors.warning,
  },
  {
    key: 'wax',
    title: 'Kick Wax Guide',
    iconFamily: 'material',
    iconName: 'brush',
    color: AppColors.accent,
  },
  {
    key: 'checklist',
    title: 'Packing Essentials',
    iconFamily: 'ionicons',
    iconName: 'checkmark-circle',
    color: AppColors.primary,
  },
];

function TipRow({ text }: { text: string }) {
  return (
    <View className="flex-row items-start gap-x-2">
      <Ionicons
        name="checkmark-circle"
        size={14}
        color={AppColors.secondary}
        style={{ marginTop: 3 }}
      />
      <Text className="flex-1 text-sm leading-5 text-text-primary-light dark:text-text-primary-dark">
        {text}
      </Text>
    </View>
  );
}

function MeasuringContent() {
  return (
    <View className="gap-y-3">
      <TipRow text="Height: Measure without shoes, standing straight against a wall." />
      <TipRow text="Weight: Use a home scale without clothing for accuracy." />
      <TipRow text="Foot length (for boot sizing): Place foot on paper with heel against a wall. Mark the longest toe. Measure heel to mark in centimeters — this is your Mondo Point size." />
      <TipRow text="Boot Sole Length (BSL): Found printed inside the ski boot. For best accuracy, read the BSL directly from inside the boot. The app can estimate from shoe size or height, but actual BSL gives the most precise DIN result." />
      <TipRow text="Head circumference (for helmets): Measure around the widest part of the head, just above the eyebrows and ears." />
    </View>
  );
}

function AlpineContent() {
  return (
    <View className="gap-y-3">
      <TipRow text="Beginners: Shorter skis (chin to nose height) are easier to control and turn." />
      <TipRow text="Intermediate: Nose to forehead height — provides a balance of control and performance." />
      <TipRow text="Advanced: Forehead to top of head or taller — more speed and carving ability." />
      <TipRow text="Soft flex: Better for lighter, younger children on easier terrain." />
      <TipRow text="Stiff flex: Better for heavier, more advanced skiers at higher speeds." />
      <TipRow text="Always have bindings set by a certified ski technician at the start of each season." />
    </View>
  );
}

function XCContent() {
  return (
    <View className="gap-y-3">
      <TipRow text="Classic skis are longer and have a grip (kick) zone in the middle for pushing off." />
      <TipRow text="Skate skis are shorter and have no kick zone — suitable for children 8+ who have mastered classic technique." />
      <TipRow text="NNN (Rottefella), Prolink (Salomon/Atomic), and Turnamic (Fischer) bindings are cross-compatible — boots from any of these systems work together. Only legacy SNS bindings are NOT compatible with NNN/Prolink/Turnamic." />
      <TipRow text="Waxable classic skis need kick wax applied based on snow temperature." />
      <TipRow text="Waxless (fishscale) skis require no kick wax — ideal for beginners and recreational skiers." />
    </View>
  );
}

function HelmetContent() {
  const sizes: [string, string][] = [
    ['48–52 cm', 'XS / Kids S'],
    ['52–55.5 cm', 'S / Kids M'],
    ['55.5–59 cm', 'M / Kids L'],
    ['59–62 cm', 'L'],
  ];

  return (
    <View className="gap-y-3">
      <TipRow text="Measure head circumference at the widest point (just above eyebrows and ears)." />
      <View
        className="rounded-xl p-3 gap-y-2"
        style={{ backgroundColor: AppColors.primary + '0D' }}
      >
        <Text className="text-xs font-semibold mb-1 text-text-secondary-light dark:text-text-secondary-dark">
          Size Guide
        </Text>
        {sizes.map(([range, label]) => (
          <View key={range} className="flex-row">
            <Text className="w-24 text-xs text-text-secondary-light dark:text-text-secondary-dark">
              {range}
            </Text>
            <Text className="text-xs font-medium text-text-primary-light dark:text-text-primary-dark">
              {label}
            </Text>
          </View>
        ))}
      </View>
      <TipRow text="For head circumferences under 48 cm (typically toddlers), look for infant/toddler-specific helmets from specialty brands." />
      <TipRow text="NEVER buy a helmet with room to grow. A loose helmet will not protect properly in a crash. It should fit snugly with no wobble." />
      <TipRow text="Sizes vary between brands. Always check the specific manufacturer's size chart and try the helmet on before purchasing." />
      <TipRow text="Fit check: Helmet should sit level, two finger-widths above the eyebrows. Chinstrap should be snug — only one finger should fit between strap and chin." />
      <TipRow text="Look for certification: EN 1077 (Europe) or ASTM F2040 (USA)." />
    </View>
  );
}

function BootsContent() {
  const growthGuide: [string, string][] = [
    ['Under 6', '1.0–1.5 cm'],
    ['6–10 years', '1.0–1.5 cm'],
    ['10–14 years', '0.5–1.0 cm'],
    ['14+', '0–0.5 cm'],
  ];

  const flexGuide: [string, string][] = [
    ['50–60', 'Beginner, ages 5–9'],
    ['60–80', 'Intermediate, ages 8–12'],
    ['80–100', 'Advanced/teen, ages 12+'],
  ];

  return (
    <View className="gap-y-3">
      <TipRow text="Ski boots should NOT have the same room as regular shoes. Too much room causes poor control and blisters." />
      <TipRow text="For children, 1–1.5 cm of growth room is appropriate. Never buy boots more than 1.5 cm too large." />
      <View
        className="rounded-xl p-3 gap-y-2"
        style={{ backgroundColor: AppColors.secondary + '0D' }}
      >
        <Text className="text-xs font-semibold mb-1 text-text-secondary-light dark:text-text-secondary-dark">
          Growth Room Guide
        </Text>
        {growthGuide.map(([age, room]) => (
          <View key={age} className="flex-row">
            <Text className="w-24 text-xs text-text-secondary-light dark:text-text-secondary-dark">
              {age}
            </Text>
            <Text className="text-xs font-medium text-text-primary-light dark:text-text-primary-dark">
              {room}
            </Text>
          </View>
        ))}
      </View>
      <View
        className="rounded-xl p-3 gap-y-2"
        style={{ backgroundColor: AppColors.primary + '0D' }}
      >
        <Text className="text-xs font-semibold mb-1 text-text-secondary-light dark:text-text-secondary-dark">
          Flex Rating for Alpine Boots
        </Text>
        {flexGuide.map(([flex, desc]) => (
          <View key={flex} className="flex-row items-center gap-x-3">
            <Text
              className="w-14 text-xs font-semibold"
              style={{ color: AppColors.primary }}
            >
              {flex}
            </Text>
            <Text className="flex-1 text-xs text-text-primary-light dark:text-text-primary-dark">
              {desc}
            </Text>
          </View>
        ))}
      </View>
      <TipRow text="Children ages 2–4 typically use soft-shell boots without a standard flex rating. Look for the softest option available in their size." />
    </View>
  );
}

function DINContent() {
  return (
    <View className="gap-y-3">
      <TipRow text="DIN is the release force setting on alpine ski bindings. It controls how easily the binding releases in a fall." />
      <TipRow text="Too low: Skis release during normal skiing. Too high: Skis don't release in a dangerous fall — injury risk." />
      <TipRow text="Type I (Beginner): Prefers early release. Type II (Intermediate): Balanced. Type III (Advanced): Prefers retention." />
      <TipRow text="Junior adjustment: Children aged 9 and under receive a one-code reduction in their DIN setting for added safety, per ISO 11088." />
      <View
        className="rounded-xl p-3 flex-row items-start gap-x-2"
        style={{ backgroundColor: AppColors.warning + '14' }}
      >
        <Ionicons
          name="warning"
          size={14}
          color={AppColors.warning}
          style={{ marginTop: 2 }}
        />
        <Text
          className="flex-1 text-sm font-semibold"
          style={{ color: AppColors.warning }}
        >
          ALWAYS have bindings professionally set by a certified ski technician. Do not set DIN yourself based on app recommendations alone.
        </Text>
      </View>
    </View>
  );
}

function WaxContent() {
  const waxGuide: [string, string, string][] = [
    ['Above 0°C, old/icy snow', 'Klister (red/universal)', '#E53935'],
    ['0°C to +3°C, fresh snow', 'Red/silver hard wax', '#E53935'],
    ['-1°C to -3°C', 'Violet hard wax', '#9C27B0'],
    ['-3°C to -10°C', 'Blue hard wax', AppColors.primary],
    ['-10°C to -20°C', 'Green hard wax', AppColors.secondary],
    ['Below -20°C', 'Polar wax (white/green)', AppColors.secondary],
  ];

  return (
    <View className="gap-y-3">
      <TipRow text="Kick wax is only needed for classic XC skis. Waxless (fishscale) skis don't need it." />
      <View className="gap-y-2">
        {waxGuide.map(([temp, wax, color]) => (
          <View key={temp} className="flex-row items-center gap-x-2">
            <View
              style={{
                width: 10,
                height: 10,
                borderRadius: 5,
                backgroundColor: color,
                flexShrink: 0,
              }}
            />
            <Text className="w-36 text-xs text-text-secondary-light dark:text-text-secondary-dark">
              {temp}
            </Text>
            <Text className="flex-1 text-xs font-medium text-text-primary-light dark:text-text-primary-dark">
              {wax}
            </Text>
          </View>
        ))}
      </View>
      <TipRow text="Snow condition matters as much as temperature. Fresh snow generally uses harder (higher temperature) wax; old, transformed, or icy snow may need softer wax or klister." />
      <TipRow text="Always check the wax manufacturer's specific temperature guide. Wax brands vary in their optimal temperature ranges." />
    </View>
  );
}

const CHECKLIST_ITEMS: {
  key: string;
  label: string;
  tag?: { text: string; color: string };
}[] = [
  { key: 'helmet', label: 'Helmet (mandatory at most resorts)' },
  { key: 'goggles', label: 'Goggles or sunglasses (UV protection)' },
  { key: 'socks', label: 'Ski socks — wool or synthetic, never cotton' },
  { key: 'neck_gaiter', label: 'Neck gaiter or balaclava' },
  { key: 'din_checked', label: 'Bindings DIN checked this season', tag: { text: 'Alpine', color: AppColors.primary } },
  { key: 'xc_gloves', label: 'Lighter XC-specific gloves', tag: { text: 'XC', color: AppColors.secondary } },
  { key: 'xc_boots', label: 'Boots match binding system (NNN/Prolink)', tag: { text: 'XC', color: AppColors.secondary } },
  { key: 'xc_wax', label: 'Kick wax, or confirm skis are waxless', tag: { text: 'XC', color: AppColors.secondary } },
];

function ChecklistContent() {
  const { checklist, toggleChecklistItem, resetChecklist } = useAppSettingsStore();

  return (
    <View className="gap-y-1">
      <Text className="text-xs mb-2 text-text-secondary-light dark:text-text-secondary-dark">
        The easy-to-forget essentials
      </Text>
      {CHECKLIST_ITEMS.map((item) => (
        <ChecklistItem
          key={item.key}
          label={item.label}
          checked={checklist[item.key] ?? false}
          onToggle={() => toggleChecklistItem(item.key)}
          tag={item.tag}
        />
      ))}
      <Pressable
        onPress={resetChecklist}
        accessibilityRole="button"
        accessibilityLabel="Reset Checklist"
        className="mt-3 py-2"
      >
        <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
          Reset Checklist
        </Text>
      </Pressable>
    </View>
  );
}

function AccordionSection({
  section,
  isExpanded,
  onToggle,
}: {
  section: Section;
  isExpanded: boolean;
  onToggle: () => void;
}) {
  const colors = useThemeColors();

  return (
    <View
      className="rounded-2xl overflow-hidden bg-surface-light dark:bg-surface-dark"
      style={{
        shadowColor: '#000',
        shadowOpacity: 0.05,
        shadowRadius: 6,
        shadowOffset: { width: 0, height: 2 },
        elevation: 2,
      }}
    >
      <Pressable
        onPress={onToggle}
        accessibilityRole="button"
        accessibilityState={{ expanded: isExpanded }}
        accessibilityLabel={section.title}
        className="flex-row items-center px-4 py-4 gap-x-3"
      >
        <View className="w-7 items-center">
          {section.iconFamily === 'ionicons' ? (
            <Ionicons
              name={section.iconName as any}
              size={20}
              color={section.color}
            />
          ) : (
            <MaterialCommunityIcons
              name={section.iconName as any}
              size={20}
              color={section.color}
            />
          )}
        </View>
        <Text className="flex-1 text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
          {section.title}
        </Text>
        <Ionicons
          name={isExpanded ? 'chevron-up' : 'chevron-down'}
          size={14}
          color={colors.textSecondary}
        />
      </Pressable>

      {isExpanded && (
        <>
          <View
            className="mx-4"
            style={{ height: 1, backgroundColor: 'rgba(0,0,0,0.06)' }}
          />
          <View className="px-4 py-4">
            {section.key === 'measuring' && <MeasuringContent />}
            {section.key === 'alpine' && <AlpineContent />}
            {section.key === 'xc' && <XCContent />}
            {section.key === 'helmet' && <HelmetContent />}
            {section.key === 'boots' && <BootsContent />}
            {section.key === 'din' && <DINContent />}
            {section.key === 'wax' && <WaxContent />}
            {section.key === 'checklist' && <ChecklistContent />}
          </View>
        </>
      )}
    </View>
  );
}

export default function TipsScreen() {
  const [expandedSection, setExpandedSection] = useState<SectionKey | null>(null);

  function toggleSection(key: SectionKey) {
    LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
    setExpandedSection((prev) => (prev === key ? null : key));
  }

  return (
    <View className="flex-1 bg-background-light dark:bg-background-dark">
      {/* Header */}
      <View
        className="bg-surface-light dark:bg-surface-dark"
        style={{
          borderBottomWidth: 0.5,
          borderBottomColor: 'rgba(0,0,0,0.1)',
        }}
      >
        <View className="px-4 pt-16 pb-3">
          <Text className="text-3xl font-bold text-text-primary-light dark:text-text-primary-dark">
            Tips & Info
          </Text>
        </View>
      </View>

      <ScrollView
        contentContainerStyle={{ padding: 16, paddingBottom: 40 }}
        showsVerticalScrollIndicator={false}
      >
        {/* Header banner with gradient matching Swift */}
        <LinearGradient
          colors={[AppColors.primary, AppColors.secondary]}
          start={{ x: 0, y: 0.5 }}
          end={{ x: 1, y: 0.5 }}
          style={{
            borderRadius: 16,
            padding: 16,
            marginBottom: 16,
            flexDirection: 'row',
            alignItems: 'center',
            gap: 14,
            shadowColor: AppColors.primary,
            shadowOpacity: 0.3,
            shadowRadius: 8,
            shadowOffset: { width: 0, height: 4 },
            elevation: 4,
          }}
        >
          <MaterialCommunityIcons name="terrain" size={28} color="#FFFFFF" />
          <View className="flex-1">
            <Text className="text-base font-bold text-white">
              Ski Equipment Guide
            </Text>
            <Text
              className="text-xs mt-0.5"
              style={{ color: 'rgba(255,255,255,0.85)' }}
            >
              Expert tips from certified ski instructors and shops.
            </Text>
          </View>
        </LinearGradient>

        {/* Accordion sections */}
        <View className="gap-y-3">
          {SECTIONS.map((section) => (
            <AccordionSection
              key={section.key}
              section={section}
              isExpanded={expandedSection === section.key}
              onToggle={() => toggleSection(section.key)}
            />
          ))}
        </View>
      </ScrollView>
    </View>
  );
}
