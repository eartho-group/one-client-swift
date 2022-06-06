// swiftlint:disable file_length
// swiftlint:disable function_parameter_count

import Foundation

/// A newly created database user (just the email, username, and email verified flag).
public typealias DatabaseUser = (email: String, username: String?, verified: Bool)

/**
 Client for the [EarthoOne Authentication API](https://eartho.com/docs/api/authentication).

 - See: ``AuthenticationError``
 - See: [Standard Error Responses](https://eartho.com/docs/api/authentication#standard-error-responses)
 */
public protocol Authentication: Trackable, Loggable {

    /// The EarthoOne Client ID.
    var clientId: String { get }
    var clientSecret: String { get }
/// The EarthoOne Domain URL.
    var url: URL { get }

    // MARK: - Methods


    /**
     Returns OIDC standard claims information by performing a request to the `/userinfo` endpoint.

     ```
     EarthoOne
         .authentication(clientId, domain: "samples.eartho.com")
         .userInfo(withAccessToken: credentials.accessToken)
         .start { result in
             switch result {
             case .success(let user):
                 print("Obtained user: \(user)")
             case .failure(let error):
                 print("Failed with: \(error)")
             }
         }
     ```

     - Parameter accessToken: Access token obtained by authenticating the user.
     - Returns: A request that will yield user information.
     - See: [Authentication API Endpoint](https://eartho.com/docs/api/authentication#get-user-info)
     */
    func userInfo(withAccessToken accessToken: String) -> Request<UserInfo, AuthenticationError>

    /**
     Performs the last step of Proof Key for Code Exchange (PKCE).
     This will request the user's token using the code and its verifier after a request to `/oauth/authorize`.

     ```
     EarthoOne
         .authentication(clientId: clientId, domain: "samples.eartho.com")
         .codeExchange(withCode: "code",
                       codeVerifier: "code verifier",
                       redirectURI: "https://samples.eartho.com/callback")
         .start { result in
             switch result {
             case .success(let credentials):
                 print("Obtained credentials: \(credentials)")
             case .failure(let error):
                 print("Failed with: \(error)")
             }
         }
     ```

     - Parameters:
       - code:         Code returned after a request to `/oauth/authorize`.
       - codeVerifier: Verifier used to generate the challenge sent in the request to `/oauth/authorize`.
       - redirectURI:  Redirect URI sent in the request to `/oauth/authorize`.
     - Returns: A request that will yield EarthoOne user's credentials.
     - See: [Authentication API Endpoint](https://eartho.com/docs/api/authentication#authorization-code-flow-with-pkce45)
     - See: [RFC 7636](https://tools.ietf.org/html/rfc7636)
     */
    func codeExchange(withCode code: String, codeVerifier: String, redirectURI: String, accessId: String) -> Request<Credentials, AuthenticationError>

    /**
     Renews the user's credentials using a refresh token.

     ```
     EarthoOne
         .renew(withRefreshToken: credentials.refreshToken)
         .start { result in
             switch result {
             case .success(let credentials):
                 print("Obtained new credentials: \(credentials)")
             case .failure(let error):
                 print("Failed with: \(error)")
             }
         }
     ```

     You can get a downscoped access token by requesting fewer scopes than were requested on login:

     ```
     EarthoOne
         .renew(withRefreshToken: credentials.refreshToken,
                scope: "openid offline_access")
         .start { print($0) }
     ```

     - Parameters:
       - refreshToken: The refresh token.
       - scope:        Space-separated list of scope values to request. Defaults to `nil`, which will ask for the same scopes that were requested on login.
     - Returns: A request that will yield EarthoOne user's credentials.
     - See: [Authentication API Endpoint](https://eartho.com/docs/api/authentication#refresh-token)
     */
    func renew(withRefreshToken refreshToken: String, scope: String?) -> Request<Credentials, AuthenticationError>

