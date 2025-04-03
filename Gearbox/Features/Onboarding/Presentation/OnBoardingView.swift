//
//  AlternativeView.swift
//  Gearbox
//
//  Created by Filip Kisić on 08.07.2024..
//

import SwiftUI

struct OnBoardingView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var router: Router
  
  @AppStorage("shouldShowOnBoarding") private var isOnboarding = true
  
  @State private var pageIndex = 0
  @State private var isLast = false
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color(.background)
        .edgesIgnoringSafeArea(.all)
      
      TabView(selection: $pageIndex) {
        ForEach (0..<onboardingViews.count, id: \.self) { index in
          renderOnboardingPage(onboardingViews[index])
        }
      } //: TAB VIEW
      .tabViewStyle(.page(indexDisplayMode: .never))
      .onChange(of: pageIndex) { _, newIndex in
        withAnimation {
          pageIndex = newIndex
          isLast = pageIndex == onboardingViews.count - 1
        }
      }
      .edgesIgnoringSafeArea(.all)
    } //: ZSTACK
  }
}

// MARK: - PAGE INDICATOR
struct PageIndicator: View {
  let pageNumber: Int
  let currentPageIndex: Int
  
  var body: some View {
    ForEach (0 ..< pageNumber) { index in
      Circle()
        .frame(width: 10, height: 10)
        .foregroundColor(index == currentPageIndex ? .brandAlternative : .text)
    }
  }
}

private extension OnBoardingView {
  @ViewBuilder
  func renderOnboardingPage(_ content: OnBoardingContent) -> some View {
    ZStack {
      renderBackgroundImage(content)
      
      renderBackgroundColor()
      
      VStack(alignment: .leading) {
        Spacer()
          .frame(height: 450)
        
        renderTitleAndPageIndicator(content)
        
        Spacer()
          .frame(height: 20)
        
        // MARK: - CONTENT TEXT
        Text(LocalizedStringKey(content.content))
          .font(.system(size: 16, design: .rounded))
        
        Spacer()
        
        renderButton()
      } //: VSTACK
      .padding(20)
    }
  }
  
  @ViewBuilder
  func renderBackgroundImage(_ content: OnBoardingContent) -> some View {
    VStack (alignment: .leading) {
      Image(content.imageName)
        .resizable()
        .frame(height: 550)
        .scaledToFit()
        .edgesIgnoringSafeArea(.all)
      Spacer()
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderBackgroundColor() -> some View {
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
  }
  
  @ViewBuilder
  func renderTitleAndPageIndicator(_ content: OnBoardingContent) -> some View {
    HStack {
      Text(LocalizedStringKey(content.title))
        .font(Font.custom("RobotoCondensed-Bold", size: 28))
      Spacer()
      PageIndicator(pageNumber: onboardingViews.count, currentPageIndex: pageIndex)
    } //: HSTACK
  }
  
  @ViewBuilder
  func renderButton() -> some View {
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
          router.navigateTo(.signIn)
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
  }
}

// MARK: - PREVIEW
#Preview {
  OnBoardingView()
}
