//
//  SplashView.swift
//  Gearbox
//
//  Created by Filip Kisić on 26.08.2024..
//

import SwiftUI

struct SplashView: View {
  // MARK: - PROPERTIES
  @State private var isScaleAnimating = false
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea(.all)
      
      VStack {
        Image("gearbox_logo")
          .resizable()
          .scaledToFit()
          .frame(width: 65)
          .scaleEffect(isScaleAnimating ? CGSize(width: 0.8, height: 0.8) : CGSize(width: 1, height: 1))
          .animation(.easeIn(duration: 1).repeatForever(), value: isScaleAnimating)
          .onAppear {
          }
        
        Text("loading.three.dots")
          .font(Font.custom("RobotoCondensed-Bold", size: 18))
          .padding(.top, 10)
      } //: VSTACK
    } //: ZSTACK
    .onAppear {
      DispatchQueue.main.async {
        isScaleAnimating.toggle()
      }
    }
  }
}

// MARK: - PREVIEW
#Preview {
  SplashView()
}
