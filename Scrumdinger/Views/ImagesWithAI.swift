//
//  ImagesWithAI.swift
//  Scrumdinger
//
//  Created by Franklin Heymann on 5/30/24.
//

import SwiftUI
import OpenAI

class ImageController: ObservableObject {
    @Published var messages: [Prompt] = [.init(content: "Hello", isUser: true), .init(content: "Hello", isUser: false)]
    
    let openAI = OpenAI(apiToken:"sk-proj-H0LiapYVtCldjboiRYFeT3BlbkFJnVMzTj9rw8kU9k2uJxta")
    
    func sendNewMessage(content: String) {
        let userMessage = Prompt(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .dall_e_3
        )
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return }
                DispatchQueue.main.async {
                    self.messages.append(Prompt(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
struct Prompt: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

struct ImagesWithAI: View {
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    var body: some View {
        VStack {
            ScrollView {
                ForEach($chatController.messages) {
                    message in
                    MessageView(message: message)
                        .padding(5)
                }
            }
            Divider()
            HStack {
                if #available(iOS 16.0, *) {
                    TextField("Message...", text: self.$string, axis: .vertical)
                        .padding(5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                } else {
                    // Fallback on earlier versions
                }
                Button {
                    self.chatController.sendNewMessage(content: string)
                    string = ""
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
            
        }
    }
}


struct ImageView: View {
    @Binding var message: Prompt
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                }
            } else {
                HStack {
                    Image(message.content)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ImagesWithAI()
}
