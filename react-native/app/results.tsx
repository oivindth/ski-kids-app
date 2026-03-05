import React from 'react';
import { View, Text, Pressable, Share } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { router } from 'expo-router';
import { useCalculatorStore } from '@/src/stores/calculator-store';
import { ResultsContent } from '@/src/components/ResultsContent';
import { AppColors } from '@/src/theme/colors';
import { generateShareText } from '@/src/utils/share-text';

export default function ResultsScreen() {
  const recommendation = useCalculatorStore((s) => s.recommendation);

  function handleShare() {
    if (!recommendation) return;
    Share.share({ message: generateShareText(recommendation) });
  }

  if (!recommendation) {
    return (
      <View className="flex-1 items-center justify-center bg-background-light dark:bg-background-dark px-8 gap-y-4">
        <Ionicons name="alert-circle-outline" size={48} color={AppColors.warning} />
        <Text className="text-base font-semibold text-text-primary-light dark:text-text-primary-dark text-center">
          No results available. Please calculate first.
        </Text>
        <Pressable onPress={() => router.back()} hitSlop={8} accessibilityRole="button">
          <Text className="text-sm font-semibold" style={{ color: AppColors.primary }}>
            Go back
          </Text>
        </Pressable>
      </View>
    );
  }

  return (
    <View className="flex-1 bg-background-light dark:bg-background-dark">
      {/* Header */}
      <View
        className="flex-row items-center px-4 pt-14 pb-3 bg-surface-light dark:bg-surface-dark"
        style={{ borderBottomWidth: 0.5, borderBottomColor: AppColors.textSecondary.light + '33' }}
      >
        <Pressable
          onPress={() => router.back()}
          hitSlop={8}
          accessibilityRole="button"
          accessibilityLabel="Back"
        >
          <Ionicons name="chevron-back" size={24} color={AppColors.primary} />
        </Pressable>

        <Text className="flex-1 text-base font-semibold text-text-primary-light dark:text-text-primary-dark text-center">
          Results
        </Text>

        <Pressable
          onPress={handleShare}
          hitSlop={8}
          accessibilityRole="button"
          accessibilityLabel="Share results"
        >
          <Ionicons name="share-outline" size={22} color={AppColors.primary} />
        </Pressable>
      </View>

      <ResultsContent recommendation={recommendation} showSaveButton />
    </View>
  );
}
