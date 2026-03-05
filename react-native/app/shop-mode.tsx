import React from 'react';
import { Pressable, ScrollView, Text, View } from 'react-native';
import { router } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { useCalculatorStore } from '@/src/stores/calculator-store';
import { AppColors } from '@/src/theme/colors';
import { SkiLengthRange } from '@/src/models/types';

function formatRange(range: SkiLengthRange): string {
  return `${range.minCm}–${range.maxCm} cm`;
}

function StatCard({ label, value }: { label: string; value: string }) {
  return (
    <View className="flex-1 items-center rounded-2xl py-4 px-3 bg-surface-light dark:bg-surface-dark">
      <Text
        className="text-xl font-bold mb-1 text-text-primary-light dark:text-text-primary-dark"
        style={{ fontVariant: ['tabular-nums'] }}
      >
        {value}
      </Text>
      <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
        {label}
      </Text>
    </View>
  );
}

function ShopRow({
  icon,
  label,
  value,
  iconColor,
  isIonicon,
  showDivider,
}: {
  icon: string;
  label: string;
  value: string;
  iconColor: string;
  isIonicon?: boolean;
  showDivider?: boolean;
}) {
  return (
    <View>
      <View className="flex-row items-center py-3">
        <View className="w-9 items-center mr-4">
          {isIonicon ? (
            <Ionicons name={icon as any} size={28} color={iconColor} />
          ) : (
            <MaterialCommunityIcons name={icon as any} size={28} color={iconColor} />
          )}
        </View>
        <Text className="flex-1 text-lg text-text-secondary-light dark:text-text-secondary-dark">
          {label}
        </Text>
        <Text
          className="font-bold text-text-primary-light dark:text-text-primary-dark"
          style={{ fontSize: 32, fontVariant: ['tabular-nums'] }}
        >
          {value}
        </Text>
      </View>
      {showDivider && (
        <View style={{ height: 1, backgroundColor: 'rgba(0,0,0,0.07)' }} />
      )}
    </View>
  );
}

export default function ShopModeScreen() {
  const recommendation = useCalculatorStore((s) => s.recommendation);

  if (!recommendation) {
    return (
      <View className="flex-1 items-center justify-center bg-background-light dark:bg-background-dark gap-y-4">
        <Text className="text-base text-text-secondary-light dark:text-text-secondary-dark">
          No recommendation data available
        </Text>
        <Pressable
          onPress={() => router.back()}
          accessibilityRole="button"
          className="rounded-xl px-6 py-3"
          style={{ backgroundColor: AppColors.primary }}
        >
          <Text className="text-base font-semibold text-white">Close</Text>
        </Pressable>
      </View>
    );
  }

  const displayName =
    (recommendation.childName ?? '').trim().length > 0
      ? recommendation.childName
      : 'Child';

  const dinResult = recommendation.dinResult;
  const dinFormattedValue =
    dinResult
      ? dinResult.value % 1 === 0
        ? `${dinResult.value}.0`
        : `${dinResult.value}`
      : null;

  const shopRows: { icon: string; label: string; value: string; iconColor: string; isIonicon?: boolean }[] = [
    ...(recommendation.alpineSkiLength ? [{ icon: 'ski', label: 'Alpine Skis', value: formatRange(recommendation.alpineSkiLength), iconColor: AppColors.primary }] : []),
    ...(dinResult && dinFormattedValue ? [{ icon: 'speedometer', label: `DIN Setting  (Code ${dinResult.code}, ${dinResult.skierType})`, value: dinFormattedValue, iconColor: AppColors.warning }] : []),
    ...(recommendation.xcClassicLength ? [{ icon: 'ski-cross-country', label: 'XC Classic', value: formatRange(recommendation.xcClassicLength), iconColor: AppColors.secondary }] : []),
    ...(recommendation.xcSkateLength ? [{ icon: 'ski-cross-country', label: 'XC Skate', value: formatRange(recommendation.xcSkateLength), iconColor: AppColors.secondary }] : []),
    ...(recommendation.alpinePoleLength ? [{ icon: 'arrow-expand-vertical', label: 'Alpine Poles', value: `${recommendation.alpinePoleLength} cm`, iconColor: AppColors.primary }] : []),
    ...(recommendation.xcClassicPoleLength ? [{ icon: 'arrow-expand-vertical', label: 'Classic Poles', value: `${recommendation.xcClassicPoleLength} cm`, iconColor: AppColors.secondary }] : []),
    ...(recommendation.xcSkatePoleLength ? [{ icon: 'arrow-expand-vertical', label: 'Skate Poles', value: `${recommendation.xcSkatePoleLength} cm`, iconColor: AppColors.secondary }] : []),
  ];

  return (
    <View className="flex-1 bg-background-light dark:bg-background-dark">
      {/* Header */}
      <View
        className="flex-row items-center justify-between px-4 py-3 bg-surface-light dark:bg-surface-dark"
        style={{
          borderBottomWidth: 1,
          borderBottomColor: 'rgba(0,0,0,0.06)',
        }}
      >
        <Text className="text-lg font-bold text-text-primary-light dark:text-text-primary-dark">
          Ski Shop
        </Text>
        <Pressable
          onPress={() => router.back()}
          accessibilityRole="button"
          accessibilityLabel="Done"
          className="px-2 py-1"
        >
          <Text className="text-base font-semibold" style={{ color: AppColors.primary }}>
            Done
          </Text>
        </Pressable>
      </View>

      <ScrollView
        contentContainerStyle={{ paddingVertical: 24, paddingHorizontal: 20 }}
        showsVerticalScrollIndicator={false}
      >
        {/* Child name */}
        <Text className="text-3xl font-bold text-center mb-6 text-text-primary-light dark:text-text-primary-dark">
          {displayName}
        </Text>

        {/* Stat cards */}
        <View className="flex-row gap-x-3 mb-6">
          <StatCard label="Height" value={`${recommendation.heightCm} cm`} />
          <StatCard label="Weight" value={`${recommendation.weightKg} kg`} />
          <StatCard label="Age" value={`${recommendation.age}`} />
        </View>

        {/* Divider */}
        <View
          className="mb-6"
          style={{ height: 1, backgroundColor: 'rgba(0,0,0,0.1)' }}
        />

        {/* Recommendation rows */}
        <View>
          {shopRows.map((row, index) => (
            <ShopRow
              key={index}
              icon={row.icon}
              label={row.label}
              value={row.value}
              iconColor={row.iconColor}
              isIonicon={row.isIonicon}
              showDivider={index < shopRows.length - 1}
            />
          ))}
        </View>

        {/* DIN warning */}
        {dinResult && (
          <View
            className="mt-8 rounded-2xl p-4"
            style={{
              backgroundColor: AppColors.warning + '14',
              borderWidth: 1,
              borderColor: AppColors.warning + '4D',
            }}
          >
            <View className="flex-row items-start gap-x-2">
              <Ionicons
                name="warning"
                size={18}
                color={AppColors.warning}
                style={{ marginTop: 1 }}
              />
              <Text
                className="flex-1 text-sm font-semibold leading-5"
                style={{ color: AppColors.warning }}
              >
                DIN setting must be verified and set by a certified ski technician
              </Text>
            </View>
          </View>
        )}
      </ScrollView>
    </View>
  );
}
