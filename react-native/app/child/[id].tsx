import React, { useEffect, useState } from 'react';
import { View, Text, Pressable, Share, ActivityIndicator } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { router, useLocalSearchParams } from 'expo-router';
import { getChild } from '@/src/db/child-repository';
import { useCalculatorStore } from '@/src/stores/calculator-store';
import { ResultsContent } from '@/src/components/ResultsContent';
import { AppColors } from '@/src/theme/colors';
import { generateShareText } from '@/src/utils/share-text';
import type { Child } from '@/src/models/types';
import type { SkiRecommendation } from '@/src/models/types';

export default function ChildResultsScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const [child, setChild] = useState<Child | null>(null);
  const [loading, setLoading] = useState(true);

  const store = useCalculatorStore();
  const recommendation = store.recommendation;
  const hasAttempted = store.hasAttemptedCalculation;

  useEffect(() => {
    if (!id) {
      setLoading(false);
      return;
    }
    const found = getChild(id);
    setChild(found);
    if (found) {
      store.populateFromChild(found);
      store.calculate();
    }
    setLoading(false);
  }, [id]);

  function handleShare() {
    if (!recommendation) return;
    Share.share({ message: generateShareText(recommendation) });
  }

  if (loading) {
    return (
      <View className="flex-1 items-center justify-center bg-background-light dark:bg-background-dark">
        <ActivityIndicator size="large" color={AppColors.primary} />
      </View>
    );
  }

  if (!child) {
    return (
      <View className="flex-1 items-center justify-center bg-background-light dark:bg-background-dark px-8 gap-y-4">
        <Ionicons name="alert-circle-outline" size={48} color={AppColors.warning} />
        <Text className="text-base font-semibold text-text-primary-light dark:text-text-primary-dark text-center">
          Child profile not found.
        </Text>
        <Pressable onPress={() => router.back()} hitSlop={8}>
          <Text className="text-sm font-semibold" style={{ color: AppColors.primary }}>
            Go back
          </Text>
        </Pressable>
      </View>
    );
  }

  if (hasAttempted && !recommendation) {
    return (
      <View className="flex-1 bg-background-light dark:bg-background-dark">
        <View
          className="flex-row items-center px-4 pt-14 pb-3 bg-surface-light dark:bg-surface-dark"
          style={{ borderBottomWidth: 0.5, borderBottomColor: AppColors.textSecondary.light + '33' }}
        >
          <Pressable onPress={() => router.back()} hitSlop={8} accessibilityRole="button" accessibilityLabel="Back">
            <Ionicons name="chevron-back" size={24} color={AppColors.primary} />
          </Pressable>
          <Text
            className="flex-1 text-base font-semibold text-text-primary-light dark:text-text-primary-dark ml-2"
            numberOfLines={1}
          >
            {child.name.trim() || 'Child'}
          </Text>
        </View>
        <View className="flex-1 items-center justify-center px-8 gap-y-4">
          <Ionicons name="warning-outline" size={48} color={AppColors.warning} />
          <Text className="text-base font-semibold text-text-primary-light dark:text-text-primary-dark text-center">
            Unable to calculate recommendations.
          </Text>
          <Pressable
            onPress={() => router.push(`/child/${id}/edit`)}
            hitSlop={8}
            accessibilityRole="button"
          >
            <Text className="text-sm font-semibold" style={{ color: AppColors.primary }}>
              Edit Profile
            </Text>
          </Pressable>
        </View>
      </View>
    );
  }

  const displayName = child.name.trim() || 'Child';

  return (
    <View className="flex-1 bg-background-light dark:bg-background-dark">
      {/* Header */}
      <View
        className="flex-row items-center px-4 pt-14 pb-3 bg-surface-light dark:bg-surface-dark"
        style={{ borderBottomWidth: 0.5, borderBottomColor: AppColors.textSecondary.light + '33' }}
      >
        <Pressable onPress={() => router.back()} hitSlop={8} accessibilityRole="button" accessibilityLabel="Back">
          <Ionicons name="chevron-back" size={24} color={AppColors.primary} />
        </Pressable>

        <Text
          className="flex-1 text-base font-semibold text-text-primary-light dark:text-text-primary-dark mx-2"
          numberOfLines={1}
        >
          {displayName}
        </Text>

        <View className="flex-row items-center gap-x-3">
          <Pressable
            onPress={() => router.push(`/child/${id}/edit`)}
            hitSlop={8}
            accessibilityRole="button"
            accessibilityLabel="Edit profile"
          >
            <Ionicons name="pencil" size={20} color={AppColors.primary} />
          </Pressable>
          <Pressable
            onPress={handleShare}
            hitSlop={8}
            accessibilityRole="button"
            accessibilityLabel="Share results"
          >
            <Ionicons name="share-outline" size={22} color={AppColors.primary} />
          </Pressable>
        </View>
      </View>

      {recommendation ? (
        <ResultsContent recommendation={recommendation} showSaveButton={false} />
      ) : (
        <View className="flex-1 items-center justify-center">
          <ActivityIndicator size="large" color={AppColors.primary} />
        </View>
      )}
    </View>
  );
}
