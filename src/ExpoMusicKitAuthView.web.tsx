import * as React from 'react';

import { ExpoMusicKitAuthViewProps } from './ExpoMusicKitAuth.types';

export default function ExpoMusicKitAuthView(props: ExpoMusicKitAuthViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
