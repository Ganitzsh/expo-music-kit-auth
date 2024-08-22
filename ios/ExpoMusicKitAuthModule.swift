import CloudKit
import ExpoModulesCore
import MusicKit

struct MusicStorefront: Decodable {
  let id: String
}

@available(iOS 15.0, *)
public class ExpoMusicKitAuthModule: Module {
  public func getRecordId() async throws -> String {
    let container = CKContainer.default()
    let recordId = try await container.userRecordID()

    return recordId.recordName
  }

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
          options: MusicTokenRequestOptions.init())
        let musicUserTokenProvider = MusicUserTokenProvider.init()
        let userToken = try await musicUserTokenProvider.userToken(
          for: developerToken, options: MusicTokenRequestOptions.init())

        let tokens: [String: String] = [
          "developerToken": developerToken,
          "userToken": userToken,
        ]

        return tokens
      } catch {
        let exception = Exception(
          name: "AUTH_ERROR",
          description: "Error retrieving tokens: \(error.localizedDescription)",
          code: "E_CANNOT_GET_TOKENS"
        )

        throw exception
      }
    }

    AsyncFunction("getUserRecordId") { () in
      do {
        let recordId = try await self.getRecordId()

        return recordId
      } catch {
        let exception = Exception(
          name: "API_ERROR",
          description: "Error retrieving user's record id: \(error.localizedDescription)",
          code: "E_CANNOT_GET_USER_RECORD_ID"
        )

        throw exception
      }
    }
  }
}
