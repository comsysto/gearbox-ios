//
//  CommentSection.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.02.2025..
//

import SwiftUI

struct CommentSectionView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var viewModel: BlogDetailsViewModel
  
  private let imageCache: ImageCacheManagerType = ImageNSCacheManager.shared
  
  // MARK: - BODY
  var body: some View {
    VStack {
      renderHeader()
      
      if (viewModel.state.commentList.isEmpty) {
        renderEmptyState()
      } else {
        renderCommentList()
      }
      
      renderInput()
    } //VSTACK
    .padding(.horizontal, 20)
    .presentationBackground(.regularMaterial)
    .presentationCornerRadius(10)
  }
}

// MARK: - VIEW EXTENSIONS
private extension CommentSectionView {
  
  @ViewBuilder
  func renderHeader() -> some View {
    HStack(alignment: .center) {
      Text("label.comments")
        .font(.title3)
        .fontWeight(.bold)
      Spacer()
      Button {
        viewModel.state.isSheetPresented.toggle()
      } label: {
        Image(systemName: "arrow.down.circle")
          .resizable()
          .frame(width: 25, height: 25)
          .foregroundStyle(.gray)
      }
    } //: HSTACK
    .padding(.top, 20)
  }
  
  @ViewBuilder
  func renderEmptyState() -> some View {
    VStack {
      Spacer()
      Image("gearbox_logo")
        .resizable()
        .frame(width: 45, height: 45)
        .foregroundStyle(.secondary)
        .padding(.bottom, 5)
      Text("blog.details.comments.empty.title")
        .font(.custom("RobotoCondensed-Bold", size: 18))
      Text("blog.details.comments.empty.description")
        .font(.footnote)
        .multilineTextAlignment(.center)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
      Spacer()
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderCommentList() -> some View {
    if viewModel.state.isLoadingComments {
      VStack {
        Spacer()
        ProgressView()
        Spacer()
      } //: VSTACK
    } else {
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 20) {
          ForEach(0..<viewModel.state.commentList.count, id: \.self) { index in
            renderCommentBox(at: index)
          } //: FOR EACH
          
          if viewModel.state.isLoadingMore {
            ProgressView().padding()
          }
        } //: LAZY VSTACK
      } //: SCROLL VIEW
    }
  }
  
  @ViewBuilder
  func renderCommentBox(at index: Int) -> some View {
    let comment = viewModel.state.commentList[index]
    
    HStack (alignment: .top) {
      renderProfileImage(for: comment)
      
      VStack (alignment: .leading) {
        Text("@\(comment.username)")
          .font(.caption2)
          .foregroundStyle(.gray)
        Text(comment.content)
          .font(.caption)
      } //:VSTACK
    } //: HSTACK
    .onAppear {
      if index == viewModel.state.commentList.count - 1 {
        viewModel.loadComments(loadMore: true)
      }
    }
  }
  
  @ViewBuilder
  func renderProfileImage(for comment: Comment) -> some View {
    let image = {
      if let url = comment.profileImageUrl, let cachedImage = imageCache.load(forKey: url) {
        return Image(uiImage: cachedImage)
      }
      return Image(systemName: "person.circle.fill")
    }()
    
    image
      .resizable()
      .scaledToFill()
      .frame(width: 30, height: 30)
      .clipShape(Circle())
  }
  
  @ViewBuilder
  func renderInput() -> some View {
    HStack {
      Image(systemName: "person.circle.fill")
        .resizable()
        .frame(width: 25, height: 25)
        .foregroundStyle(.brand)
      TextField("placeholder.comment", text: .constant(""))
      Spacer()
      Button {
        //TODO: Add send action
      } label: {
        Image(systemName: "paperplane.fill")
          .foregroundColor(.brand)
      }
    } //: HSTACK
    .padding()
    .overlay(
      RoundedRectangle(cornerRadius: 5)
        .stroke(.brand, lineWidth: 1)
    )
  }
}

// MARK: - PREVIEW
#Preview {
  let viewModel = BlogDetailsViewModel()
  viewModel.state.commentList = [
    Comment(
      id: "1",
      blogId: "1",
      userId: "@hansmuliner",
      username: "@hansmuliner",
      profileImageUrl: nil,
      content: "I can't wait to see this next generation Apple Car Play in my Jaguar",
    ),
    Comment(
      id: "2",
      blogId: "2",
      userId: "@tomtainor",
      username: "@tomtainor",
      profileImageUrl: nil,
      content: "Honestly, I think this will be a huge feature for iPhone users. This has a potential to create your own car gauges and customize your dashboard to your liking. I hope that users will have that opportunity in the next gen.",
    ),
    Comment(
      id: "3",
      blogId: "3",
      userId: "@theresawalter",
      username: "@theresawalter",
      profileImageUrl: nil,
      content: "I just hope that the dashboard will be customizable.",
    ),
    Comment(
      id: "4",
      blogId: "3",
      userId: "@theresawalter",
      username: "@theresawalter",
      profileImageUrl: nil,
      content: "I just hope that the dashboard will be customizable.",
    ),
    Comment(
      id: "5",
      blogId: "3",
      userId: "@theresawalter",
      username: "@theresawalter",
      profileImageUrl: nil,
      content: "I just hope that the dashboard will be customizable.",
    ),
    Comment(
      id: "6",
      blogId: "3",
      userId: "@theresawalter",
      username: "@theresawalter",
      profileImageUrl: nil,
      content: "I just hope that the dashboard will be customizable.",
    )
  ]
  
  return ZStack {
    VStack {
      
    }
    .sheet(isPresented: .constant(true)) {
      CommentSectionView()
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents([.medium, .fraction(0.75), .fraction(1.0)])
        .presentationDragIndicator(.visible)
    }
  }
  .environmentObject(viewModel)
}
