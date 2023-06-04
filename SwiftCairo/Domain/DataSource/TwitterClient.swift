protocol TwitterClient {
    func fetchHomeTimeline() async throws -> [Tweet]
    func fetchUserProfile(for userId: String) async throws -> User
}
