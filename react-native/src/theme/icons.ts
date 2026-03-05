import { ComponentProps } from 'react';
import Ionicons from '@expo/vector-icons/Ionicons';
import MaterialCommunityIcons from '@expo/vector-icons/MaterialCommunityIcons';

type IoniconsName = ComponentProps<typeof Ionicons>['name'];
type MaterialName = ComponentProps<typeof MaterialCommunityIcons>['name'];

export type IconDef =
  | { family: 'ionicons'; name: IoniconsName }
  | { family: 'material'; name: MaterialName };

export const AppIcons = {
  skiAlpine: { family: 'material', name: 'ski' } as IconDef,
  skiCrossCountry: { family: 'material', name: 'ski-cross-country' } as IconDef,
  skiSkate: { family: 'ionicons', name: 'fitness' } as IconDef,
  ruler: { family: 'ionicons', name: 'resize' } as IconDef,
  scale: { family: 'material', name: 'scale-bathroom' } as IconDef,
  birthday: { family: 'material', name: 'cake-variant' } as IconDef,
  shield: { family: 'material', name: 'shield-alert' } as IconDef,
  bolt: { family: 'ionicons', name: 'flash' } as IconDef,
  settings: { family: 'ionicons', name: 'settings' } as IconDef,
  addCircle: { family: 'ionicons', name: 'add-circle' } as IconDef,
  store: { family: 'material', name: 'store' } as IconDef,
  people: { family: 'ionicons', name: 'people' } as IconDef,
  info: { family: 'ionicons', name: 'information-circle' } as IconDef,
  share: { family: 'ionicons', name: 'share-outline' } as IconDef,
  pencil: { family: 'ionicons', name: 'pencil' } as IconDef,
  trash: { family: 'ionicons', name: 'trash-outline' } as IconDef,
  chevronDown: { family: 'ionicons', name: 'chevron-down' } as IconDef,
  chevronUp: { family: 'ionicons', name: 'chevron-up' } as IconDef,
  checkmark: { family: 'ionicons', name: 'checkmark' } as IconDef,
  close: { family: 'ionicons', name: 'close' } as IconDef,
  helmet: { family: 'material', name: 'hard-hat' } as IconDef,
  boot: { family: 'material', name: 'shoe-formal' } as IconDef,
  pole: { family: 'material', name: 'arrow-expand-vertical' } as IconDef,
  speedometer: { family: 'material', name: 'speedometer' } as IconDef,
  sun: { family: 'ionicons', name: 'sunny' } as IconDef,
  moon: { family: 'ionicons', name: 'moon' } as IconDef,
  phone: { family: 'ionicons', name: 'phone-portrait' } as IconDef,
} as const;
