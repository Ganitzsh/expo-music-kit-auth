import ExpoModulesCore
import MusicKit
import StoreKit

struct MusicStorefront: Decodable {
  let id: String
}

@available(iOS 15.0, *)
public class ExpoMusicKitAuthModule: Module {
  public func getUserStorefrontId() async throws -> String {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.music.apple.com"
    urlComponents.path = "/v1/me/storefront"

    guard let url = urlComponents.url else {
      throw Exception(
        name: "API_ERROR",
        description:
          "Could not build the URL to retrieve user's storefront ID",
        code: "E_CANNOT_BUILD_STOREFRONT_URL"
      )
    }

    do {
      let request = MusicDataRequest(urlRequest: URLRequest(url: url))
      let response = try await request.response()

      let storefronts = try JSONDecoder().decode(
        [MusicStorefront].self, from: response.data)

      if let storefront = storefronts.first {
        return storefront.id
      } else {
        let exception = Exception(
          name: "API_ERROR",
          description: "Could not retrieve user's storefront ID",
          code: "E_CANNOT_RETRIEVE_STOREFRONT_ID"
        )

        throw exception
      }
    } catch {
      let exception = Exception(
        name: "API_ERROR",
        description: "Error retrieving user's storefront ID: \(error.localizedDescription)",
        code: "E_CANNOT_GET_STOREFRONT_ID"
      )

      throw exception
    }
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
        let storefrontId = try await self.getUserStorefrontId()
        let defaultTokenProvider = DefaultMusicTokenProvider.init()
        let developerToken = try await defaultTokenProvider.developerToken(
          options: MusicTokenRequestOptions())
        let musicUserTokenProvider = MusicUserTokenProvider()
        let userToken = try await musicUserTokenProvider.userToken(
          for: developerToken, options: MusicTokenRequestOptions())

        let tokens: [String: String] = [
          "developerToken": developerToken,
          "userToken": userToken,
          "storefrontId": storefrontId,
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

    AsyncFunction("getStorefrontId") { () in
      do {
        let storefrontId = try await self.getUserStorefrontId()

        return storefrontId
      } catch {
        let exception = Exception(
          name: "API_ERROR",
          description: "Error retrieving user's storefront ID: \(error.localizedDescription)",
          code: "E_CANNOT_GET_STOREFRONT_ID"
        )

        throw exception
      }
    }
  }
}
