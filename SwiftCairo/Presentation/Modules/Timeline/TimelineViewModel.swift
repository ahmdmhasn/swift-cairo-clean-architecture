import Combine

protocol TimelineViewModelType {
    var input: TimelineInput { get }
    var output: TimelineOutput { get }
}

/// TimelineInput
final class TimelineInput: ObservableObject {
    let fetchTweetsTrigger = PassthroughSubject<Void, Never>()
    let createTweetTrigger = PassthroughSubject<Void, Never>()
}

/// TimelineOutput
final class TimelineOutput: ObservableObject {
    @Published fileprivate(set) var tweets: [Tweet] = []
    @Published fileprivate(set) var state: TimelineState = .idle
    @Published fileprivate(set) var error: Error?
}

/// TimelineState
enum TimelineState {
    case idle
    case loading
    case loaded
    case failure(Error)
}

/// TimelineViewModel
final class TimelineViewModel: TimelineViewModelType {
    let input: TimelineInput
    let output: TimelineOutput
    
    private let timelineUseCase: TimelineUseCase
    private let coordinator: PostTweetCoordinator
    private var subscriptions: Set<AnyCancellable> = []

    init(input: TimelineInput = TimelineInput(),
         output: TimelineOutput = TimelineOutput(),
         timelineUseCase: TimelineUseCase,
         coordinator: PostTweetCoordinator) {
        self.input = input
        self.output = output
        self.timelineUseCase = timelineUseCase
        self.coordinator = coordinator
        configureInputObservers()
        configureOutputObservers()
    }
}

// MARK: Inputs & Outputs Observing

private extension TimelineViewModel {
    func configureInputObservers() {
        input.fetchTweetsTrigger
            .sink { [self] in fetchTweets() }
            .store(in: &subscriptions)
        
        input.createTweetTrigger
            .sink { [self] in coordinator.displayPostTweet() }
            .store(in: &subscriptions)
    }
    
    func configureOutputObservers() {
        output.$state
            .compactMap { state in
                guard case let .failure(error) = state else {
                    return nil
                }
                
                return error
            }
            .assign(to: &output.$error)
    }
}

// MARK: Networking

private extension TimelineViewModel {
    func fetchTweets() {
        output.state = .loading
        
        Task { @MainActor in
            do {
                let fetchedTweets = try await timelineUseCase.fetchHomeTimeline()
                output.tweets = fetchedTweets
                output.state = .loaded
            } catch {
                output.state = .failure(error)
            }
        }
    }
}
