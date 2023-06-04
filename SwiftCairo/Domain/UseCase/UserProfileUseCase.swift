protocol UserProfileUseCase {
    func fetchUserProfile(for userId: String) async throws -> User
}
