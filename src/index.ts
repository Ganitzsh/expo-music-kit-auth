import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoMusicKitAuth.web.ts
// and on native platforms to ExpoMusicKitAuth.ts
import ExpoMusicKitAuthModule from './ExpoMusicKitAuthModule';
import ExpoMusicKitAuthView from './ExpoMusicKitAuthView';
import { ChangeEventPayload, ExpoMusicKitAuthViewProps } from './ExpoMusicKitAuth.types';

// Get the native constant value.
export const PI = ExpoMusicKitAuthModule.PI;

export function hello(): string {
  return ExpoMusicKitAuthModule.hello();
}

export async function setValueAsync(value: string) {
  return await ExpoMusicKitAuthModule.setValueAsync(value);
}

const emitter = new EventEmitter(ExpoMusicKitAuthModule ?? NativeModulesProxy.ExpoMusicKitAuth);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ExpoMusicKitAuthView, ExpoMusicKitAuthViewProps, ChangeEventPayload };
