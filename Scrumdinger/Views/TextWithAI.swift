//
//  ChatBotMain.swift
//  Scrumdinger
//
//  Created by Franklin Heymann on 5/23/24.
//

import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    
    let openAI = OpenAI(apiToken:"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")
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let query = ChatQuery(
            messages: self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo
        )
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                print("success")
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return }
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

struct TextWithAI: View {
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    var body: some View {
        Text("TextWithAI")
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


struct MessageView: View {
    @Binding var message: Message
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
                    Text(message.content)
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
    TextWithAI()
}

