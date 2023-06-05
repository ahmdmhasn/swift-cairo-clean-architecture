protocol LocalDatabase {
    func save(tweets: [Tweet]) async throws
    func fetchHomeTimeline() async throws -> [Tweet]
}
