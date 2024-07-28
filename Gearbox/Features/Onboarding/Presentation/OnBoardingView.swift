//
//  AlternativeView.swift
//  Gearbox
//
//  Created by Filip Kisić on 08.07.2024..
//

import SwiftUI

struct OnBoardingView: View {
  // MARK: - PROPERTIES
  @Binding var isOnboarding: Bool
  @State private var pageIndex = 0
  @State private var isLast = false
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color(.background)
        .edgesIgnoringSafeArea(.all)
      
      // MARK: - BACKGROUND IMAGE
      VStack (alignment: .leading) {
        Image(onboardingViews[pageIndex].imageName)
          .resizable()
          .frame(height: 550)
          .scaledToFit()
          .edgesIgnoringSafeArea(.all)
          .transition(
            .asymmetric(
              insertion: .move(edge: .trailing),
              removal: .move(edge: .leading)
            )
          )
          .id(UUID())
        Spacer()
      } //: VSTACK
      
      // MARK: - BACKGROUND COLOR
      VStack {
        LinearGradient(
          gradient: Gradient(colors: [.background.opacity(0.0), .background]),
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 550)
        .edgesIgnoringSafeArea(.all)
        Spacer()
      } //: VSTACK
      
      VStack(alignment: .leading) {
        Spacer()
          .frame(height: 450)
        
        // MARK: - TITLE AND PAGE INDICATOR
        HStack {
          Text(LocalizedStringKey(onboardingViews[pageIndex].title))
            .font(Font.custom("RobotoCondensed-Bold", size: 28))
            .id(UUID())
          Spacer()
          PageIndicator(pageNumber: onboardingViews.count, currentPageIndex: pageIndex)
        } //: HSTACK
        Spacer()
          .frame(height: 20)
        
        // MARK: - CONTENT TEXT
        Text(LocalizedStringKey(onboardingViews[pageIndex].content))
          .font(.system(size: 16, design: .rounded))
        
        Spacer()
        
        // MARK: - BUTTON
        HStack {
          Spacer()
          Button {
            if pageIndex != onboardingViews.count - 1 {
              withAnimation {
                pageIndex += 1
                isLast = pageIndex == onboardingViews.count - 1
              }
            } else {
              isOnboarding = false
            }
          } label: {
            Text(isLast ? "button.finish" : "button.next")
              .font(Font.custom("RobotoCondensed-Bold", size: 20))
              .foregroundStyle(.white)
              .padding(.vertical)
              .padding(.horizontal, 40)
          }
          .background(Color.brand)
        .cornerRadius(7)
        } //: HSTACK
      } //: VSTACK
      .padding(20)
    } //: ZSTACK
  }
}

// MARK: - PAGE INDICATOR
struct PageIndicator: View {
  let pageNumber: Int
  let currentPageIndex: Int
  
  var body: some View {
    ForEach(0..<pageNumber) { index in
      Circle()
        .frame(width: 10, height: 10)
        .foregroundColor(index == currentPageIndex ? .brandAlternative : .text)
    }
  }
}

// MARK: - PREVIEW
#Preview {
  @State var isOnboarding = true
  return OnBoardingView(isOnboarding: $isOnboarding)
}
