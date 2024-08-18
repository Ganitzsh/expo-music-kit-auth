import { StyleSheet, Text, View } from 'react-native';

import * as ExpoMusicKitAuth from 'expo-music-kit-auth';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{ExpoMusicKitAuth.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
