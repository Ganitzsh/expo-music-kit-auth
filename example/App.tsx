import * as ExpoMusicKitAuth from 'expo-music-kit-auth';
import { useState } from 'react';
import { Button, StyleSheet, Text, View } from 'react-native';

export default function App() {
  const [tokens, setTokens] = useState<ExpoMusicKitAuth.Tokens | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [recordId, setRecordId] = useState<string | null>(null);

  const getTokens = async () => {
    if (tokens !== null) return;

    try {
      const authorizationStatus = await ExpoMusicKitAuth.requestAuthorization();
      if (authorizationStatus !== ExpoMusicKitAuth.AuthStatus.Authorized) {
        console.log('Authorization denied', authorizationStatus);

        setError('Authorization denied');
        return;
      }

      const recordId = await ExpoMusicKitAuth.getUserRecordId();
      setRecordId(recordId);

      const tokens = await ExpoMusicKitAuth.getTokens();
      setTokens(tokens);
    } catch (error) {
      console.error(error, JSON.stringify(error));

      if (error instanceof Error) {
        setError(error.message);
        return;
      }

      setError('An unknown error occurred');
    }
  };

  return (
    <View style={styles.container}>
      {error && <Text>{error}</Text>}
      {recordId && <Text>User record ID: {recordId}</Text>}
      {tokens ? (
        <Text>{JSON.stringify(tokens, null, 2)}</Text>
      ) : (
        <Button title="Get Tokens" onPress={getTokens} />
      )}
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
