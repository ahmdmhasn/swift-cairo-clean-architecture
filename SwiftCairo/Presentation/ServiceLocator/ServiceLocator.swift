enum ServiceLocator {
    /// Provide access to default `SessionManager`
    static let sessionManager: SessionManager = DefaultSessionManager()
    
    /// Provide access to default `LocalDatabase`
    static let localDatabase: LocalDatabase = CoreDataDatabase()
    
    /// Provide access to default `TwitterAPI`
    static let twitterAPI: TwitterAPI = URLSessionTwitterAPI(session: .shared)
}
