import ExpoModulesCore
import MusicKit

@available(iOS 15.0, *)
public class ExpoMusicKitAuthModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoMusicKitAuth")

    AsyncFunction("requestAuthorization") { () in
      let status = await MusicAuthorization.request()

      print("MusicKit authorization status: \(status)")

      switch status {
      case .authorized:
        return "authorized"
      case .denied:
        return "denied"
      case .notDetermined:
        return "notDetermined"
      case .restricted:
        return "restricted"
      @unknown default:
        return "unknown"
      }
    }

    AsyncFunction("getTokens") { () in
      do {
        let defaultTokenProvider = DefaultMusicTokenProvider.init()
        let developerToken = try await defaultTokenProvider.developerToken(
          options: MusicTokenRequestOptions())
        let musicUserTokenProvider = MusicUserTokenProvider()
        let userToken = try await musicUserTokenProvider.userToken(
          for: developerToken, options: MusicTokenRequestOptions())

        let tokens: [String: String] = [
          "developerToken": developerToken,
          "userToken": userToken,
        ]

        return tokens
      } catch {
        let exception = Exception(
          name: "AUTH_ERROR",
          description: "Error retrieving user token: \(error.localizedDescription)",
          code: "E_CANNOT_GET_USER_TOKEN"
        )

        throw exception
      }
    }
  }
}
