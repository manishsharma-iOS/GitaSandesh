//
//  KrishnaChatView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 01/05/26.
//
import SwiftUI
import UIKit
import Combine


// MARK: - MAIN CHAT VIEW

struct KrishnaChatView: View {
    @StateObject private var vm = KrishnaChatViewModel()
    @FocusState private var isKeyboardFocused: Bool
    
    @State private var showMenu = false
    @State private var showAttachmentOptions = false
    @State private var isRecording = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // App Background Layer
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                Image("paper_white")
                    .resizable()
                    .opacity(0.15)
                    .ignoresSafeArea()
                
                // Warm ambient background glow matching dashboard theme
                VStack {
                    LinearGradient(
                        colors: [Color.orange.opacity(0.12), Color.yellow.opacity(0.06), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    chatHeader
                    
                    if vm.messages.isEmpty {
                        emptyStateView
                    } else {
                        messagesView
                    }
                    
                    if vm.isTyping {
                        TypingIndicatorView()
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    inputBar
                }
            }
            .navigationBarHidden(true)
            .animation(.easeInOut(duration: 0.25), value: vm.isTyping)
        }
    }
}


// MARK: - HEADER

extension KrishnaChatView {
    private var chatHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange, .yellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: Color.orange.opacity(0.2), radius: 6, x: 0, y: 3)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("श्रीकृष्ण संवाद")
                    .font(.system(.headline, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    
                    Text("सदैव सहायक")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button {
                showMenu.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
            }
            .confirmationDialog(
                "Chat Options",
                isPresented: $showMenu,
                titleVisibility: .visible
            ) {
                Button("Clear Chat", role: .destructive) {
                    vm.clearChat()
                }
                Button("Suggested Questions") {
                    showSuggestions()
                }
                Button("Share Chat") {
                    shareChat()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .padding()
        .background(
            Color(.systemBackground).opacity(0.85)
                .background(.ultraThinMaterial)
        )
        .overlay(
            VStack {
                Spacer()
                Divider().background(Color.black.opacity(0.05))
            }
        )
    }
}


// MARK: - EMPTY STATE

extension KrishnaChatView {
    private var emptyStateView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Spacer(minLength: 40)
                
                // Beautiful Glowing Spiritual Center
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.08))
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .fill(Color.yellow.opacity(0.12))
                        .frame(width: 110, height: 110)
                    
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                VStack(spacing: 8) {
                    Text("पूछिए कृष्ण से")
                        .font(.system(.largeTitle, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("भगवद्गीता के अमर संदेशों के माध्यम से मन की शांति, कर्तव्य और जीवन की दिशा के प्रश्नों का उत्तर पाएं।")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                }
                
                // Suggested Question Cards Grid
                VStack(spacing: 12) {
                    Text("मार्गदर्शन के लिए कुछ पूछें")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                    
                    ForEach(vm.suggestedPrompts, id: \.self) { prompt in
                        Button {
                            withAnimation(.spring()) {
                                vm.sendSuggestedPrompt(prompt)
                            }
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "quote.opening")
                                    .foregroundColor(.orange)
                                    .font(.footnote)
                                
                                Text(prompt)
                                    .font(.system(.subheadline, design: .serif))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(4)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption2)
                                    .foregroundColor(.orange.opacity(0.6))
                            }
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.orange.opacity(0.12), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 3)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
            }
        }
    }
}


// MARK: - MESSAGE LIST

extension KrishnaChatView {
    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 18) {
                    ForEach(vm.messages) { message in
                        MessageRow(message: message)
                            .id(message.id)
                    }
                    
                    Color.clear
                        .frame(height: 1)
                        .id("BOTTOM")
                }
                .padding(.top, 16)
                .padding(.bottom, 8)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: vm.messages.count) { _, _ in
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    proxy.scrollTo("BOTTOM", anchor: .bottom)
                }
            }
        }
    }
}


// MARK: - INPUT BAR

extension KrishnaChatView {
    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider().background(Color.black.opacity(0.06))
            
