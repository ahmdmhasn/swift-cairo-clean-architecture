import Combine

protocol PostTweetViewModelType {
    var input: PostTweetInput { get }
    var output: PostTweetOutput { get }
}

/// PostTweetInput
final class PostTweetInput: ObservableObject {
    /// Published tweet content
    @Published var tweetText: String = ""
    
    /// Trigger for when a tweet is posted
    let postTweetTrigger = CurrentValueSubject<Void, Never>(())
}

/// PostTweetOutput
final class PostTweetOutput: ObservableObject {
    /// Published flag indicating whether tweeting is enabled
    @Published fileprivate(set) var isTweetEnabled = false
    
    /// PassthroughSubject for when a tweet is added
    fileprivate let tweetAdded = PassthroughSubject<Void, Never>()

    /// Publisher for when a tweet is added
    var tweetAddedPublisher: AnyPublisher<Void, Never> { tweetAdded.eraseToAnyPublisher() }
}

/// TimelineViewModel
final class PostTweetViewModel: PostTweetViewModelType {
    let input: PostTweetInput
    let output: PostTweetOutput
    
    private let postTweetUseCase: PostTweetUseCase
    private var subscriptions: Set<AnyCancellable> = []

    init(input: PostTweetInput = PostTweetInput(),
         output: PostTweetOutput = PostTweetOutput(),
         postTweetUseCase: PostTweetUseCase) {
        self.input = input
        self.output = output
        self.postTweetUseCase = postTweetUseCase
        configureInputObservers()
        configureOutputObservers()
    }
}

// MARK: Inputs & Outputs Observing

private extension PostTweetViewModel {
    func configureInputObservers() {
        input.postTweetTrigger
            .sink { [weak self] in self?.postTweet() }
            .store(in: &subscriptions)
    }
    
    func configureOutputObservers() {
        input.$tweetText
            .map { text in text.isEmpty == false }
            .assign(to: &output.$isTweetEnabled)
    }
}

// MARK: Networking

private extension PostTweetViewModel {
    func postTweet() {
        Task {
            do {
                let tweetAdded = try await postTweetUseCase.execute(tweetText: input.tweetText)
                if tweetAdded {
                    output.tweetAdded.send()
                }
            } catch {
                // Handle the received error
            }
        }
    }
}
