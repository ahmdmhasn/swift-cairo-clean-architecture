protocol HomeTimelineUseCase {
    func fetchHomeTimeline() async throws -> [Tweet]
}
