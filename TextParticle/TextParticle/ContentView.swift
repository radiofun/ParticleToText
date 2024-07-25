import SwiftUI
import UIKit

struct ParticleView: View {
    
    @State private var text : String = "a"
    @FocusState private var onfocus: Bool
    
    
    var body: some View {
        
        ZStack{
            VStack {
                ParticleTextAnimation(text: text)
                    .ignoresSafeArea()
                    .opacity(onfocus ? 0.3 : 1)
            }
            
            VStack{
                Text("Text to Particle")
                    .foregroundColor(.primary)
                    .padding()
                    .font(.system(size: 14, design: .rounded))
                    .bold()
                
                TextField("...", text:$text)
                    .foregroundColor(.primary)
                    .padding()
                    .font(.system(size: 20, design: .rounded))
                    .bold()
                    .background(.primary.opacity(0.1))
                    .cornerRadius(20)
                    .frame(width:200)
                    .contentShape(Rectangle())
                    .multilineTextAlignment(.center)
                    .focused($onfocus)
            }
            .offset(y: onfocus ? 0 : 330)

        }
    }
}



#Preview {
    ParticleView()
}