            HStack(alignment: .bottom, spacing: 12) {
                // Quick-prompt Action Button
                Button {
                    showAttachmentOptions.toggle()
                } label: {
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundColor(.orange)
                        .frame(width: 44, height: 44)
                        .background(Color.orange.opacity(0.08))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.orange.opacity(0.15), lineWidth: 1))
                }
                .confirmationDialog(
                    "Quick Wisdom Topics",
                    isPresented: $showAttachmentOptions,
                    titleVisibility: .visible
                ) {
                    Button("Bhagavad Gita Wisdom") {
                        vm.inputText = "Teach me wisdom from Bhagavad Gita"
                    }
                    Button("Meditation Guidance") {
                        vm.inputText = "Guide me for meditation"
                    }
                    Button("Motivation") {
                        vm.inputText = "Give me motivation for today"
                    }
                    Button("Peace of Mind") {
                        vm.inputText = "How can I stay peaceful?"
                    }
                    Button("Cancel", role: .cancel) { }
                }
                
                // Translucent Text Entry Area
                HStack(alignment: .bottom, spacing: 8) {
                    TextField(
                        "पूछिए, 'मन को शांत कैसे करें?'...",
                        text: $vm.inputText,
                        axis: .vertical
                    )
                    .focused($isKeyboardFocused)
                    .lineLimit(1...5)
                    .foregroundColor(.primary)
                    .font(.body)
                    
                    if vm.inputText.isEmpty {
                        Button {
                            toggleVoiceInput()
                        } label: {
                            Image(systemName: isRecording ? "stop.circle.fill" : "mic.fill")
                                .font(.title3)
                                .foregroundColor(isRecording ? .red : .orange)
                        }
                        .padding(.bottom, 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
                
                // Saffron Send Circular Button
                Button {
                    sendMessage()
                } label: {
                    Group {
                        if vm.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: canSend ? [.orange, .red] : [Color(.systemGray4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: canSend ? .orange.opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
                }
                .disabled(!canSend || vm.isLoading)
                .scaleEffect(canSend ? 1 : 0.95)
                .animation(.spring(), value: canSend)
            }
            .padding()
            .background(Color(.systemBackground).opacity(0.85).background(.ultraThinMaterial))
        }
    }
    
    private var canSend: Bool {
        !vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func sendMessage() {
        guard canSend else { return }
        vm.sendMessage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isKeyboardFocused = true
        }
    }
}


// MARK: - FUNCTIONS

extension KrishnaChatView {
    private func shareChat() {
        let chatText = vm.messages
            .map { "\($0.isUser ? "You" : "Krishna"): \($0.text)" }
            .joined(separator: "\n\n")
        
        let activityVC = UIActivityViewController(activityItems: [chatText], applicationActivities: nil)
        
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first?
            .rootViewController?
            .present(activityVC, animated: true)
    }
    
    private func showSuggestions() {
        if let prompt = vm.suggestedPrompts.randomElement() {
            vm.inputText = prompt
        }
    }
    
    private func toggleVoiceInput() {
        isRecording.toggle()
        if isRecording {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                vm.inputText = "मन को शांत कैसे रखें?"
                isRecording = false
            }
        }
    }
}


// MARK: - MESSAGE ROW

struct MessageRow: View {
    let message: ChatMessageNew
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.isUser {
                Spacer(minLength: 60)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(UserBubble())
                        .shadow(color: Color.orange.opacity(0.12), radius: 4, x: 0, y: 3)
                    
                    Text(message.timeString)
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                }
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .yellow],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.text)
                            .font(.system(.body, design: .serif))
                            .lineSpacing(6)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.black.opacity(0.04), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                        
                        Text(message.timeString)
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                    }
                }
                Spacer(minLength: 60)
            }
        }
        .padding(.horizontal, 12)
        .transition(
            .asymmetric(
                insertion: .move(edge: message.isUser ? .trailing : .leading).combined(with: .opacity),
                removal: .opacity
            )
        )
    }
}


// MARK: - TYPING INDICATOR

struct TypingIndicatorView: View {
    @State private var animate = false
    
    var body: some View {
        HStack {
            HStack(spacing: 6) {
                ForEach(0..<3) { index in
                    Circle()
                        .frame(width: 6, height: 6)
                        .offset(y: animate ? -3 : 3)
                        .animation(
                            .easeInOut(duration: 0.4)
                            .repeatForever()
                            .delay(Double(index) * 0.12),
                            value: animate
                        )
                }
            }
            .foregroundColor(.orange)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.04), lineWidth: 1)
            )
            
            Spacer()
        }
        .onAppear {
            animate = true
        }
    }
}


// MARK: - USER BUBBLE CUSTOM SHAPE

struct UserBubble: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight, .bottomLeft],
            cornerRadii: CGSize(width: 18, height: 18)
        )
        return Path(path.cgPath)
    }
}

// MARK: - PREVIEWS

struct KrishnaChatView_Previews: PreviewProvider {
    static var previews: some View {
        KrishnaChatView()
            .preferredColorScheme(.light)
        
        KrishnaChatView()
            .preferredColorScheme(.dark)
    }
}
