//
//  chatView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 25/04/26.
//

import SwiftUI


struct ChatView: View {
    
    @StateObject private var vm = ChatViewModel()
    @State private var inputText = ""
    
    var body: some View {
        VStack {
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    
                    ForEach(vm.messages) { message in
                        HStack {
                            if message.role == "user" {
                                Spacer()
                                Text(message.content)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(12)
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                                Spacer()
                            }
                        }
                    }
                    
                    if vm.isLoading {
                        HStack {
                            ProgressView()
                            Text("Thinking...")
                        }
                    }
                }
                .padding()
            }
            
            Divider()
            
            HStack {
                TextField("Ask Krishna...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    Task {
                        await vm.sendMessage(inputText)
                        inputText = ""
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                }
            }
            .padding()
        }
    }
}
