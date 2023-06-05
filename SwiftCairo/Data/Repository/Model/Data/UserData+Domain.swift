extension UserData {
    func toDomain() -> User {
        return User(id: id, name: name, profileImageUrl: profileImageUrl)
    }
}
