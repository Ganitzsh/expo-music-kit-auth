export enum AuthStatus {
  Authorized = 'authorized',
  Denied = 'denied',
  NotDetermined = 'notDetermined',
  Restricted = 'restricted',
  Unknown = 'unknown',
}

export interface Tokens {
  userToken: string;
  developerToken: string;
  storefront: string;
}
