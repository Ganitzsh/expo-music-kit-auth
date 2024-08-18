import { AuthStatus, Tokens } from './ExpoMusicKitAuth.types';
import ExpoMusicKitAuthModule from './ExpoMusicKitAuthModule';

export async function requestAuthorization(): Promise<AuthStatus> {
  return await ExpoMusicKitAuthModule.requestAuthorization();
}

export async function getTokens(): Promise<Tokens> {
  return await ExpoMusicKitAuthModule.getTokens();
}

export { AuthStatus, Tokens };
