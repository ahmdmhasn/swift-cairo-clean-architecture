import CoreData

final class CoreDataDatabase: LocalDatabase {
    private let persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: "Twitter")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
    }
    
    func save(tweets: [Tweet]) async throws {
        let context = persistentContainer.newBackgroundContext()
        try await context.perform {
            tweets.forEach { tweet in
                let tweetEntity = TweetEntity(context: context)
                let userEntity = UserEntity(context: context)
                tweetEntity.update(with: tweet)
                tweetEntity.user = userEntity
            }
            
            try context.save()
        }
    }
    
    func fetchHomeTimeline() async throws -> [Tweet] {
        let context = persistentContainer.newBackgroundContext()
        return try await context.perform {
            let request: NSFetchRequest<TweetEntity> = TweetEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \TweetEntity.createdAt, ascending: false)]
            let tweetEntities = try context.fetch(request)
            return tweetEntities.map { $0.toDomain() }
        }
    }
}
