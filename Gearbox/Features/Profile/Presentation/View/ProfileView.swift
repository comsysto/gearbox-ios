//
//  ProfileView.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.11.2024..
//
import SwiftUI

struct ProfileView: View {
  @EnvironmentObject private var viewModel: ProfileViewModel
  
  @State private var selectedTabIndex = 0
  @Namespace private var animation
  
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack {
        Circle()
          .overlay{
            Image(systemName: "person.circle.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 75, height: 75)
              .clipShape(Circle())
              .foregroundStyle(.brand)
          } //: PROFILE IMAGE
          .frame(width: 75, height: 75)
        
        Text("@filipkisic")
          .font(.title2)
          .padding(.bottom, 50)
        
        renderBlogTabHeaders()
        renderBlogTabContent()
        
        Spacer()
      } //: VSTACK
      .padding(20)
      .safeAreaInset(edge: .top) {
        renderTitle()
      }
    }
  }
}

private extension ProfileView {
  @ViewBuilder
  func renderTitle() -> some View {
    HStack {
      Text("label.profile")
        .font(.largeTitle.bold())
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
      Spacer()
      NavigationLink {
        Text("Notifications")
      } label: {
        Image(systemName: "bell.badge")
          .font(.title2)
          .foregroundColor(.text)
          .padding(5)
          .overlay {
            Circle()
              .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
          }
      } //: NAVIGATION LINK
      .padding(.horizontal, 20)
    } //: HSTACK
  }
  
  @ViewBuilder
  func renderTempUI() -> some View {
    List {
      Section {
        NavigationLink {
          ProfileImageSetupView()
        } label: {
          HStack {
            Image(systemName: "person.crop.circle.fill")
              .foregroundStyle(.brand)
            Text("Upload profile image")
          } //: HSTACK
        } //: NAVIGATION LINK
      } //: SECTION
      
      Section {
        Text("Developed by Filip Kisic")
        Text("Gearbox, Comsysto Reply")
          .font(.caption)
      } //: SECTION
    } //: LIST
  }
  
  @ViewBuilder
  func renderBlogTabHeaders() -> some View {
    HStack {
      Button {
        withAnimation {
          selectedTabIndex = 0
        }
      } label: {
        Text("My Blogs")
          .frame(maxWidth: .infinity)
      }
      .foregroundStyle(selectedTabIndex == 0 ? .brand : .text)
      
      Button {
        withAnimation {
          selectedTabIndex = 1
        }
      } label: {
        Text("Liked")
          .frame(maxWidth: .infinity)
      }
      .foregroundStyle(selectedTabIndex == 1 ? .brand : .text)
    } //: HSTACK
    .overlay(alignment: .bottom) {
      ZStack {
        Rectangle()
          .fill(.gray)
          .frame(width: .infinity, height: 1)
          .offset(y: 16)
        
        GeometryReader { geometry in
          Rectangle()
            .fill(.brand)
            .frame(height: 3)
            .matchedGeometryEffect(id: "underline", in: animation)
            .frame(width: geometry.size.width / 2)
            .offset(x: CGFloat(selectedTabIndex) * (geometry.size.width / 2), y: 25)
            .animation(.easeInOut(duration: 0.3), value: selectedTabIndex)
        }
      }
    } //: OVERLAY RECTANGLE
  }
  
  @ViewBuilder
  func renderBlogTabContent() -> some View {
    TabView(selection: $selectedTabIndex) {
      Text("My Blogs")
        .tag(0)
      
      Text("Liked Blogs")
        .tag(1)
    } //: TAB VIEW
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

#Preview {
  NavigationStack {
    ProfileView()
  }
}
