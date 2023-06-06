import SwiftUI

final class PostTweetHostingController: UIHostingController<PostTweetView> {
    init(viewModel: PostTweetViewModelType) {
        let rootView = PostTweetView(viewModel: viewModel)
        super.init(rootView: rootView)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: PostTweetView

struct PostTweetView: View {
    @StateObject private var input: PostTweetInput
    @StateObject private var output: PostTweetOutput
    
    init(viewModel: PostTweetViewModelType) {
        self._input = .init(wrappedValue: viewModel.input)
        self._output = .init(wrappedValue: viewModel.output)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("What's on your mind?")
                    .font(.headline)
                
                TextEditor(text: $input.tweetText)
                    .frame(minHeight: 150)
                    .padding()
                    .border(Color.gray)
                
                Button(action: input.postTweetTrigger.send) {
                    Text("Post")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .buttonStyle(PlainButtonStyle())
                .disabled(!output.isTweetEnabled)
                
                Spacer()
            }
            .navigationBarTitle("New Tweet")
        }
    }
}

// MARK: Previews

struct PostTweetView_Previews: PreviewProvider {
    class PreviewPostTweetViewModel: PostTweetViewModelType {
        let input = PostTweetInput()
        let output = PostTweetOutput()
    }

    static var previews: some View {
        PostTweetView(viewModel: PreviewPostTweetViewModel())
    }
}
