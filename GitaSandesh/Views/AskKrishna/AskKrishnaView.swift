//
//  AskKrishnaView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/04/26.
//


import SwiftUI

struct AskKrishnaView: View {
    
    @StateObject private var vm = ChatViewModel()
    @State private var inputText = ""
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                
                // 🟡 Background
                Image("paper_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .opacity(0.25)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // 🔶 Header
                    Text("Ask Krishna 🙏")
                        .font(.title2.bold())
                        .padding(.top, 8)
                        .padding(.bottom, 6)
                    
                    Divider()
                    
                    // 💬 Chat
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                
                                ForEach(vm.messages) { message in
                                    messageBubble(message, maxWidth: geo.size.width * 0.7)
                                        .id(message.id)
                                }
                                
                                if vm.isLoading {
                                    HStack {
                                        ProgressView()
                                        Text("Krishna is thinking...")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .onChange(of: vm.messages.count) { _ in
                            if let last = vm.messages.last {
                                withAnimation {
                                    proxy.scrollTo(last.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // ✍️ Input
                    HStack(spacing: 8) {
                        
                        TextField("Seek guidance...", text: $inputText)
                            .padding(10)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(10)
                        
                        Button {
                            Task {
                                await vm.sendMessage(inputText)
                                inputText = ""
                            }
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.orange)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                }
            }
        }
    }
}

extension AskKrishnaView {
    
    func messageBubble(_ message: ChatMessage, maxWidth: CGFloat) -> some View {
        HStack {
            
            if message.role == "user" {
                Spacer()
                
                Text(message.content)
                    .padding(10)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(12)
                    .frame(maxWidth: maxWidth, alignment: .trailing)
                    .fixedSize(horizontal: false, vertical: true)
                
            } else {
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("Krishna")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Text(message.content)
                        .padding(10)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(12)
                        .frame(maxWidth: maxWidth, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
        }
    }
}
