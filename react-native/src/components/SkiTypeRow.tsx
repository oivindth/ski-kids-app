import React from 'react';
import { View, Text, Pressable } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';
import { SkiType } from '../models/types';
import { AppColors } from '../theme/colors';
import { IconDef } from '../theme/icons';

const SKI_TYPE_ICONS: Record<SkiType, IconDef> = {
  [SkiType.Alpine]: { family: 'material', name: 'ski' },
  [SkiType.XCClassic]: { family: 'material', name: 'ski-cross-country' },
  [SkiType.XCSkate]: { family: 'ionicons', name: 'fitness' },
};

interface SkiTypeRowProps {
  type: SkiType;
  selected: boolean;
  onToggle: () => void;
}

export function SkiTypeRow({ type, selected, onToggle }: SkiTypeRowProps) {
  const icon = SKI_TYPE_ICONS[type];

  return (
    <Pressable
      onPress={onToggle}
      accessibilityRole="checkbox"
      accessibilityState={{ checked: selected }}
      accessibilityLabel={type}
      accessibilityHint={selected ? 'Selected. Tap to deselect.' : 'Tap to select.'}
      className="flex-row items-center gap-x-3 px-1 py-1.5 min-h-[44px]"
    >
      <Ionicons
        name={selected ? 'checkbox' : 'square-outline'}
        size={22}
        color={selected ? AppColors.primary : AppColors.textSecondary.light + '66'}
      />

      {icon.family === 'ionicons' ? (
        <Ionicons name={icon.name} size={18} color={AppColors.secondary} style={{ width: 24 }} />
      ) : (
        <MaterialCommunityIcons name={icon.name} size={18} color={AppColors.secondary} style={{ width: 24 }} />
      )}

      <Text
        className="text-base flex-1"
        style={{
          fontWeight: selected ? '600' : '400',
          color: selected ? AppColors.primary : undefined,
        }}
      >
        {type}
      </Text>
    </Pressable>
  );
}
