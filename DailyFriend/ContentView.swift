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
    let voiceSamples = [
        (name: "Meadow", url: URL(string: "https://static.dailyfriend.ai/conversations/samples/1/1/audio.mp3")!),
        (name: "Cypress", url: URL(string: "https://static.dailyfriend.ai/conversations/samples/2/1/audio.mp3")!),
        (name: "Iris", url: URL(string: "https://static.dailyfriend.ai/conversations/samples/3/1/audio.mp3")!),
        (name: "Hawke", url: URL(string: "https://static.dailyfriend.ai/conversations/samples/4/1/audio.mp3")!),
        (name: "Seren", url: URL(string: "https://static.dailyfriend.ai/conversations/samples/5/1/audio.mp3")!),
        (name: "Stone", url: URL(string: "https://static.dailyfriend.ai/conversations/samples/6/1/audio.mp3")!)
    ]
        
    var body: some View {
        VStack(spacing: 16) {
            Text("Pick my voice")
                .font(.title)
                .bold()
            
            Image(systemName: "cloud.fill") // Replace with actual cloud image
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            Text("Find the voice that resonates with you")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(voiceSamples, id: \..name) { voice in
                    let name = voice.name
                    VoiceOptionView(voice: name, isSelected: selectedVoice == name) {
                        selectedVoice = voice.name
                        playAudio(from: voice.url)
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

    func playRandomSample() {
        if let randomVoice = voiceSamples.randomElement() {
            playAudio(from: randomVoice.url)
        }
    }
}

struct VoiceOptionView: View {
    let voice: String
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
                            
                            Text(voice)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

