//
//  ContentView.swift
//  DailyFriend
//
//  Created by Juliana Galag on 2/27/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var selectedVoice: String? = nil
    @State private var audioPlayer: AVPlayer?
    @State private var isCloudPlaying = false
    
    let voiceSamples = [
        VoiceOption(
            name: "Meadow",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/1/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/meadow.svg"
        ),
        VoiceOption(
            name: "Cypress",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/2/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/cypress.svg"
        ),
        VoiceOption(
            name: "Iris",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/3/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/iris.svg"
        ),
        VoiceOption(
            name: "Hawke",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/4/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/hawke.svg"
        ),
        VoiceOption(
            name: "Seren",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/5/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/seren.svg"
        ),
        VoiceOption(
            name: "Stone",
            audioStringUrl: "https://static.dailyfriend.ai/conversations/samples/6/%d/audio.mp3",
            imageStringUrl: "https://static.dailyfriend.ai/images/voices/stone.svg"
        )
    ]
        
    var body: some View {
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
                                    isSelected: selectedVoice == voice.name) {
                        selectedVoice = voice.name
                        isCloudPlaying = true
                        let audioStringUrl = String(format: voice.audioStringUrl, Int.random(in: 1...20))
                        if let url = URL(string: audioStringUrl) {
                            playAudio(from: url)
                        }
                    }
                }
            }
            .padding()
            
            Button(action: {
                print("Selected voice: \(selectedVoice ?? "None")")
            }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
            .disabled(selectedVoice == nil)
            .opacity(selectedVoice == nil ? 0.5 : 1.0)
            .padding()
        }
        .padding()
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
                            Image(systemName: "leaf.fill") // Placeholder for custom voice icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.orange)
                            
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

