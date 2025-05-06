//
//  OnBoardingContent.swift
//  Gearbox
//
//  Created by Filip Kisić on 08.07.2024..
//

import Foundation

struct OnBoardingContent: Hashable {
  let imageName: String
  let title: String
  let content: String
  let pageIndex: Int
}

let onboardingViews = [
  OnBoardingContent(imageName: "onboarding_first", title: "onboarding.first.title", content: "onboarding.first.content", pageIndex: 1),
  OnBoardingContent(imageName: "onboarding_second", title: "onboarding.second.title", content: "onboarding.second.content", pageIndex: 2),
  OnBoardingContent(imageName: "onboarding_third", title: "onboarding.third.title", content: "onboarding.third.content", pageIndex: 3)
]
