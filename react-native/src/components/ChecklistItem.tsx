import React from 'react';
import { View, Text, Pressable } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { AppColors } from '../theme/colors';
import { TagBadge } from './TagBadge';

interface ChecklistItemProps {
  label: string;
  checked: boolean;
  onToggle: () => void;
  tag?: { text: string; color: string };
}

export function ChecklistItem({ label, checked, onToggle, tag }: ChecklistItemProps) {
  return (
    <Pressable
      onPress={onToggle}
      accessibilityRole="checkbox"
      accessibilityState={{ checked }}
      accessibilityLabel={label}
      className="flex-row items-start gap-x-2.5 py-1 min-h-[44px]"
    >
      <Ionicons
        name={checked ? 'checkbox' : 'square-outline'}
        size={22}
        color={checked ? AppColors.secondary : AppColors.textSecondary.light + '66'}
        style={{ marginTop: 1 }}
      />

      <Text
        className="flex-1 text-base"
        style={{
          color: checked ? AppColors.textSecondary.light : undefined,
          textDecorationLine: checked ? 'line-through' : 'none',
        }}
      >
        {label}
      </Text>

      {tag ? (
        <TagBadge
          label={tag.text}
          color={tag.color + '1F'}
          textColor={tag.color}
        />
      ) : null}
    </Pressable>
  );
}
