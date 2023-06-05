import CoreData

@objc(TweetEntity)
class TweetEntity: NSManagedObject {
    static func fetchRequest() -> NSFetchRequest<TweetEntity> {
        return NSFetchRequest(entityName: "TweetEntity")
    }
    
    @NSManaged var id: String
    @NSManaged var text: String
    @NSManaged var user: UserEntity
    @NSManaged var createdAt: Date
}
