//
//  DetailView.swift
//  DailyFriend
//
//  Created by Juliana Galag on 2/28/25.
//

import SwiftUI
import AVKit

struct DetailView: View {
    @State private var isCloudPlaying = false
    @State private var title: String = "Loading..."
    @State private var audioPlayer = AVPlayer()
    @State private var playCount = 0
    
    private let maxPlays = 3
    
    let voiceOption: VoiceOption
    
    var body: some View {
        VStack(spacing: 16) {
            LottieView(urlString: "https://static.dailyfriend.ai/images/mascot-animation.json",
                       isPlaying: $isCloudPlaying)
                .frame(width: 200, height: 200)
            
            Text(title)
                .font(.title)
        }
        .onAppear {
            playRandom()
        }
        .onDisappear() {
            audioPlayer.pause()
        }
        .padding()
    }
    
    func playRandom() {
        let randomNumber = Int.random(in: 1...20)
        let audioStringUrl = String(format: voiceOption.audioStringUrl, randomNumber)
        let transcriptionStringUrl = String(format: voiceOption.transcriptionStringUrl, randomNumber)
        fetchTextFile(stringUrl: transcriptionStringUrl)
        playAudio(stringUrl: audioStringUrl)
    }
    
    func fetchTextFile(stringUrl: String) {
        guard let url = URL(string: stringUrl) else {
            title = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    title = "Error: \(error.localizedDescription)"
                }
                return
            }

            if let data = data, let text = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    title = text
                }
            } else {
                DispatchQueue.main.async {
                    title = "Failed to load content"
                }
            }
        }.resume()
    }
    
    func playAudio(stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        isCloudPlaying = true
        
        audioPlayer = AVPlayer(url: url)
        audioPlayer.play()
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: audioPlayer.currentItem,
            queue: .main
        ) { _ in
            playCount += 1
            if playCount < maxPlays {
                playRandom()
            } else {
                isCloudPlaying = false
            }
        }
    }
}
