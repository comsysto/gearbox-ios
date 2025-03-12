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
  
  @State private var comments: [Comment] = [
    Comment(
      username: "@hansmuliner",
      text: "I can't wait to see this next generation Apple Car Play in my Jaguar",
      userImage: "person.circle.fill"
    ),
    Comment(
      username: "@tomtainor",
      text: "Honestly, I think this will be a huge feature for iPhone users. This has a potential to create your own car gauges and customize your dashboard to your liking. I hope that users will have that opportunity in the next gen.",
      userImage: "person.circle.fill"
    ),
    Comment(
      username: "@theresawalter",
      text: "I just hope that the dashboard won't be locked by brand.",
      userImage: "person.circle.fill"
    )
  ]
  
  // MARK: - BODY
  var body: some View {
    VStack {
      HStack(alignment: .center) {
        Text("label.comments")
          .font(.headline)
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
      ScrollView {
        VStack(spacing: 20) {
          ForEach(comments) { comment in
            renderCommentBox(comment)
          }
        } //: VSTACK
      } //: SCROLL VIEW
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
      }
      .padding()
      .overlay(
        RoundedRectangle(cornerRadius: 5)
          .stroke(.brand, lineWidth: 1)
      )
    } //VSTACK
    .padding(.horizontal, 20)
    .presentationBackground(.regularMaterial)
    .presentationCornerRadius(10)
  }
}

// MARK: - TEMPORARY STRUCT MODEL
struct Comment: Identifiable {
  let id = UUID()
  let username: String
  let text: String
  let userImage: String // SF Symbol name for user image
}

// MARK: - VIEW EXTENSIONS
private extension CommentSectionView {
  @ViewBuilder
  func renderCommentBox(_ comment: Comment) -> some View {
    HStack (alignment: .top) {
      Image(systemName: comment.userImage)
        .resizable()
        .scaledToFill()
        .frame(width: 30, height: 30)
        .clipShape(Circle())
      VStack (alignment: .leading) {
        Text(comment.username)
          .font(.caption2)
          .foregroundStyle(.gray)
        Text(comment.text)
          .font(.caption)
      } //:VSTACK
    } //: HSTACK
  }
}

// MARK: - PREVIEW
#Preview {
  let viewModel = BlogDetailsViewModel()
  ZStack {
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
