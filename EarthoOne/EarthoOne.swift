import Foundation

/**
 `Result` wrapper for Authentication API operations.
 */
public typealias AuthenticationResult<T> = Result<T, AuthenticationError>

/**
 `Result` wrapper for Management API operations.
 */
public typealias ManagementResult<T> = Result<T, ManagementError>

#if WEB_AUTH_PLATFORM
/**
 `Result` wrapper for Web Auth operations.
 */
public typealias WebAuthResult<T> = Result<T, WebAuthError>
#endif

/**
 `Result` wrapper for Credentials Manager operations.
 */
public typealias CredentialsManagerResult<T> = Result<T, CredentialsManagerError>

public let defaultScope = "email"


public class EarthoOne {
    public let defaultDomain = "https://one.eartho.world/"
    public let defaultAuthDomain = "https://api.eartho.world/"

    private let clientId : String
    private let clientSecret : String

    private let credentialsManager : CredentialsManager
    
    public init(clientId : String, clientSecret : String) {
        self.clientId = clientId;
        self.clientSecret = clientSecret;
        
        let auth = EarthoOneAuthentication(clientId: clientId, clientSecret: clientSecret, url: .httpsURL(from: defaultAuthDomain), session: .shared);
        self.credentialsManager = CredentialsManager(authentication: auth);
    }
    
    public func connectWithPopup(accessId : String, onSuccess: ((Credentials) -> Void)? = nil, onFailure: ((WebAuthError?) -> Void)? = nil){
        let onAuth:((WebAuthResult<Credentials>) -> ())! = {
                    switch $0 {
                    case .failure(let error):
                        print(error.cause)
                        onFailure?(error)
                    case .success(let credentials):
                        self.credentialsManager.store(credentials: credentials)
                        onSuccess?(credentials)
                    }
                    print($0)
                }
        EarthoOneWebAuth(clientId: clientId, clientSecret: clientSecret, url: .httpsURL(from: defaultDomain), session: .shared)
            .accessId(accessId)
            .start(onAuth)
    }
    
    public func logout() {
        credentialsManager.clear()
    }
    
    public func getIdToken() -> String? {
        return credentialsManager.retrieveCredentials()?.idToken;
    }
    
    public func getUser() -> UserInfo? {
        return credentialsManager.user;
    }
    
}
