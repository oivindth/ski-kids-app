import React from 'react';
import { View, Text, TextInput, ScrollView, Pressable } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import Ionicons from '@expo/vector-icons/Ionicons';
import { useCalculatorStore } from '../stores/calculator-store';
import { AppColors, useThemeColors } from '../theme/colors';
import { AppIcons } from '../theme/icons';
import { FormCard } from './FormCard';
import {
  MeasurementsFormSection,
  AbilityFormSection,
  SkiTypeFormSection,
  BSLFormSection,
} from './FormSections';

interface CalculatorFormProps {
  showCalculateButton?: boolean;
  onCalculate?: () => void;
}

export function CalculatorForm({ showCalculateButton = false, onCalculate }: CalculatorFormProps) {
  const store = useCalculatorStore();
  const colors = useThemeColors();

  function handleCalculate() {
    const success = store.calculate();
    if (success && onCalculate) {
      onCalculate();
    }
  }

  const attempted = store.hasAttemptedCalculation;

  return (
    <ScrollView
      className="flex-1 bg-background-light dark:bg-background-dark"
      contentContainerStyle={{ paddingHorizontal: 16, paddingTop: 12, paddingBottom: 40 }}
      keyboardShouldPersistTaps="handled"
    >
      <View className="gap-y-5">
        <FormCard title="Child Name" icon={AppIcons.people} iconColor={AppColors.primary}>
          <TextInput
            value={store.name}
            onChangeText={store.setName}
            placeholder="Name (optional)"
            placeholderTextColor={colors.textSecondary}
            className="text-base text-text-primary-light dark:text-text-primary-dark px-1"
            maxLength={50}
            returnKeyType="done"
          />
        </FormCard>

        <MeasurementsFormSection
          heightCm={store.heightCm}
          weightKg={store.weightKg}
          age={store.age}
          onHeightChange={store.setHeightCm}
          onWeightChange={store.setWeightKg}
          onAgeChange={store.setAge}
          heightError={attempted ? store.getHeightError() ?? undefined : undefined}
          weightError={attempted ? store.getWeightError() ?? undefined : undefined}
          ageError={attempted ? store.getAgeError() ?? undefined : undefined}
        />

        <AbilityFormSection
          selectedLevel={store.abilityLevel}
          onSelect={store.setAbilityLevel}
        />

        <SkiTypeFormSection
          selectedTypes={store.selectedSkiTypes}
          onToggle={store.toggleSkiType}
          skiTypeError={attempted ? store.getSkiTypeError() ?? undefined : undefined}
        />

        <BSLFormSection
          bslInputMode={store.bslInputMode}
          bslMm={store.bslMm}
          shoeSize={store.shoeSize}
          onBslInputModeChange={store.setBslInputMode}
          onBslMmChange={store.setBslMm}
          onShoeSizeChange={store.setShoeSize}
          bslError={attempted ? store.getBslError() ?? undefined : undefined}
        />

        {showCalculateButton && (
          <Pressable
            onPress={handleCalculate}
            accessibilityRole="button"
            accessibilityLabel="Calculate Recommendations"
            style={({ pressed }) => ({ opacity: pressed ? 0.85 : 1 })}
          >
            <LinearGradient
              colors={[AppColors.accent, '#E65100']}
              start={{ x: 0, y: 0.5 }}
              end={{ x: 1, y: 0.5 }}
              style={{
                borderRadius: 16,
                flexDirection: 'row',
                alignItems: 'center',
                justifyContent: 'center',
                gap: 8,
                paddingVertical: 18,
                shadowColor: AppColors.accent,
                shadowOffset: { width: 0, height: 4 },
                shadowOpacity: 0.4,
                shadowRadius: 8,
                elevation: 6,
              }}
            >
              <Ionicons name="sparkles" size={20} color="#FFFFFF" />
              <Text className="text-base font-bold text-white">Calculate Recommendations</Text>
            </LinearGradient>
          </Pressable>
        )}
      </View>
    </ScrollView>
  );
}
