//
//  LottieView.swift
//  DailyFriend
//
//  Created by Juliana Galag on 2/28/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var urlString: String
    @Binding var isPlaying: Bool
    
    class Coordinator {
        var animationView = LottieAnimationView()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let animationView = context.coordinator.animationView
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        fetchAnimation(from:urlString, animationView: animationView)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let animationView = context.coordinator.animationView
        if isPlaying {
            animationView.play()
        } else {
            animationView.stop()
        }
    }
    
    private func fetchAnimation(from urlString: String, animationView: LottieAnimationView) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil,
                  let animation = try? JSONDecoder().decode(LottieAnimation.self, from: data) else {
                print("Failed to load animation:", error?.localizedDescription ?? "Unknown error")
                return
            }
            DispatchQueue.main.async {
                animationView.animation = animation
                animationView.play()
            }
        }.resume()
    }
}
