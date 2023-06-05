import CoreData

@objc(UserEntity)
class UserEntity: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var profileImageUrl: URL
}
