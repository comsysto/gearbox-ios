//
//  ProfileView.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.11.2024..
//
import SwiftUI

struct ProfileView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var viewModel: ProfileViewModel
  
  @State private var selectedTabIndex: BlogFilterSelection = .postedBlogs
  @Namespace private var animation
  
  private let userId: String?
  private let profileImageSize = 100.0
  
  // MARK: - CONSTRUCTOR
  init(for userId: String? = nil) {
    self.userId = userId
  }
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      VStack {
        renderProfileHeader()
        
        renderAnimatedTabs()
        renderBlogTabContent()
        
        Spacer()
      } //: VSTACK
      .padding(20)
      .safeAreaInset(edge: .top) {
        renderTitle()
      }
      .onAppear() {
        viewModel.loadUserData(for: userId)
        viewModel.loadUserBlogs(for: userId)
      }
    } //: ZSTACK
  }
}

// MARK: - EXTENSIONS
private extension ProfileView {
  
  // MARK: - HEADER
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
  func renderProfileHeader() -> some View {
    VStack {
      renderProfileImage()
      
      if viewModel.state.isLoading {
        ShimmerView()
          .frame(width: 100, height: 30)
      } else if viewModel.state.errorMessage != nil {
        Text(LocalizedStringKey(viewModel.state.errorMessage!))
          .foregroundStyle(.error)
          .font(.title2)
          .padding(.bottom, 50)
      } else {
        if (viewModel.state.profileData?.username == nil) {
          Text("Username not found")
        } else {
          Text("@\(viewModel.state.profileData!.username)")
            .font(.title2)
            .padding(.bottom, 50)
        }
      }
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderProfileImage() -> some View {
    ZStack {
      if let url = viewModel.state.profileData?.profileImageUrl {
        AsyncImage(url: URL(string: url)) { phase in
          switch phase {
            case .empty:
              ShimmerProfileHeader()
            case .success(let image):
              image.resizable()
                .scaledToFill()
            case .failure(_):
              Image(systemName: "x.circle")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.error)
            @unknown default:
              ShimmerProfileHeader()
          }
        } //: ASYNC IMAGE
      } else {
        Image(systemName: "x.circle")
          .resizable()
          .scaledToFit()
          .foregroundStyle(.error)
      }
    } //: ZSTACK
    .frame(width: profileImageSize, height: profileImageSize)
    .clipShape(Circle())
  }
  
  @ViewBuilder
  func renderAnimatedTabs() -> some View {
    HStack {
      ForEach(BlogFilterSelection.allCases, id: \.rawValue) { item in
        VStack {
          Text(LocalizedStringKey(item.title))
            .font(.subheadline)
            .fontWeight(selectedTabIndex == item ? .bold : .regular)
            .foregroundStyle(selectedTabIndex == item ? .brand : .text)
          
          if selectedTabIndex == item {
            Capsule()
              .foregroundStyle(.brand)
              .frame(height: 3)
              .matchedGeometryEffect(id: "tab", in: animation)
          } else {
            Capsule()
              .foregroundStyle(.clear)
              .frame(height: 3)
          }
        } //: VSTACK
        .onTapGesture {
          withAnimation(.easeInOut) {
            self.selectedTabIndex = item
          }
        }
      } //: FOR EACH
    } //: HSTACK
    .overlay(Divider().offset(x: 0, y: 14))
  }
  
  @ViewBuilder
  func renderBlogTabContent() -> some View {
    TabView(selection: $selectedTabIndex) {
      ProfileBlogListView(
        blogs: viewModel.state.userBlogs,
        isLoading: viewModel.state.isLoadingBlogs,
        errorMessage: viewModel.state.errorMessage,
        emptyStateConfig: .postedBlogs
      )
      .tag(BlogFilterSelection.postedBlogs)
      
      ProfileBlogListView(
        blogs: viewModel.state.likedBlogs,
        isLoading: viewModel.state.isLoadingBlogs,
        errorMessage: viewModel.state.errorMessage,
        emptyStateConfig: .likedBlogs
      )
      .tag(BlogFilterSelection.likedBlogs)
    } //: TAB VIEW
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
}

// MARK: - SHIMMER VIEW
struct ShimmerProfileHeader: View {
  var body: some View {
    ShimmerView()
      .frame(width: 100, height: 100)
      .clipShape(Circle())
  }
}

// MARK: - PREVIEW
#Preview("Profile - loading") {
  let viewModel = ProfileViewModel()
  viewModel.state.isLoading = true
  viewModel.state.isLoadingBlogs = true
  viewModel.state.profileData = ProfileData(id: "", username: "filipkisic", profileImageUrl: "", isProfileOwner: true)
  
  return ZStack {
    NavigationStack {
      ProfileView()
    }
  }
  .environmentObject(viewModel)
}

#Preview("Profile - filled") {
  let viewModel = ProfileViewModel()
  viewModel.state.isLoading = false
  viewModel.state.isLoadingBlogs = false
  viewModel.state.profileData = ProfileData(id: "id", username: "filipkisic", profileImageUrl: "https://images.pexels.com/photos/839011/pexels-photo-839011.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", isProfileOwner: true)
  viewModel.state.userBlogs = mockBlogState()
  viewModel.state.errorMessage = nil
  
  return ZStack {
    NavigationStack {
      ProfileView()
    }
  }.environmentObject(viewModel)
}

#Preview("Profile - empty") {
  let viewModel = ProfileViewModel()
  viewModel.state.isLoading = false
  viewModel.state.isLoadingBlogs = false
  viewModel.state.profileData = ProfileData(id: "", username: "filipkisic", profileImageUrl: "https://images.pexels.com/photos/839011/pexels-photo-839011.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2", isProfileOwner: true)
  
  return ZStack{
    NavigationStack {
      ProfileView()
    }
  }.environmentObject(viewModel)
}

#Preview("Profile - error") {
  let viewModel = ProfileViewModel()
  viewModel.state.isLoading = false
  viewModel.state.isLoadingBlogs = false
  viewModel.state.errorMessage = "error.unknown"
  viewModel.state.profileData = ProfileData(id: "", username: "filipkisic", profileImageUrl: nil, isProfileOwner: true)
  
  return ZStack {
    NavigationStack {
      ProfileView()
    }
  }
  .environmentObject(viewModel)
}

private func mockBlogState() -> [Blog] {
  return [
    Blog(
      id: "1",
      title: "Blog #1",
      content: "Content #1",
      thumbnailImageUrl: "photo_icon",
      createDate: Date(),
      numberOfLikes: 13,
      category: "Technology",
      author: Author(id: "1", username: "@filipkisic", profileImageUrl: "photo_icon")
    ),
    Blog(
      id: "2",
      title: "Blog #2",
      content: "Content #2",
      thumbnailImageUrl: "photo_icon",
      createDate: Date(),
      numberOfLikes: 15,
      category: "Old Timer",
      author: Author(id: "1", username: "@filipkisic", profileImageUrl: "photo_icon")
    ),
    Blog(
      id: "3",
      title: "Blog #3",
      content: "Content #3",
      thumbnailImageUrl: "photo_icon",
      createDate: Date(),
      numberOfLikes: 3,
      category: "Concept",
      author: Author(id: "1", username: "@filipkisic", profileImageUrl: "photo_icon")
    ),
  ]
}
