import UIKit

// MARK: TimelineViewController

final class TimelineViewController: UIViewController {
    private let input: TimelineInput
    private let output: TimelineOutput

    init(viewModel: TimelineViewModelType) {
        self.input = viewModel.input
        self.output = viewModel.output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up UI and bindings
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = .init(systemItem: .add, primaryAction: UIAction { _ in
            self.input.createTweetTrigger.send()
        })
        
        input.fetchTweetsTrigger.send()
    }
}
