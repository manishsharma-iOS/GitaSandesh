import SwiftUI
import AVFoundation

struct SplashView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isActive = false
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0.3
    @State private var rotation: Double = 0

    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        if isActive {
            MainTabView()
                .transition(.opacity)
        } else {
            ZStack {
                LinearGradient(
                    colors: [.blue, .yellow],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Image("appLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .rotationEffect(.degrees(rotation))
                        .shadow(radius: 10)

                    Text("गीता संदेश")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .opacity(opacity)
                }
            }
            .onAppear {
               // playAudio()
                startAnimation()
                goToMainAfterDelay()
            }
        }
    }

    // MARK: - Animation

    private func startAnimation() {
        if reduceMotion {
            scale = 1.0
            opacity = 1.0
        } else {
            withAnimation(.easeOut(duration: 4)) {
                scale = 1.0
                opacity = 1.0
                rotation = 360
            }
        }
    }

    // MARK: - Navigation

    private func goToMainAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                isActive = true
            }
        }
    }

    // MARK: - Audio

    private func playAudio() {
        guard let path = Bundle.main.path(forResource: "om", ofType: "mp3") else {
            print("❌ splash.mp3 not found in bundle")
            return
        }

        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("✅ splash.mp3 playing")
        } catch {
            print("❌ Audio error: \(error)")
        }
    }
}
