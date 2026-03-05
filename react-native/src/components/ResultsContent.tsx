import React, { useEffect, useState } from 'react';
import { View, Text, ScrollView, Pressable } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import * as Haptics from 'expo-haptics';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { router } from 'expo-router';
import { SkiRecommendation, SkiType } from '../models/types';
import { AppColors, useThemeColors } from '../theme/colors';
import { RecommendationCard } from './RecommendationCard';
import { DINCard } from './DINCard';
import { SkiLengthVisual } from './SkiLengthVisual';
import { InfoBanner } from './InfoBanner';
import { TagBadge } from './TagBadge';
import { AppIcons } from '../theme/icons';
import {
  bootFlexRecommendation,
  helmetSizeEstimate,
  growthRoomGuide,
} from '../calculators/ski-calculator';
import { insertChild } from '../db/child-repository';
import { useCalculatorStore } from '../stores/calculator-store';
import { BSLInputMode } from '../models/types';

const ABILITY_COLORS: Record<string, string> = {
  Beginner: AppColors.secondary,
  Intermediate: AppColors.primary,
  Advanced: AppColors.accent,
};

const PURPLE = '#9C27B0';
const BROWN = '#795548';

interface ResultsContentProps {
  recommendation: SkiRecommendation;
  showSaveButton?: boolean;
  onSaved?: () => void;
}

function SectionHeader({ title, iconName, iconFamily, color }: {
  title: string;
  iconName: string;
  iconFamily: 'ionicons' | 'material';
  color: string;
}) {
  return (
    <View className="flex-row items-center gap-x-2">
      {iconFamily === 'ionicons' ? (
        <Ionicons name={iconName as any} size={18} color={color} />
      ) : (
        <MaterialCommunityIcons name={iconName as any} size={18} color={color} />
      )}
      <Text className="text-base font-bold text-text-primary-light dark:text-text-primary-dark">
        {title}
      </Text>
    </View>
  );
}

