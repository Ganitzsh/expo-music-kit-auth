import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoMusicKitAuthViewProps } from './ExpoMusicKitAuth.types';

const NativeView: React.ComponentType<ExpoMusicKitAuthViewProps> =
  requireNativeViewManager('ExpoMusicKitAuth');

export default function ExpoMusicKitAuthView(props: ExpoMusicKitAuthViewProps) {
  return <NativeView {...props} />;
}
