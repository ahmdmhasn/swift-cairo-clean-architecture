import CoreData

extension UserEntity {
    /// Updates the UsertEntity with the a User.
    public func update(with user: User) {
        self.id = user.id
        self.name = user.name
        self.profileImageUrl = user.profileImageUrl
    }
    
    /// Returns a User version of the receiver.
    public func toDomain() -> User {
        return User(id: id,
                    name: name,
                    profileImageUrl: profileImageUrl)
    }
}
