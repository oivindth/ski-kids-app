import React from 'react';
import { Pressable, Text, View } from 'react-native';
import { router } from 'expo-router';
import Ionicons from '@expo/vector-icons/Ionicons';
import {
  AppearanceMode,
  useAppSettingsStore,
} from '@/src/stores/app-settings-store';
import { AppColors, useThemeColors } from '@/src/theme/colors';

interface AppearanceOption {
  mode: AppearanceMode;
  label: string;
  icon: 'phone-portrait' | 'sunny' | 'moon';
}

const OPTIONS: AppearanceOption[] = [
  { mode: 'system', label: 'System', icon: 'phone-portrait' },
  { mode: 'light', label: 'Light', icon: 'sunny' },
  { mode: 'dark', label: 'Dark', icon: 'moon' },
];

export default function SettingsScreen() {
  const appearanceMode = useAppSettingsStore((s) => s.appearanceMode);
  const setAppearanceMode = useAppSettingsStore((s) => s.setAppearanceMode);
  const colors = useThemeColors();

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
          Appearance
        </Text>
        <Pressable
          onPress={() => router.back()}
          accessibilityRole="button"
          accessibilityLabel="Done"
          className="px-2 py-1"
        >
          <Text
            className="text-base font-semibold"
            style={{ color: AppColors.primary }}
          >
            Done
          </Text>
        </Pressable>
      </View>

      <View className="px-4 pt-5">
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
          {OPTIONS.map((option, index) => {
            const isSelected = appearanceMode === option.mode;
            const isLast = index === OPTIONS.length - 1;

            return (
              <React.Fragment key={option.mode}>
                <Pressable
                  onPress={() => setAppearanceMode(option.mode)}
                  accessibilityRole="radio"
                  accessibilityState={{ selected: isSelected }}
                  accessibilityLabel={option.label}
                  className="flex-row items-center px-4 py-3 gap-x-3"
                >
                  <Ionicons
                    name={option.icon}
                    size={20}
                    color={isSelected ? AppColors.primary : colors.textSecondary}
                  />
                  <Text
                    className="flex-1 text-base"
                    style={{
                      color: isSelected ? AppColors.primary : colors.textPrimary,
                      fontWeight: isSelected ? '600' : '400',
                    }}
                  >
                    {option.label}
                  </Text>
                  {isSelected && (
                    <Ionicons
                      name="checkmark"
                      size={18}
                      color={AppColors.primary}
                    />
                  )}
                </Pressable>
                {!isLast && (
                  <View
                    className="mx-4"
                    style={{ height: 1, backgroundColor: 'rgba(0,0,0,0.06)' }}
                  />
                )}
              </React.Fragment>
            );
          })}
        </View>
      </View>
    </View>
  );
}
