import Combine

protocol PostTweetViewModelType {
    var input: PostTweetInput { get }
    var output: PostTweetOutput { get }
}

/// PostTweetInput
final class PostTweetInput: ObservableObject {
    @Published var tweetText: String = ""
    let postTweetTrigger = PassthroughSubject<Void, Never>()
}

/// PostTweetOutput
final class PostTweetOutput: ObservableObject {
    @Published fileprivate(set) var tweetEnabled = false
    let tweetAddedPublisher = PassthroughSubject<Void, Never>()
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
            .assign(to: &output.$tweetEnabled)
    }
}

// MARK: Networking

private extension PostTweetViewModel {
    func postTweet() {
        Task {
            do {
                let tweetAdded = try await postTweetUseCase.execute(tweetText: input.tweetText)
                if tweetAdded {
                    output.tweetAddedPublisher.send()
                }
            } catch {
                // Handle the received error
            }
        }
    }
}
