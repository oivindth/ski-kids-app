import React from 'react';
import { View, Text, Pressable } from 'react-native';
import Ionicons from '@expo/vector-icons/Ionicons';
import { AbilityLevel, BSLInputMode, SkiType } from '../models/types';
import { AppColors } from '../theme/colors';
import { AppIcons } from '../theme/icons';
import { FormCard } from './FormCard';
import { StepperRow } from './StepperRow';
import { AbilityRow } from './AbilityRow';
import { SkiTypeRow } from './SkiTypeRow';

const ABILITY_DESCRIPTIONS: Record<AbilityLevel, string> = {
  [AbilityLevel.Beginner]: 'Just starting out, learning basic control',
  [AbilityLevel.Intermediate]: 'Comfortable on groomed runs, improving technique',
  [AbilityLevel.Advanced]: 'Confident on varied terrain, strong technique',
};

interface MeasurementsFormSectionProps {
  heightCm: number;
  weightKg: number;
  age: number;
  onHeightChange: (v: number) => void;
  onWeightChange: (v: number) => void;
  onAgeChange: (v: number) => void;
  heightError?: string;
  weightError?: string;
  ageError?: string;
}

export function MeasurementsFormSection({
  heightCm,
  weightKg,
  age,
  onHeightChange,
  onWeightChange,
  onAgeChange,
  heightError,
  weightError,
  ageError,
}: MeasurementsFormSectionProps) {
  return (
    <FormCard
      title="Measurements"
      icon={AppIcons.ruler}
      iconColor={AppColors.secondary}
    >
      <View className="gap-y-4">
        <StepperRow
          label="Height"
          value={heightCm}
          min={60}
          max={210}
          step={1}
          unit="cm"
          onChange={onHeightChange}
          error={heightError}
          icon="resize"
          iconFamily="ionicons"
          iconColor={AppColors.secondary}
        />
        <View className="h-px bg-gray-200 dark:bg-gray-700" />
        <StepperRow
          label="Weight"
          value={weightKg}
          min={8}
          max={120}
          step={1}
          unit="kg"
          onChange={onWeightChange}
          error={weightError}
          icon="scale-bathroom"
          iconFamily="material"
          iconColor={AppColors.secondary}
        />
        <View className="h-px bg-gray-200 dark:bg-gray-700" />
        <StepperRow
          label="Age"
          value={age}
          min={2}
          max={99}
          step={1}
          unit="years"
          onChange={onAgeChange}
          error={ageError}
          icon="cake-variant"
          iconFamily="material"
          iconColor={AppColors.secondary}
        />
      </View>
    </FormCard>
  );
}

interface AbilityFormSectionProps {
  selectedLevel: AbilityLevel;
  onSelect: (level: AbilityLevel) => void;
}

export function AbilityFormSection({ selectedLevel, onSelect }: AbilityFormSectionProps) {
  return (
    <FormCard
      title="Ability Level"
      icon={AppIcons.bolt}
      iconColor={AppColors.warning}
    >
      <View className="gap-y-2">
        {(Object.values(AbilityLevel) as AbilityLevel[]).map((level) => (
          <AbilityRow
            key={level}
            level={level}
            selected={selectedLevel === level}
            onSelect={() => onSelect(level)}
            description={ABILITY_DESCRIPTIONS[level]}
          />
        ))}
      </View>
    </FormCard>
  );
}

interface SkiTypeFormSectionProps {
  selectedTypes: SkiType[];
  onToggle: (type: SkiType) => void;
  skiTypeError?: string;
}

export function SkiTypeFormSection({ selectedTypes, onToggle, skiTypeError }: SkiTypeFormSectionProps) {
  return (
    <FormCard
      title="Ski Type"
      icon={AppIcons.skiAlpine}
      iconColor={AppColors.primary}
    >
      <View>
        {(Object.values(SkiType) as SkiType[]).map((type) => (
          <SkiTypeRow
            key={type}
            type={type}
            selected={selectedTypes.includes(type)}
            onToggle={() => onToggle(type)}
          />
        ))}
        {skiTypeError ? (
          <Text className="text-xs text-red-500 mt-1 ml-1">{skiTypeError}</Text>
        ) : null}
      </View>
    </FormCard>
  );
}

const BSL_MODE_LABELS: Record<BSLInputMode, string> = {
  [BSLInputMode.Estimate]: 'Estimate',
  [BSLInputMode.ShoeSize]: 'Shoe Size',
  [BSLInputMode.BSL]: 'BSL',
};

interface BSLFormSectionProps {
  bslInputMode: BSLInputMode;
  bslMm: number;
  shoeSize: number;
  onBslInputModeChange: (mode: BSLInputMode) => void;
  onBslMmChange: (v: number) => void;
  onShoeSizeChange: (v: number) => void;
  bslError?: string;
}

export function BSLFormSection({
  bslInputMode,
  bslMm,
  shoeSize,
  onBslInputModeChange,
  onBslMmChange,
  onShoeSizeChange,
  bslError,
}: BSLFormSectionProps) {
  const modes = [BSLInputMode.Estimate, BSLInputMode.ShoeSize, BSLInputMode.BSL];

  return (
    <FormCard
      title="Boot Sole Length"
      icon={AppIcons.boot}
      iconColor={AppColors.secondary}
    >
      <View className="gap-y-4">
        <View
          className="flex-row rounded-xl overflow-hidden"
          style={{ backgroundColor: AppColors.primary + '14' }}
        >
          {modes.map((mode) => {
            const active = bslInputMode === mode;
            return (
              <Pressable
                key={mode}
                onPress={() => onBslInputModeChange(mode)}
                className="flex-1 py-2 items-center justify-center rounded-xl"
                style={active ? { backgroundColor: AppColors.primary } : undefined}
                accessibilityRole="radio"
                accessibilityState={{ selected: active }}
                accessibilityLabel={BSL_MODE_LABELS[mode]}
              >
                <Text
                  className="text-sm font-semibold"
                  style={{ color: active ? '#FFFFFF' : AppColors.textSecondary.light }}
                >
                  {BSL_MODE_LABELS[mode]}
                </Text>
              </Pressable>
            );
          })}
        </View>

        {bslInputMode === BSLInputMode.BSL && (
          <View className="gap-y-2">
            <StepperRow
              label="Boot Sole Length"
              value={bslMm}
              min={150}
              max={380}
              step={5}
              unit="mm"
              onChange={onBslMmChange}
              error={bslError}
              icon="shoe-formal"
              iconFamily="material"
              iconColor={AppColors.secondary}
            />
            <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
              Found printed on the boot sole or inside the boot
            </Text>
          </View>
        )}

        {bslInputMode === BSLInputMode.ShoeSize && (
          <View className="gap-y-2">
            <StepperRow
              label="EU Shoe Size"
              value={shoeSize}
              min={15}
              max={50}
              step={1}
              unit="EU"
              onChange={onShoeSizeChange}
              icon="shoe-formal"
              iconFamily="material"
              iconColor={AppColors.secondary}
            />
            <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
              Used to estimate boot sole length
            </Text>
          </View>
        )}

        {bslInputMode === BSLInputMode.Estimate && (
          <View className="flex-row items-start gap-x-2">
            <Ionicons
              name="information-circle-outline"
              size={16}
              color={AppColors.textSecondary.light}
              style={{ marginTop: 1 }}
            />
            <Text className="flex-1 text-xs text-text-secondary-light dark:text-text-secondary-dark">
              Boot sole length will be estimated from height. For accurate DIN, provide BSL or shoe size.
            </Text>
          </View>
        )}
      </View>
    </FormCard>
  );
}
