// swiftlint:disable function_body_length

import Foundation

/// OIDC Standard Claims user information.
/// - See: [Claims](https://eartho.com/docs/security/tokens/json-web-tokens/json-web-token-claims)
public struct UserInfo: JSONObjectPayload {

    /// The list of public claims.
    public static let publicClaims = [
        "sub",
        "first_name",
        "family_name",
        "middle_name",
        "displayName",
        "photoURL",
        "website",
        "email",
        "email_verified",
        "gender",
        "birthdate",
        "zoneinfo",
        "locale",
        "phone_number",
        "phone_number_verified",
        "address",
        "updated_at"
    ]

    // MARK: - Claims

    /// The EarthoOne user identifier.
    public let sub: String
    /// The first name of the user.
    ///
    /// - Requires: The `profile` scope.
    public let firstName: String?
    /// The last name of the user.
    ///
    /// - Requires: The `profile` scope.
    public let familyName: String?
    /// The middle name of the user.
    ///
    /// - Requires: The `profile` scope.
    public let middleName: String?
    /// The nickname of the user.
    ///
    /// - Requires: The `profile` scope.
    public let displayName: String?
    /// The URL of the user's picture.
    ///
    /// - Requires: The `profile` scope.
    public let photoURL: URL?
    /// The URL of the user's website.
    ///
    /// - Requires: The `profile` scope.
    public let website: URL?
    /// The email of the user.
    ///
    /// - Requires: The `email` scope.
    public let email: String?
    /// If the user's email is verified.
    ///
    /// - Requires: The `email` scope.
    public let emailVerified: Bool?

    /// The gender of the user.
    ///
    /// - Requires: The `profile` scope.
    public let gender: String?
    /// The birthdate of the user.
    ///
    /// - Requires: The `profile` scope.
    public let birthdate: String?
    /// The time zone of the user.
    ///
    /// - Requires: The `profile` scope.
    public let zoneinfo: TimeZone?
    /// The locale of the user.
    ///
    /// - Requires: The `profile` scope.
    public let locale: Locale?
    /// The phone number of the user.
    ///
    /// - Requires: The `phone_number` scope.
    public let phoneNumber: String?
    /// If the user's phone number is verified.
    ///
    /// - Requires: The `phone_number` scope.
    public let phoneNumberVerified: Bool?
    /// The address of the user.
    ///
    /// - Requires: The `address` scope.
    public let address: [String: String]?
    /// The date and time the user's information was last updated.
    ///
    /// - Requires: The `profile` scope.
    public let updatedAt: Date?

    /// Any custom claims.
    public let customClaims: [String: Any]?

}

// MARK: - Initializer

public extension UserInfo {

    /// Creates a new `UserInfo` from a JSON dictionary.
    init?(json: [String: Any]) {
        guard let sub = json["sub"] as? String else { return nil }
        guard let user = json["user"] as? [String: Any] else { return nil }
        
        let firstName = user["firstName"] as? String
        let familyName = user["familyName"] as? String
        let middleName = user["middleName"] as? String
        let displayName = user["displayName"] as? String
        let preferredUsername = user["preferred_username"] as? String

        var photo: URL?
        if let photoURL = user["photoURL"] as? String { photo = URL(string: photoURL) }

        var website: URL?
        if let websiteURL = user["website"] as? String { website = URL(string: websiteURL) }

        let email = user["email"] as? String
        let emailVerified = user["emailVerified"] as? Bool

        let gender = user["gender"] as? String
        let birthdate = user["birthdate"] as? String

        var zoneinfo: TimeZone?
        if let timeZone = user["zoneinfo"] as? String { zoneinfo = TimeZone(identifier: timeZone) }

        var locale: Locale?
        if let localeInfo = user["locale"] as? String { locale = Locale(identifier: localeInfo) }

        let phoneNumber = user["phoneNumber"] as? String
        let phoneNumberVerified = user["phoneNumberVerified"] as? Bool
        let address = user["address"] as? [String: String]

        var updatedAt: Date?
        if let dateString = user["updated_at"] as? String {
            updatedAt = date(from: dateString)
        }

        var customClaims = user
        UserInfo.publicClaims.forEach { customClaims.removeValue(forKey: $0) }

        self.init(sub: sub,
                  firstName: firstName,
                  familyName: familyName,
                  middleName: middleName,
                  displayName: displayName,
                  photoURL: photo,
                  website: website,
                  email: email,
                  emailVerified: emailVerified,
                  gender: gender,
                  birthdate: birthdate,
                  zoneinfo: zoneinfo,
                  locale: locale,
                  phoneNumber: phoneNumber,
                  phoneNumberVerified: phoneNumberVerified,
                  address: address,
                  updatedAt: updatedAt,
                  customClaims: customClaims)
    }

}
