import React, { useEffect } from 'react';
import { View, Text, Pressable } from 'react-native';
import { router } from 'expo-router';
import { useCalculatorStore } from '@/src/stores/calculator-store';
import { CalculatorForm } from '@/src/components/CalculatorForm';
import { AppColors } from '@/src/theme/colors';

export default function AddChildScreen() {
  const store = useCalculatorStore();

  useEffect(() => {
    store.reset();
  }, []);

  function handleCalculate() {
    // navigate to results screen where save option is shown
    router.push('/results');
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
          accessibilityLabel="Cancel"
        >
          <Text className="text-sm" style={{ color: AppColors.textSecondary.light }}>
            Cancel
          </Text>
        </Pressable>

        <Text className="flex-1 text-base font-semibold text-text-primary-light dark:text-text-primary-dark text-center">
          Add Child
        </Text>

        {/* Spacer to balance header */}
        <View style={{ width: 40 }} />
      </View>

      <CalculatorForm showCalculateButton onCalculate={handleCalculate} />
    </View>
  );
}
