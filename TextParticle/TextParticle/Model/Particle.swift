//
//  Particle.swift
//  TextParticle
//
//  Created by Minsang Choi on 7/24/24.
//
import SwiftUI

struct Particle {
    
    var x: Double
    var y: Double
    let baseX: Double
    let baseY: Double
    let density: Double
    var isStopped = false
    
    
    mutating func update(dragPosition: CGPoint?, dragVelocity: CGSize?) {
        
        let dx = baseX - x
        let dy = baseY - y
        let distance = sqrt(dx * dx + dy * dy)
        let forceDirectionX = dx / distance
        let forceDirectionY = dy / distance
        
        let maxDistance: Double = 280
        let force = (maxDistance - distance) / maxDistance
        let directionX = forceDirectionX * force * density
        let directionY = forceDirectionY * force * density
        
        
        // Apply slow movement when close to the base position
        if distance < 30 {
            x += directionX * 0.01
            y += directionY * 0.01
        } else {
            if distance < maxDistance {
                x += directionX * 2.5
                y += directionY * 2.5
            } else {
                if x != baseX {
                    let dx = x - baseX
                    x -= dx / 10
                }
                
                if y != baseY {
                    let dy = y - baseY
                    y -= dy / 10
                }
            }
        }
                
        // React to drag gesture with increased responsiveness
        
        if let dragPosition = dragPosition {
            
            let dragDx = x - dragPosition.x
            let dragDy = y - dragPosition.y
            
            var velocityF = 0.0
            
            if let dragVelocity = dragVelocity {
                velocityF = max(abs(dragVelocity.width),abs(dragVelocity.height))
            }
            
            let dragDistance = sqrt(dragDx * dragDx + dragDy * dragDy)
            let dragForce = (200 - min(dragDistance, 200)) / 200 + velocityF * 0.00005
            
            x += dragDx * dragForce * 0.5
            y += dragDy * dragForce * 0.5
        }
    }
}
