import UIKit
import Combine

// MARK: TimelineViewController

final class TimelineViewController: UIViewController {
    // MARK: Outlets
    private let tableView = UITableView()
    
    // MARK: Properties
    private let input: TimelineInput
    private let output: TimelineOutput
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: Initialization
    init(viewModel: TimelineViewModelType) {
        self.input = viewModel.input
        self.output = viewModel.output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI and bindings
        configureAppearance()
        configureNavigationItem()
        configureBinding()
        
        input.fetchTweetsTrigger.send()
    }
    
    // MARK: Configuration
    private func configureAppearance() {
        view.backgroundColor = .white
    }
    
    private func configureNavigationItem() {
        let addTweetButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
            self?.input.createTweetTrigger.send()
        })
        
        navigationItem.rightBarButtonItem = addTweetButtonItem
    }
    
    private func configureBinding() {
        output.$tweets
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in self?.tableView.reloadData() })
            .store(in: &subscriptions)
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse and configure the cell...
        return UITableViewCell()
    }
}
