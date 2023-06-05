/// Defines methods for managing the current user's session.
protocol SessionManager {
    /// The current user of the session, if there is any.
    var currentUser: User? { get }
}
