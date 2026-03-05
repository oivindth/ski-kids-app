import React, { useCallback, useRef } from 'react';
import {
  KeyboardAvoidingView,
  Platform,
  Pressable,
  ScrollView,
  Text,
  View,
} from 'react-native';
import { router } from 'expo-router';
import { useFocusEffect } from '@react-navigation/native';
import { LinearGradient } from 'expo-linear-gradient';
import Ionicons from '@expo/vector-icons/Ionicons';
import { useCalculatorStore } from '@/src/stores/calculator-store';
import {
  AbilityFormSection,
  BSLFormSection,
  MeasurementsFormSection,
  SkiTypeFormSection,
} from '@/src/components/FormSections';
import { AppColors } from '@/src/theme/colors';

export default function QuickCalcScreen() {
  const store = useCalculatorStore();
  const hasReset = useRef(false);

  // Reset on first focus only (not when returning from results)
  useFocusEffect(
    useCallback(() => {
      if (!hasReset.current) {
        store.reset();
        hasReset.current = true;
      }
    }, [])
  );

  function handleCalculate() {
    const success = store.calculate();
    if (success) {
      router.push('/results');
    }
  }

  const showErrors = store.hasAttemptedCalculation;

  return (
    <KeyboardAvoidingView
      className="flex-1"
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <View className="flex-1 bg-background-light dark:bg-background-dark">
        {/* Custom header */}
        <View
          className="bg-surface-light dark:bg-surface-dark"
          style={{
            borderBottomWidth: 0.5,
            borderBottomColor: 'rgba(0,0,0,0.1)',
          }}
        >
          <View className="flex-row items-center justify-between px-4 pt-16 pb-1">
            <View style={{ width: 36 }} />
            <Pressable
              onPress={() => store.reset()}
              accessibilityRole="button"
              accessibilityLabel="Reset"
              className="px-2 py-1"
            >
              <Text className="text-base text-text-secondary-light dark:text-text-secondary-dark">
                Reset
              </Text>
            </Pressable>
          </View>
          <View className="px-4 pt-1 pb-3">
            <Text className="text-3xl font-bold text-text-primary-light dark:text-text-primary-dark">
              Quick Calc
            </Text>
          </View>
        </View>

        <ScrollView
          contentContainerStyle={{ padding: 16, paddingBottom: 40 }}
          showsVerticalScrollIndicator={false}
          keyboardShouldPersistTaps="handled"
        >
          <View className="gap-y-5">
            {/* Info header matching Swift's card-like style */}
            <View
              className="flex-row items-center gap-x-3 rounded-xl p-3.5"
              style={{ backgroundColor: AppColors.primary + '0F' }}
            >
              <Ionicons name="flash" size={22} color={AppColors.accent} />
              <View className="flex-1">
                <Text className="text-sm font-semibold text-text-primary-light dark:text-text-primary-dark">
                  Instant Recommendation
                </Text>
                <Text className="text-xs text-text-secondary-light dark:text-text-secondary-dark">
                  Results are not saved. Use 'My Kids' to save profiles.
                </Text>
              </View>
            </View>

            <MeasurementsFormSection
              heightCm={store.heightCm}
              weightKg={store.weightKg}
              age={store.age}
              onHeightChange={store.setHeightCm}
              onWeightChange={store.setWeightKg}
              onAgeChange={store.setAge}
              heightError={showErrors ? store.getHeightError() ?? undefined : undefined}
              weightError={showErrors ? store.getWeightError() ?? undefined : undefined}
              ageError={showErrors ? store.getAgeError() ?? undefined : undefined}
            />

            <AbilityFormSection
              selectedLevel={store.abilityLevel}
              onSelect={store.setAbilityLevel}
            />

            <SkiTypeFormSection
              selectedTypes={store.selectedSkiTypes}
              onToggle={store.toggleSkiType}
              skiTypeError={showErrors ? store.getSkiTypeError() ?? undefined : undefined}
            />

            <BSLFormSection
              bslInputMode={store.bslInputMode}
              bslMm={store.bslMm}
              shoeSize={store.shoeSize}
              onBslInputModeChange={store.setBslInputMode}
              onBslMmChange={store.setBslMm}
              onShoeSizeChange={store.setShoeSize}
              bslError={showErrors ? store.getBslError() ?? undefined : undefined}
            />

            <Pressable
              onPress={handleCalculate}
              accessibilityRole="button"
              accessibilityLabel="Get Recommendations"
              style={({ pressed }) => ({ opacity: pressed ? 0.85 : 1, marginTop: 4 })}
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
                <Ionicons name="flash" size={20} color="#FFFFFF" />
                <Text className="text-base font-bold text-white">
                  Get Recommendations
                </Text>
              </LinearGradient>
            </Pressable>
          </View>
        </ScrollView>
      </View>
    </KeyboardAvoidingView>
  );
}
