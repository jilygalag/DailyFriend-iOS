//
//  VoiceOptionView.swift
//  DailyFriend
//
//  Created by Juliana Galag on 2/28/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImageSVGCoder

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
        .padding(4)
        .onAppear() {
            let SVGCoder = SDImageSVGCoder.shared
            SDImageCodersManager.shared.addCoder(SVGCoder)
        }
    }
}

struct VoiceOption {
    let name: String
    let audioStringUrl: String
    let imageStringUrl: String
    let transcriptionStringUrl: String
}
