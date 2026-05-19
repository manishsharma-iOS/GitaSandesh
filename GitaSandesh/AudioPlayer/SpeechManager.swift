//
//  SpeechManager.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 03/02/26.
//
import AVFoundation
import Combine

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {

    private let synthesizer = AVSpeechSynthesizer()

    @Published var isSpeaking = false
    @Published var isPaused = false
    @Published var currentText: String?
    @Published var progress: Double = 0.0   // 0.0 - 1.0

    private var totalLength: Int = 1
    private var spokenLength: Int = 0

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, language: String) {
        stop()

        currentText = text
        totalLength = text.count
        spokenLength = 0
        progress = 0

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.45

        synthesizer.speak(utterance)
        isSpeaking = true
        isPaused = false
    }

    func pause() {
        synthesizer.pauseSpeaking(at: .word)
        isPaused = true
        isSpeaking = false
    }

    func resume() {
        synthesizer.continueSpeaking()
        isPaused = false
        isSpeaking = true
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        isPaused = false
        progress = 0
        currentText = nil
    }

    // MARK: - Progress Tracking

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                            willSpeakRangeOfSpeechString characterRange: NSRange,
                            utterance: AVSpeechUtterance) {

        spokenLength = characterRange.location + characterRange.length
        progress = Double(spokenLength) / Double(max(totalLength, 1))
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                            didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        isPaused = false
        progress = 1.0
    }
}
