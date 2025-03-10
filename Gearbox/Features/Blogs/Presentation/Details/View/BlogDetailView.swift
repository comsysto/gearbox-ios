//
//  BlogDetailView.swift
//  Gearbox
//
//  Created by Filip Kisić on 26.11.2024..
//

import SwiftUI

struct BlogDetailView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var viewModel: BlogDetailsViewModel
  
  private let imageCache: ImageCacheManagerType = ImageNSCacheManager.shared
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      ScrollView {
        VStack(alignment: .leading) {
          renderUser()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
          renderBlogHeader()
            .padding(.horizontal, 20)
          renderBlogContent()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
      } //: SCROLL VIEW
      .scrollIndicators(.hidden)
      .safeAreaInset(edge: .top) {
        renderNavigationBar()
      }
      .safeAreaInset(edge: .bottom) {
        renderBottomActionBar()
      }
      .sheet(isPresented: $viewModel.state.isSheetPresented) {
        CommentSectionView()
          .presentationBackgroundInteraction(.enabled)
          .presentationDetents([.medium, .fraction(0.75), .fraction(1.0)])
          .presentationDragIndicator(.visible)
      }
    } //: ZSTACK
    .navigationBarBackButtonHidden(true)
  }
}

// MARK: - VIEW EXTENSIONS
private extension BlogDetailView {
  // MARK: - NAV BAR
  @ViewBuilder
  func renderNavigationBar() -> some View {
    HStack {
      Image(systemName: "arrow.left")
        .resizable()
        .scaledToFit()
        .frame(width: 22)
        .foregroundStyle(.text)
        .onTapGesture {
          router.navigateBack()
        }
      Text("label.back")
        .font(.footnote)
      Spacer()
    } //: HSTACK
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(.thinMaterial)
  }
  
  @ViewBuilder
  func renderUser() -> some View {
    HStack {
      Image("onboarding_third")
        .resizable()
        .scaledToFit()
        .frame(width: 35)
        .clipShape(Circle())
      Text("@\(viewModel.state.blog!.author.username)")
        .font(.caption)
        .foregroundStyle(.gray)
      Spacer()
    } //: HSTACK
  }
  
  // MARK: - BLOG CONTENT
  @ViewBuilder
  func renderBlogHeader() -> some View {
    VStack(alignment: .leading) {
      Text(viewModel.state.blog!.title)
        .font(Font.custom("RobotoCondensed-Bold", size: 28))
        .frame(maxWidth: 353, maxHeight: 70, alignment: .leading)
        .truncationMode(.tail)
        .padding(.bottom, 15)
      
      if let cachedImage = imageCache.load(forKey: viewModel.state.blog!.thumbnailImageUrl) {
        Image(uiImage: cachedImage)
          .resizable()
          .scaledToFill()
          .frame(maxHeight: 200)
          .clipShape(RoundedRectangle(cornerRadius: 5))
      } else {
        Image("photo_icon")
          .resizable()
          .scaledToFit()
          .frame(maxHeight: 200)
          .clipShape(RoundedRectangle(cornerRadius: 5))
      }
      
      HStack {
        Image(systemName: "clock")
          .font(.caption)
          .offset(x:5)
          .foregroundStyle(.gray)
        Text(viewModel.state.blog!.createDate.formatAsTimePassed())
          .font(.caption2)
          .foregroundStyle(.gray)
        
        Spacer()
          .frame(width: 30)
        
        Text(viewModel.state.blog!.category)
          .font(.caption2)
          .foregroundStyle(.gray)
      } //: HSTACK
      .padding(.top, 5)
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderBlogContent() -> some View {
    Text(viewModel.state.blog!.content)
      .font(.system(size: 14))
      .multilineTextAlignment(.leading)
  }
  
  // MARK: - BOTTOM ACTION BAR VIEWS
  @ViewBuilder
  func renderBottomActionBar() -> some View {
    HStack (alignment: .center) {
      renderActionButton(imageName: "gearshape", label: "14") {
        print("Like pressed!")
      }
      renderActionButton(imageName: "ellipsis.bubble", label: "3") {
        viewModel.state.isSheetPresented.toggle()
      }
      Spacer()
      renderActionButton(imageName: "bookmark") {
        print("Bookmark pressed!")
      }
    } //: HSTACK
    .padding(.vertical, 10)
    .padding(.horizontal, 20)
    .background(.regularMaterial)
    .presentationCornerRadius(10)
  }
  
  @ViewBuilder
  func renderActionButton(imageName: String, label: String? = nil, action: @escaping () -> Void) -> some View {
    Button {
      action()
    } label: {
      if (label != nil) {
        HStack (alignment: .center) {
          Image(systemName: imageName)
            .foregroundColor(.gray)
          Text(label!)
            .font(.caption)
            .foregroundStyle(.gray)
        } //: HSTACK
      } else {
        Image(systemName: imageName)
          .foregroundColor(.gray)
      }
    }
    .buttonStyle(.borderedProminent)
    .tint(Color.background)
    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
  }
}

// MARK: - PREVIEW
#Preview {
  let viewModel = BlogDetailsViewModel()
  let blog = Blog(
    id: "",
    title: "Next generation Apple Car Play integration started",
    content: "",
    thumbnailImageUrl: "trending_placeholder",
    createDate: Date().addingTimeInterval(-3600),
    numberOfLikes: 13,
    category: "Technology",
    author: Author(id: "", username: "filipkisic", profileImageUrl: nil)
  )
  ZStack {
    NavigationView {
      BlogDetailView()
    }
  }
  .environmentObject(viewModel)
}