    /**
     Revokes a user's refresh token by performing a request to the `/oauth/revoke` endpoint.

     ```
     EarthoOne
         .authentication(clientId: clientId, domain: "samples.eartho.com")
         .revoke(refreshToken: credentials.refreshToken)
         .start { print($0) }
     ```

     - Parameter refreshToken: The refresh token to revoke.
     - Returns: A request for revoking the refresh token.
     - See: [Authentication API Endpoint](https://eartho.com/docs/api/authentication#revoke-refresh-token)
     - See: [Error Responses](https://eartho.com/docs/api/authentication#post-oauth-revoke)
     */
    func revoke(refreshToken: String) -> Request<Void, AuthenticationError>

}

public extension Authentication {

    func login(email: String, code: String, audience: String? = nil, scope: String = defaultScope) -> Request<Credentials, AuthenticationError> {
        return self.login(email: email, code: code, audience: audience, scope: scope)
    }

    func login(phoneNumber: String, code: String, audience: String? = nil, scope: String = defaultScope) -> Request<Credentials, AuthenticationError> {
        return self.login(phoneNumber: phoneNumber, code: code, audience: audience, scope: scope)
    }

    func login(usernameOrEmail username: String, password: String, realmOrConnection realm: String, audience: String? = nil, scope: String = defaultScope) -> Request<Credentials, AuthenticationError> {
        return self.login(usernameOrEmail: username, password: password, realmOrConnection: realm, audience: audience, scope: scope)
    }

    func login(withOOBCode oobCode: String, mfaToken: String, bindingCode: String? = nil) -> Request<Credentials, AuthenticationError> {
        return self.login(withOOBCode: oobCode, mfaToken: mfaToken, bindingCode: bindingCode)
    }

    func multifactorChallenge(mfaToken: String, types: [String]? = nil, authenticatorId: String? = nil) -> Request<Challenge, AuthenticationError> {
        return self.multifactorChallenge(mfaToken: mfaToken, types: types, authenticatorId: authenticatorId)
    }

    func login(appleAuthorizationCode authorizationCode: String, fullName: PersonNameComponents? = nil, profile: [String: Any]? = nil, audience: String? = nil, scope: String = defaultScope) -> Request<Credentials, AuthenticationError> {
        return self.login(appleAuthorizationCode: authorizationCode, fullName: fullName, profile: profile, audience: audience, scope: scope)
    }

    func login(facebookSessionAccessToken sessionAccessToken: String, profile: [String: Any], audience: String? = nil, scope: String = defaultScope) -> Request<Credentials, AuthenticationError> {
        return self.login(facebookSessionAccessToken: sessionAccessToken, profile: profile, audience: audience, scope: scope)
    }

    func loginDefaultDirectory(withUsername username: String, password: String, audience: String? = nil, scope: String = defaultScope) -> Request<Credentials, AuthenticationError> {
        return self.loginDefaultDirectory(withUsername: username, password: password, audience: audience, scope: scope)
    }

    func signup(email: String, username: String? = nil, password: String, connection: String, userMetadata: [String: Any]? = nil, rootAttributes: [String: Any]? = nil) -> Request<DatabaseUser, AuthenticationError> {
        return self.signup(email: email, username: username, password: password, connection: connection, userMetadata: userMetadata, rootAttributes: rootAttributes)
    }

    func startPasswordless(email: String, type: PasswordlessType = .code, connection: String = "email") -> Request<Void, AuthenticationError> {
        return self.startPasswordless(email: email, type: type, connection: connection)
    }

    func startPasswordless(phoneNumber: String, type: PasswordlessType = .code, connection: String = "sms") -> Request<Void, AuthenticationError> {
        return self.startPasswordless(phoneNumber: phoneNumber, type: type, connection: connection)
    }

    func renew(withRefreshToken refreshToken: String, scope: String? = nil) -> Request<Credentials, AuthenticationError> {
        return self.renew(withRefreshToken: refreshToken, scope: scope)
    }

}
