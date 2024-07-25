//
//  ParticleAnimation.swift
//  TextParticle
//
//  Created by Minsang Choi on 7/24/24.
//

import SwiftUI
import UIKit

struct ParticleTextAnimation: View {
    
    let text: String
    let particleCount = 1000
        
    @State private var particles: [Particle] = []
    @State private var dragPosition: CGPoint?
    @State private var dragVelocity: CGSize?
    @State private var size: CGSize = .zero
    
    
    let timer = Timer.publish(every: 1/120, on: .main, in: .common).autoconnect()
        
    var body: some View {
        
        Canvas { context, size in
            
            context.blendMode = .normal
            
            for particle in particles {
                let path = Path(ellipseIn: CGRect(x: particle.x, y: particle.y, width: 2, height: 2))
                context.fill(path, with: .color(.primary.opacity(0.7)))
            }
        }
        
        .onReceive(timer){ _ in
            updateParticles()
        }
        .onChange(of:text){
            createParticles()
        }
        .onAppear {
            createParticles()
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    dragPosition = value.location
                    dragVelocity = value.velocity
                    triggerHapticFeedback()
                }
            
                .onEnded { value in
                    dragPosition = nil
                    dragVelocity = nil
                    updateParticles()
                }
            
        )
        
        .background(.background)
        .overlay(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        size = geometry.size
                        createParticles()
                    }
            }
        )
    }
    
    
    
    private func createParticles() {
        
        let renderer = ImageRenderer(content: Text(text)
            .font(.system(size: 240, design: .rounded))
            .bold())
        
        renderer.scale = 1.0
        
        guard let image = renderer.uiImage else { return }
        guard let cgImage = image.cgImage else { return }
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        guard let pixelData = cgImage.dataProvider?.data, let data = CFDataGetBytePtr(pixelData) else { return }
        
        let offsetX = (size.width - CGFloat(width)) / 2
        let offsetY = (size.height - CGFloat(height)) / 2
        
        
        particles = (0..<particleCount).map { _ in
            
            var x, y: Int
            repeat {
                x = Int.random(in: 0..<width)
                y = Int.random(in: 0..<height)
            } while data[((width * y) + x) * 4 + 3] < 128
            
            return Particle(
                x: Double.random(in: -size.width...size.width*2),
                y: Double.random(in: 0...size.height * 2),
                baseX: Double(x) + offsetX,
                baseY: Double(y) + offsetY,
                density: Double.random(in: 5...20)
            )
        }
    }
    
    
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].update(dragPosition: dragPosition, dragVelocity: dragVelocity)
        }
    }
}



func triggerHapticFeedback() {
    let impact = UIImpactFeedbackGenerator(style: .light)
    impact.impactOccurred()
}
