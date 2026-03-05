import React from 'react';
import { Pressable, ScrollView, Text, View } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { router } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { useCalculatorStore } from '@/src/stores/calculator-store';
import { TagBadge } from '@/src/components/TagBadge';
import { AppColors } from '@/src/theme/colors';

function DINStepRow({
  step,
  title,
  detail,
}: {
  step: string;
  title: string;
  detail: string;
}) {
  return (
    <View className="flex-row items-start gap-x-3">
      <View
        className="items-center justify-center rounded-full"
        style={{
          width: 28,
          height: 28,
          backgroundColor: AppColors.primary + '1F',
          flexShrink: 0,
        }}
      >
        <Text
          className="text-xs font-bold"
          style={{ color: AppColors.primary }}
        >
          {step}
        </Text>
      </View>
      <View className="flex-1 gap-y-0.5">
        <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
          {title}
        </Text>
        <Text className="text-xs leading-4 text-text-secondary-light dark:text-text-secondary-dark">
          {detail}
        </Text>
      </View>
    </View>
  );
}

export default function DINDetailScreen() {
  const recommendation = useCalculatorStore((s) => s.recommendation);
  const dinResult = recommendation?.dinResult ?? null;
  const childName = recommendation?.childName ?? '';

  if (!dinResult) {
    return (
      <View className="flex-1 items-center justify-center bg-background-light dark:bg-background-dark gap-y-4">
        <Text className="text-base text-text-secondary-light dark:text-text-secondary-dark">
          No DIN data available
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

  const displayName = childName.trim().length > 0 ? childName : 'Your Child';
  const formattedValue =
    dinResult.value % 1 === 0
      ? `${dinResult.value}.0`
      : `${dinResult.value}`;

  const steps: { step: string; title: string; detail: string }[] = [
    {
      step: '1',
      title: 'Weight → DIN Code',
      detail: `Your child's weight determined the base code ${dinResult.code}`,
    },
    {
      step: '2',
      title: 'Height Check',
      detail: 'Height was checked against code thresholds (conservative for children)',
    },
    {
      step: '3',
      title: 'Boot Sole Length → DIN Value',
      detail: 'Boot sole length used to look up the exact DIN value from the ISO 11088 table',
    },
  ];

  if (dinResult.isJuniorAdjusted) {
    steps.push({
      step: '4',
      title: 'Junior Safety Adjustment',
      detail:
        'Per ISO 11088, children aged 9 and under receive a one-level lower DIN code. This makes bindings release more easily, reducing injury risk for younger skiers.',
    });
  }

  steps.push({
    step: dinResult.isJuniorAdjusted ? '5' : '4',
    title: 'Round to 0.25',
    detail: 'Final value rounded to nearest 0.25 increment',
  });

  return (
    <View className="flex-1 bg-background-light dark:bg-background-dark">
      <View
        className="flex-row items-center justify-between px-4 py-3 bg-surface-light dark:bg-surface-dark"
        style={{
          borderBottomWidth: 1,
          borderBottomColor: 'rgba(0,0,0,0.06)',
        }}
      >
        <Text className="text-lg font-bold text-text-primary-light dark:text-text-primary-dark">
          DIN Detail
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
        contentContainerStyle={{ padding: 16, paddingBottom: 40 }}
        showsVerticalScrollIndicator={false}
      >
        {/* Hero */}
        <View
          className="items-center rounded-2xl p-6 mb-5 bg-surface-light dark:bg-surface-dark"
          style={{
            shadowColor: '#000',
            shadowOpacity: 0.06,
            shadowRadius: 10,
            shadowOffset: { width: 0, height: 3 },
            elevation: 3,
          }}
        >
          <LinearGradient
            colors={[AppColors.warning, AppColors.warning + 'B3']}
            start={{ x: 0, y: 0 }}
            end={{ x: 1, y: 1 }}
            style={{
              width: 120,
              height: 120,
              borderRadius: 60,
              alignItems: 'center',
              justifyContent: 'center',
              marginBottom: 16,
              shadowColor: AppColors.warning,
              shadowOpacity: 0.4,
              shadowRadius: 12,
              shadowOffset: { width: 0, height: 6 },
              elevation: 6,
            }}
          >
            <Text
              className="font-bold text-white"
              style={{ fontSize: 40, fontVariant: ['tabular-nums'] }}
            >
              {formattedValue}
            </Text>
            <Text
              className="text-xs font-semibold"
              style={{ color: 'rgba(255,255,255,0.9)' }}
            >
              DIN
            </Text>
          </LinearGradient>

          <Text className="text-base font-semibold mb-3 text-text-primary-light dark:text-text-primary-dark">
            Recommended for {displayName}
          </Text>

          <View className="flex-row flex-wrap items-center justify-center gap-x-2 gap-y-1.5">
            <TagBadge
              label={`Code ${dinResult.code}`}
              color={AppColors.primary + '1F'}
              textColor={AppColors.primary}
            />
            <TagBadge
              label={dinResult.skierType}
              color={AppColors.secondary + '1F'}
              textColor={AppColors.secondary}
            />
            {dinResult.isJuniorAdjusted && (
              <TagBadge
                label="Junior (code shift)"
                color={AppColors.warning + '1F'}
                textColor={AppColors.warning}
              />
            )}
          </View>
        </View>

        {/* What is DIN */}
        <View
          className="rounded-2xl p-4 mb-4 bg-surface-light dark:bg-surface-dark"
          style={{
            shadowColor: '#000',
            shadowOpacity: 0.05,
            shadowRadius: 6,
            shadowOffset: { width: 0, height: 2 },
            elevation: 2,
          }}
        >
          <View className="flex-row items-center gap-x-2 mb-3">
            <Ionicons
              name="information-circle"
              size={18}
              color={AppColors.primary}
            />
            <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
              What is DIN?
            </Text>
          </View>
          <Text className="text-sm leading-5 mb-3 text-text-primary-light dark:text-text-primary-dark">
            DIN (Deutsches Institut für Normung) is the release force setting on alpine ski bindings. It controls how easily the binding releases during a fall to prevent injury.
          </Text>
          <View className="flex-row items-start gap-x-2 mb-2">
            <Ionicons
              name="arrow-down-circle"
              size={16}
              color={AppColors.secondary}
              style={{ marginTop: 1 }}
            />
            <Text className="flex-1 text-sm text-text-secondary-light dark:text-text-secondary-dark">
              Lower settings release more easily (safer for beginners)
            </Text>
          </View>
          <View className="flex-row items-start gap-x-2">
            <Ionicons
              name="arrow-up-circle"
              size={16}
              color={AppColors.accent}
              style={{ marginTop: 1 }}
            />
            <Text className="flex-1 text-sm text-text-secondary-light dark:text-text-secondary-dark">
              Higher settings hold more securely (for advanced skiers)
            </Text>
          </View>
        </View>

        {/* How DIN Was Calculated */}
        <View
          className="rounded-2xl p-4 mb-4 bg-surface-light dark:bg-surface-dark"
          style={{
            shadowColor: '#000',
            shadowOpacity: 0.05,
            shadowRadius: 6,
            shadowOffset: { width: 0, height: 2 },
            elevation: 2,
          }}
        >
          <View className="flex-row items-center gap-x-2 mb-3">
            <MaterialCommunityIcons
              name="function"
              size={18}
              color={AppColors.secondary}
            />
            <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
              How Your DIN Was Calculated
            </Text>
          </View>
          <View className="gap-y-3">
            {steps.map((s) => (
              <DINStepRow
                key={s.step}
                step={s.step}
                title={s.title}
                detail={s.detail}
              />
            ))}
          </View>
        </View>

        {/* Warnings */}
        {dinResult.warnings.length > 0 && (
          <View
            className="rounded-2xl p-4 mb-4"
            style={{
              backgroundColor: AppColors.warning + '14',
              borderWidth: 1,
              borderColor: AppColors.warning + '4D',
            }}
          >
            <View className="flex-row items-center gap-x-2 mb-3">
              <Ionicons
                name="warning"
                size={18}
                color={AppColors.warning}
              />
              <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
                Additional Warnings
              </Text>
            </View>
            <View className="gap-y-2">
              {dinResult.warnings.map((warning, idx) => (
                <View key={idx} className="flex-row items-start gap-x-2">
                  <Ionicons
                    name="alert-circle"
                    size={14}
                    color={AppColors.warning}
                    style={{ marginTop: 2 }}
                  />
                  <Text className="flex-1 text-sm leading-5 text-text-primary-light dark:text-text-primary-dark">
                    {warning}
                  </Text>
                </View>
              ))}
            </View>
          </View>
        )}

        {/* Safety Disclaimer */}
        <View
          className="rounded-2xl p-4"
          style={{
            backgroundColor: AppColors.warning + '14',
            borderWidth: 1.5,
            borderColor: AppColors.warning + '66',
          }}
        >
          <View className="flex-row items-center gap-x-2 mb-2">
            <MaterialCommunityIcons
              name="shield-alert"
              size={22}
              color={AppColors.warning}
            />
            <Text className="text-base font-bold text-text-primary-light dark:text-text-primary-dark">
              Important Safety Notice
            </Text>
          </View>
          <Text className="text-sm leading-5 mb-3 text-text-primary-light dark:text-text-primary-dark">
            DIN release values shown are recommendations based on the ISO 11088 standard lookup table. They must be verified and set by a certified ski technician. Incorrect DIN settings can result in serious injury. The app developer and publisher accept no liability for binding settings applied without professional verification.
          </Text>
          <Text
            className="text-sm font-medium leading-5"
            style={{ color: AppColors.warning }}
          >
            Always have bindings professionally adjusted at the start of each season and whenever measurements change significantly.
          </Text>
        </View>
      </ScrollView>
    </View>
  );
}
