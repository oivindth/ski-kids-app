import React, { useEffect, useState } from 'react';
import { View, Text, Pressable, ActivityIndicator, Alert } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { router, useLocalSearchParams } from 'expo-router';
import { getChild, updateChild } from '@/src/db/child-repository';
import { useCalculatorStore } from '@/src/stores/calculator-store';
import { CalculatorForm } from '@/src/components/CalculatorForm';
import { AppColors } from '@/src/theme/colors';
import type { Child } from '@/src/models/types';
import { BSLInputMode } from '@/src/models/types';

export default function EditChildScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const [child, setChild] = useState<Child | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  const store = useCalculatorStore();

  useEffect(() => {
    if (!id) {
      setLoading(false);
      return;
    }
    const found = getChild(id);
    setChild(found);
    if (found) {
      store.populateFromChild(found);
    }
    setLoading(false);
  }, [id]);

  function handleSave() {
    if (!id || saving) return;
    setSaving(true);

    const bslInputMode = store.bslInputMode;

    updateChild(id, {
      name: store.name,
      heightCm: store.heightCm,
      weightKg: store.weightKg,
      age: store.age,
      bslMm: bslInputMode === BSLInputMode.BSL ? store.bslMm : null,
      bslInputModeRaw: bslInputMode,
      shoeSize: bslInputMode === BSLInputMode.ShoeSize ? store.shoeSize : null,
      abilityLevel: store.abilityLevel,
      skiTypes: store.selectedSkiTypes,
    });

    setSaving(false);
    router.back();
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

  const displayName = child.name.trim() || 'Edit Child';

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

        <Text
          className="flex-1 text-base font-semibold text-text-primary-light dark:text-text-primary-dark text-center"
          numberOfLines={1}
        >
          {displayName}
        </Text>

        <Pressable
          onPress={handleSave}
          disabled={saving}
          hitSlop={8}
          accessibilityRole="button"
          accessibilityLabel="Save"
        >
          <Text
            className="text-sm font-semibold"
            style={{ color: saving ? AppColors.textSecondary.light : AppColors.primary }}
          >
            {saving ? 'Saving…' : 'Save'}
          </Text>
        </Pressable>
      </View>

      <CalculatorForm showCalculateButton={false} />
    </View>
  );
}
