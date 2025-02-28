//
//  ContentView.swift
//  DailyFriend
//
//  Created by Juliana Galag on 2/27/25.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI
import SDWebImageSVGCoder

struct ContentView: View {
    @State private var selectedVoiceOption: VoiceOption? = nil
    @State private var audioPlayer: AVPlayer?
    @State private var isCloudPlaying = false
    @State private var path = NavigationPath()
    
    let voiceSamples = [
        VoiceOption(
            name: "Meadow",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/1/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/meadow.svg",
            transcriptionStringUrl: "https://static.dailyfriend.ai/conversations/samples/1/%d/transcription.txt"
        ),
        VoiceOption(
            name: "Cypress",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/2/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/cypress.svg",
            transcriptionStringUrl: "https://static.dailyfriend.ai/conversations/samples/2/%d/transcription.txt"
        ),
        VoiceOption(
            name: "Iris",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/3/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/iris.svg",
            transcriptionStringUrl: "https://static.dailyfriend.ai/conversations/samples/3/%d/transcription.txt"
        ),
        VoiceOption(
            name: "Hawke",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/4/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/hawke.svg",
            transcriptionStringUrl: "https://static.dailyfriend.ai/conversations/samples/4/%d/transcription.txt"
        ),
        VoiceOption(
            name: "Seren",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/5/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/seren.svg",
            transcriptionStringUrl: "https://static.dailyfriend.ai/conversations/samples/5/%d/transcription.txt"
        ),
        VoiceOption(
            name: "Stone",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/6/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/stone.svg",
            transcriptionStringUrl: "https://static.dailyfriend.ai/conversations/samples/6/%d/transcription.txt"
        )
    ]
        
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 16) {
                Text("Pick my voice")
                    .font(.title)
                    .bold()

                LottieView(urlString: "https://static.dailyfriend.ai/images/mascot-animation.json",
                           isPlaying: $isCloudPlaying)
                    .frame(width: 200, height: 200)
                
                Text("Find the voice that resonates with you")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(voiceSamples, id: \.name) { voice in
                        VoiceOptionView(name: voice.name,
                                        imageString: voice.imageStringUrl,
                                        isSelected: selectedVoiceOption?.name == voice.name) {
                            selectedVoiceOption = voice
                            let audioStringUrl = String(format: voice.audioStringUrl, Int.random(in: 1...20))
                            if let url = URL(string: audioStringUrl) {
                                isCloudPlaying = true
                                playAudio(from: url)
                            }
                        }
                    }
                }
                .padding()
                
                Button(action: {
                    print("Selected voice: \(selectedVoiceOption?.name ?? "None")")
                    path.append("detail")
                }) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .disabled(selectedVoiceOption == nil)
                .opacity(selectedVoiceOption == nil ? 0.5 : 1.0)
                .padding()
            }
            .padding()
            .onAppear() {
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: audioPlayer?.currentItem,
                    queue: .main
                ) { _ in
                    isCloudPlaying = false
                }
            }
            .onDisappear() {
                audioPlayer?.pause()
            }
            .navigationDestination(for: String.self) { value in
                if value == "detail" {
                    if let selectedVoiceOption = selectedVoiceOption{
                        DetailView(voiceOption: selectedVoiceOption)
                    }
                }
            }
        }
    }
    
    init() {
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
    }
    
    func playAudio(from url: URL) {
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
    }
}

struct VoiceOptionView: View {
    let name: String
    let imageString: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.white))
                    .shadow(radius: 3)
                    .frame(height: 100)
                    .overlay(
                        VStack {
                            WebImage(url: URL(string: imageString))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            Text(name)
                                .font(.headline)
                        }
                    )
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.orange)
                        .padding(8)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct VoiceOption {
    let name: String
    let audioStringUrl: String
    let imageStringUrl: String
    let transcriptionStringUrl: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

