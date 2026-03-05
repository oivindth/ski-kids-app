import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

export type AppearanceMode = 'system' | 'light' | 'dark';

interface AppSettingsState {
  appearanceMode: AppearanceMode;
  hasSeenOnboarding: boolean;
  checklist: Record<string, boolean>;

  setAppearanceMode: (mode: AppearanceMode) => void;
  setHasSeenOnboarding: (value: boolean) => void;
  toggleChecklistItem: (key: string) => void;
  resetChecklist: () => void;
}

const CHECKLIST_KEYS = [
  'helmet',
  'goggles',
  'gloves',
  'jacket',
  'pants',
  'socks',
  'sunscreen',
  'snacks',
] as const;

const defaultChecklist: Record<string, boolean> = {};
for (const key of CHECKLIST_KEYS) {
  defaultChecklist[key] = false;
}

export const useAppSettingsStore = create<AppSettingsState>()(
  persist(
    (set) => ({
      appearanceMode: 'system',
      hasSeenOnboarding: false,
      checklist: { ...defaultChecklist },

      setAppearanceMode: (mode) => set({ appearanceMode: mode }),

      setHasSeenOnboarding: (value) => set({ hasSeenOnboarding: value }),

      toggleChecklistItem: (key) =>
        set((state) => ({
          checklist: {
            ...state.checklist,
            [key]: !state.checklist[key],
          },
        })),

      resetChecklist: () => set({ checklist: { ...defaultChecklist } }),
    }),
    {
      name: 'app-settings',
      storage: createJSONStorage(() => AsyncStorage),
    },
  ),
);