export function ResultsContent({ recommendation, showSaveButton = false, onSaved }: ResultsContentProps) {
  const [saved, setSaved] = useState(false);
  const store = useCalculatorStore();
  const colors = useThemeColors();

  useEffect(() => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
  }, []);

  const childName = recommendation.childName.trim() || 'Your Child';
  const abilityColor = ABILITY_COLORS[recommendation.abilityLevel] ?? AppColors.primary;

  const hasAlpine = recommendation.alpineSkiLength != null || recommendation.dinResult != null;
  const hasXC = recommendation.xcClassicLength != null || recommendation.xcSkateLength != null;
  const hasPoles =
    recommendation.alpinePoleLength != null ||
    recommendation.xcClassicPoleLength != null ||
    recommendation.xcSkatePoleLength != null;

  function formatRange(min: number, max: number): string {
    if (min === max) return `${min} cm`;
    return `${min}–${max} cm`;
  }

  function handleSave() {
    if (saved) return;
    const bslInputMode = store.bslInputMode;
    insertChild({
      name: store.name,
      heightCm: store.heightCm,
      weightKg: store.weightKg,
      age: store.age,
      bslMm: bslInputMode === BSLInputMode.BSL ? store.bslMm : null,
      bslInputModeRaw: bslInputMode,
      shoeSize: bslInputMode === BSLInputMode.ShoeSize ? store.shoeSize : null,
      abilityLevel: store.abilityLevel,
      skiTypes: store.selectedSkiTypes,
      lastCalculated: recommendation.calculatedAt,
    });
    setSaved(true);
    onSaved?.();
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
  }

  return (
    <ScrollView
      className="flex-1 bg-background-light dark:bg-background-dark"
      contentContainerStyle={{ paddingHorizontal: 16, paddingTop: 12, paddingBottom: 40 }}
    >
      <View className="gap-y-5">
        {/* Header card */}
        <View
          className="bg-surface-light dark:bg-surface-dark rounded-2xl p-4"
          style={{ shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.05, shadowRadius: 6, elevation: 2 }}
        >
          <View className="flex-row items-start">
            <View className="flex-1 gap-y-1.5">
              <Text className="text-xl font-bold text-text-primary-light dark:text-text-primary-dark">
                {childName}
              </Text>
              <View className="flex-row items-center gap-x-3 flex-wrap">
                <View className="flex-row items-center gap-x-1">
                  <Ionicons name="resize" size={12} color={colors.textSecondary} />
                  <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
                    {recommendation.heightCm} cm
                  </Text>
                </View>
                <View className="flex-row items-center gap-x-1">
                  <MaterialCommunityIcons name="scale-bathroom" size={12} color={colors.textSecondary} />
                  <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
                    {recommendation.weightKg} kg
                  </Text>
                </View>
                <View className="flex-row items-center gap-x-1">
                  <MaterialCommunityIcons name="cake-variant" size={12} color={colors.textSecondary} />
                  <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
                    {recommendation.age} yrs
                  </Text>
                </View>
              </View>
            </View>
            <View className="items-end gap-y-1.5">
              <TagBadge
                label={recommendation.abilityLevel}
                color={abilityColor + '1A'}
                textColor={abilityColor}
              />
              <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
                {recommendation.calculatedAt.toLocaleDateString()}
              </Text>
            </View>
          </View>
        </View>

        {/* Show to Ski Shop button */}
        <Pressable
          onPress={() => router.push('/shop-mode')}
          accessibilityRole="button"
          accessibilityLabel="Show to Ski Shop"
          style={({ pressed }) => ({ opacity: pressed ? 0.75 : 1 })}
        >
          <View
            className="flex-row items-center justify-center gap-x-2 py-3 rounded-xl"
            style={{ backgroundColor: AppColors.primary + '14' }}
          >
            <MaterialCommunityIcons name="store" size={18} color={AppColors.primary} />
            <Text className="text-sm font-semibold" style={{ color: AppColors.primary }}>
              Show to Ski Shop
            </Text>
          </View>
        </Pressable>

        {/* Warnings */}
        {recommendation.warnings.length > 0 && (
          <View
            className="rounded-2xl p-3.5 gap-y-2.5"
            style={{
              backgroundColor: AppColors.warning + '14',
              borderWidth: 1,
              borderColor: AppColors.warning + '4D',
            }}
          >
            <View className="flex-row items-center gap-x-2">
              <Ionicons name="warning" size={16} color={AppColors.warning} />
              <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
                Notes
              </Text>
            </View>
            {recommendation.warnings.map((w, i) => (
              <View key={i} className="flex-row items-start gap-x-2">
                <View
                  className="rounded-full mt-1.5"
                  style={{ width: 6, height: 6, backgroundColor: AppColors.warning }}
                />
                <Text className="flex-1 text-xs text-text-primary-light dark:text-text-primary-dark">
                  {w}
                </Text>
              </View>
            ))}
          </View>
        )}

        {/* Alpine section */}
        {hasAlpine && (
          <View className="gap-y-3">
            <SectionHeader
              title="Alpine / Downhill"
              iconName="ski"
              iconFamily="material"
              color={AppColors.primary}
            />

            {recommendation.alpineSkiLength && (
              <>
                <RecommendationCard
                  icon={AppIcons.ruler}
                  iconColor={AppColors.primary}
                  title="Ski Length"
                  subtitle="Height-based sizing"
                  value={formatRange(recommendation.alpineSkiLength.minCm, recommendation.alpineSkiLength.maxCm)}
                />
                <SkiLengthVisual
                  minCm={recommendation.alpineSkiLength.minCm}
                  maxCm={recommendation.alpineSkiLength.maxCm}
                  heightCm={recommendation.heightCm}
                  color={AppColors.primary}
                />
                <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark px-1">
                  Younger/lighter children should choose softer-flex skis at the lower end of the range. Heavier or more advanced children can use the upper end.
                </Text>
              </>
            )}

            {recommendation.dinResult && (
              <DINCard
                dinValue={String(recommendation.dinResult.value)}
                code={recommendation.dinResult.code}
                skierType={recommendation.dinResult.skierType}
                isJuniorAdjusted={recommendation.dinResult.isJuniorAdjusted}
                onPress={() => router.push('/din-detail')}
              />
            )}
          </View>
        )}

        {/* XC section */}
        {hasXC && (
          <View className="gap-y-3">
            <SectionHeader
              title="Cross-Country"
              iconName="ski-cross-country"
              iconFamily="material"
              color={AppColors.secondary}
            />

            {recommendation.xcClassicLength && (
              <>
                <RecommendationCard
                  icon={AppIcons.skiCrossCountry}
                  iconColor={AppColors.secondary}
                  title="Classic Ski Length"
                  subtitle="For kick-and-glide technique"
                  value={formatRange(recommendation.xcClassicLength.minCm, recommendation.xcClassicLength.maxCm)}
                />
                <SkiLengthVisual
                  minCm={recommendation.xcClassicLength.minCm}
                  maxCm={recommendation.xcClassicLength.maxCm}
                  heightCm={recommendation.heightCm}
                  color={AppColors.secondary}
                />
                <InfoBanner
                  text="Classic ski length also depends on weight. Lighter children may need shorter/softer skis to compress the kick zone properly."
                  color={AppColors.secondary}
                />
              </>
            )}

            {recommendation.xcSkateLength && (
              <RecommendationCard
                icon={AppIcons.skiSkate}
                iconColor={AppColors.secondary}
                title="Skate Ski Length"
                subtitle="For skating technique"
                value={formatRange(recommendation.xcSkateLength.minCm, recommendation.xcSkateLength.maxCm)}
              />
            )}

            <InfoBanner
              text="NNN (Rottefella), Prolink (Salomon/Atomic), and Turnamic (Fischer) are cross-compatible. Only legacy SNS bindings require SNS-specific boots."
              color={AppColors.secondary}
            />
          </View>
        )}

        {/* Poles section */}
        {hasPoles && (
          <View className="gap-y-3">
            <SectionHeader
              title="Pole Lengths"
              iconName="arrow-expand-vertical"
              iconFamily="material"
              color={PURPLE}
            />

            {recommendation.alpinePoleLength != null && (
              <RecommendationCard
                icon={AppIcons.pole}
                iconColor={AppColors.primary}
                title="Alpine Poles"
                subtitle="Height × 0.68"
                value={`${recommendation.alpinePoleLength} cm`}
                detail="Grip pole upside down below the basket — elbow should form a 90° angle."
              />
            )}

            {recommendation.xcClassicPoleLength != null && (
              <RecommendationCard
                icon={AppIcons.pole}
                iconColor={AppColors.secondary}
                title="XC Classic Poles"
                subtitle="Height × 0.84"
                value={`${recommendation.xcClassicPoleLength} cm`}
                detail="Tip should reach between armpit and shoulder when standing normally."
              />
            )}

            {recommendation.xcSkatePoleLength != null && (
              <RecommendationCard
                icon={AppIcons.pole}
                iconColor={AppColors.secondary}
                title="XC Skate Poles"
                subtitle="Height × 0.89"
                value={`${recommendation.xcSkatePoleLength} cm`}
                detail="Tip should reach between chin and nose when standing."
              />
            )}
          </View>
        )}

        {/* Equipment guide */}
        {(hasAlpine || hasXC) && (
          <View className="gap-y-3">
            <SectionHeader
              title="Equipment Guide"
              iconName="bag"
              iconFamily="ionicons"
              color={BROWN}
            />

            {hasAlpine && (
              <RecommendationCard
                icon={AppIcons.boot}
                iconColor={BROWN}
                title="Alpine Boot Flex"
                subtitle="Flex index (lower = softer)"
                value={bootFlexRecommendation(recommendation.age, recommendation.abilityLevel)}
                detail={`Flex measures boot stiffness. Softer boots are easier to control for beginners and younger children. Growth room: ${growthRoomGuide(recommendation.age)}. Never buy boots more than 1.5 cm too large.`}
              />
            )}

            <RecommendationCard
              icon={AppIcons.helmet}
              iconColor={PURPLE}
              title="Helmet Size (estimate)"
              subtitle="Based on typical age range"
              value={helmetSizeEstimate(recommendation.age)}
              detail="Head sizes vary widely at the same age. Measure head circumference for accurate sizing. Never buy a helmet with room to grow."
            />
          </View>
        )}

        {/* Safety disclaimer */}
        <View
          className="rounded-2xl p-3.5 gap-y-2"
          style={{
            backgroundColor: AppColors.warning + '0F',
            borderWidth: 1.5,
            borderColor: AppColors.warning + '66',
          }}
        >
          <View className="flex-row items-center gap-x-2">
            <MaterialCommunityIcons name="shield-alert" size={16} color={AppColors.warning} />
            <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
              Safety Disclaimer
            </Text>
          </View>
          <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
            DIN release values shown are recommendations based on the ISO 11088 standard lookup table. They must be verified and set by a certified ski technician. Incorrect DIN settings can result in serious injury. The app developer and publisher accept no liability for binding settings applied without professional verification.
          </Text>
        </View>

        {/* Save button with gradient matching Swift */}
        {showSaveButton && !saved && (
          <Pressable
            onPress={handleSave}
            accessibilityRole="button"
            accessibilityLabel="Save Profile"
            style={({ pressed }) => ({ opacity: pressed ? 0.85 : 1 })}
          >
            <LinearGradient
              colors={[AppColors.primary, AppColors.secondary]}
              start={{ x: 0, y: 0.5 }}
              end={{ x: 1, y: 0.5 }}
              style={{
                borderRadius: 16,
                flexDirection: 'row',
                alignItems: 'center',
                justifyContent: 'center',
                gap: 8,
                paddingVertical: 16,
                shadowColor: AppColors.primary,
                shadowOffset: { width: 0, height: 4 },
                shadowOpacity: 0.35,
                shadowRadius: 8,
                elevation: 6,
              }}
            >
              <Ionicons name="person-add" size={20} color="#FFFFFF" />
              <Text className="text-base font-bold text-white">Save Profile</Text>
            </LinearGradient>
          </Pressable>
        )}

        {showSaveButton && saved && (
          <View
            className="rounded-2xl items-center justify-center flex-row gap-x-2 py-4"
            style={{ backgroundColor: AppColors.secondary + '1A' }}
          >
            <Ionicons name="checkmark-circle" size={20} color={AppColors.secondary} />
            <Text className="text-base font-semibold" style={{ color: AppColors.secondary }}>
              Profile Saved
            </Text>
          </View>
        )}
      </View>
    </ScrollView>
  );
}
