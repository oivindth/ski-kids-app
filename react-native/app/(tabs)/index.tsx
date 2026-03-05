import React from 'react';
import {
  View,
  Text,
  FlatList,
  Pressable,
  Alert,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { router } from 'expo-router';
import { useFocusEffect } from '@react-navigation/native';
import { useChildren } from '@/src/hooks/useChildren';
import { AppColors, useThemeColors } from '@/src/theme/colors';
import { TagBadge } from '@/src/components/TagBadge';
import type { Child } from '@/src/models/types';
import { SkiType } from '@/src/models/types';
import { useAppSettingsStore } from '@/src/stores/app-settings-store';

const ABILITY_COLORS: Record<string, string> = {
  Beginner: AppColors.secondary,
  Intermediate: AppColors.primary,
  Advanced: AppColors.accent,
};

// Swift uses a single primary→secondary gradient for all avatars
const AVATAR_GRADIENT: [string, string] = [AppColors.primary, AppColors.secondary];

function formatLastCalculated(date: Date | null): string {
  if (!date) return 'Not yet calculated';
  const now = new Date();
  const diffMs = now.getTime() - date.getTime();
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
  if (diffDays === 0) return 'Calculated today';
  if (diffDays === 1) return 'Calculated yesterday';
  if (diffDays < 7) return `Calculated ${diffDays} days ago`;
  if (diffDays < 30) return `Calculated ${Math.floor(diffDays / 7)} week${Math.floor(diffDays / 7) > 1 ? 's' : ''} ago`;
  return `Calculated ${date.toLocaleDateString()}`;
}

interface ChildCardProps {
  child: Child;
  onPress: () => void;
  onDelete: () => void;
}

function ChildCard({ child, onPress, onDelete }: ChildCardProps) {
  const displayName = child.name.trim() || 'Child';
  const initial = displayName.charAt(0).toUpperCase();
  const abilityColor = ABILITY_COLORS[child.abilityLevel] ?? AppColors.primary;
  const colors = useThemeColors();

  function handleLongPress() {
    onDelete();
  }

  return (
    <Pressable
      onPress={onPress}
      onLongPress={handleLongPress}
      accessibilityRole="button"
      accessibilityLabel={`${displayName}, ${child.age} years old`}
      style={({ pressed }) => ({ opacity: pressed ? 0.85 : 1 })}
    >
      <View
        className="bg-surface-light dark:bg-surface-dark rounded-2xl p-4 flex-row items-center gap-x-4"
        style={{
          shadowColor: '#000',
          shadowOffset: { width: 0, height: 2 },
          shadowOpacity: 0.06,
          shadowRadius: 8,
          elevation: 3,
        }}
      >
        {/* Avatar with gradient matching Swift */}
        <LinearGradient
          colors={AVATAR_GRADIENT}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
          style={{ width: 56, height: 56, borderRadius: 28, alignItems: 'center', justifyContent: 'center' }}
        >
          <Text className="text-xl font-bold text-white">{initial}</Text>
        </LinearGradient>

        {/* Info */}
        <View className="flex-1 gap-y-1.5">
          <View className="flex-row items-center">
            <Text
              className="flex-1 text-base font-semibold text-text-primary-light dark:text-text-primary-dark"
              numberOfLines={1}
            >
              {displayName}
            </Text>
            <View className="flex-row items-center gap-x-1 ml-2">
              {child.skiTypes.includes(SkiType.Alpine) && (
                <MaterialCommunityIcons name="ski" size={14} color={AppColors.primary} />
              )}
              {child.skiTypes.includes(SkiType.XCClassic) && (
                <MaterialCommunityIcons name="ski-cross-country" size={14} color={AppColors.primary} />
              )}
              {child.skiTypes.includes(SkiType.XCSkate) && (
                <Ionicons name="fitness" size={14} color={AppColors.primary} />
              )}
            </View>
          </View>

          <View className="flex-row items-center gap-x-3 flex-wrap">
            <View className="flex-row items-center gap-x-1">
              <MaterialCommunityIcons name="cake-variant" size={14} color={colors.textSecondary} />
              <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
                {child.age} yrs
              </Text>
            </View>
            <View className="flex-row items-center gap-x-1">
              <Ionicons name="resize" size={14} color={colors.textSecondary} />
              <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
                {child.heightCm} cm
              </Text>
            </View>
            <View className="flex-row items-center gap-x-1">
              <MaterialCommunityIcons name="scale-bathroom" size={14} color={colors.textSecondary} />
              <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
                {child.weightKg} kg
              </Text>
            </View>
          </View>

          <View className="flex-row items-center justify-between">
            <TagBadge
              label={child.abilityLevel}
              color={abilityColor + '1F'}
              textColor={abilityColor}
            />
            <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
              {formatLastCalculated(child.lastCalculated)}
            </Text>
          </View>
        </View>

        <Ionicons name="chevron-forward" size={16} color={colors.textSecondary + '80'} />
      </View>
    </Pressable>
  );
}

function EmptyState() {
  return (
    <View className="flex-1 items-center justify-center px-10 gap-y-6">
      <LinearGradient
        colors={[AppColors.primary, AppColors.secondary]}
        start={{ x: 0, y: 0 }}
        end={{ x: 1, y: 1 }}
        style={{ width: 104, height: 104, borderRadius: 52, alignItems: 'center', justifyContent: 'center' }}
      >
        <MaterialCommunityIcons name="ski" size={52} color="#FFFFFF" />
      </LinearGradient>

      <View className="items-center gap-y-2">
        <Text className="text-xl font-bold text-text-primary-light dark:text-text-primary-dark text-center">
          No Profiles Yet
        </Text>
        <Text className="text-sm text-text-secondary-light dark:text-text-secondary-dark text-center">
          Add your first child to get personalized ski equipment recommendations.
        </Text>
      </View>

      <Pressable
        onPress={() => router.push('/add-child')}
        accessibilityRole="button"
        accessibilityLabel="Add Child Profile"
        style={({ pressed }) => ({ opacity: pressed ? 0.85 : 1, width: '100%' })}
        className="mt-2"
      >
        <LinearGradient
          colors={[AppColors.accent, '#E65100']}
          start={{ x: 0, y: 0.5 }}
          end={{ x: 1, y: 0.5 }}
          className="flex-row items-center justify-center gap-x-2 py-4 rounded-2xl"
          style={{
            borderRadius: 14,
            shadowColor: AppColors.accent,
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: 0.4,
            shadowRadius: 8,
            elevation: 6,
          }}
        >
          <Ionicons name="add" size={20} color="#FFFFFF" />
          <Text className="text-base font-bold text-white">Add Child Profile</Text>
        </LinearGradient>
      </Pressable>
    </View>
  );
}

export default function HomeScreen() {
  const { children, deleteChild, refreshChildren } = useChildren();
  const colors = useThemeColors();

  useFocusEffect(
    React.useCallback(() => {
      refreshChildren();
    }, [refreshChildren])
  );

  function handleDelete(child: Child) {
    Alert.alert(
      `Delete ${child.name.trim() || 'this profile'}?`,
      'This will permanently remove the profile and all saved measurements.',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => deleteChild(child.id),
        },
      ]
    );
  }

  return (
    <View className="flex-1 bg-background-light dark:bg-background-dark">
      {/* Custom header */}
      <View className="bg-surface-light dark:bg-surface-dark"
        style={{
          borderBottomWidth: 0.5,
          borderBottomColor: colors.textSecondary + '33',
        }}
      >
        {/* Icon row */}
        <View className="flex-row items-center justify-between px-4 pt-16 pb-1">
          <Pressable
            onPress={() => router.push('/settings')}
            hitSlop={8}
            accessibilityRole="button"
            accessibilityLabel="Settings"
          >
            <View
              className="items-center justify-center rounded-full"
              style={{ width: 36, height: 36, backgroundColor: 'rgba(0,0,0,0.06)' }}
            >
              <Ionicons name="settings-outline" size={20} color={colors.textSecondary} />
            </View>
          </Pressable>

          <Pressable
            onPress={() => router.push('/add-child')}
            hitSlop={8}
            accessibilityRole="button"
            accessibilityLabel="Add child"
          >
            <Ionicons name="add-circle" size={28} color={AppColors.accent} />
          </Pressable>
        </View>

        {/* Large title */}
        <View className="px-4 pt-1 pb-3">
          <Text className="text-3xl font-bold text-text-primary-light dark:text-text-primary-dark">
            My Kids
          </Text>
        </View>
      </View>

      {children.length === 0 ? (
        <EmptyState />
      ) : (
        <FlatList
          data={children}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <ChildCard
              child={item}
              onPress={() => router.push(`/child/${item.id}`)}
              onDelete={() => handleDelete(item)}
            />
          )}
          contentContainerStyle={{ padding: 16, gap: 12 }}
          showsVerticalScrollIndicator={false}
        />
      )}
    </View>
  );
}
