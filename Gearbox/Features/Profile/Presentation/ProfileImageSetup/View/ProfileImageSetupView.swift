//
//  ProfileImageSetupView.swift
//  Gearbox
//
//  Created by Filip Kisić on 03.04.2025..
//

import SwiftUI
import PhotosUI

struct ProfileImageSetupView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var viewModel: ProfileImageSetupViewModel
  @State private var photosPickerItem: PhotosPickerItem?
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color(.background)
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        renderTitle()
          .padding(.bottom, 50)
        
        if (viewModel.state.profileImage == nil) {
          renderImagePicker()
        } else {
          renderChosenImage()
        }
        
        Spacer()
        
        GearboxLargeButton(label: "profile.label.upload-image") {
          print("Image submitted")
        }
      } //: VSTACK
      .frame(minWidth:0, maxWidth: .infinity)
      .padding(20)
      .onChange(of: photosPickerItem) {
        Task {
          viewModel.state.profileImage = try? await photosPickerItem?.loadTransferable(type: Data.self)
        }
      }
    } //: ZSTACK
  }
}

private extension ProfileImageSetupView {
  @ViewBuilder
  func renderTitle() -> some View {
    VStack(alignment: .leading) {
      Text("profile.image-setup.title")
        .font(Font.custom("RobotoCondensed-Bold", size: 28))
      Text("profile.image-setup.description")
        .font(.footnote)
    } //: VSTACK
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  func renderImagePicker() -> some View {
    VStack {
      PhotosPicker(selection: $photosPickerItem, matching: .images) {
        Circle()
          .fill(.brand)
          .overlay{
            Image(systemName: "person.circle")
              .resizable()
              .scaledToFit()
              .frame(width: 65, height: 65)
              .foregroundStyle(Color.white)
          }
          .frame(width: 200, height: 200)
      }
      
      Text("profile.label.empty.placeholder.title")
        .font(Font.custom("RobotoCondensed-Bold", size: 20))
        .padding(.vertical, 5)
      
      Text("profile.label.empty.placeholder.description")
        .font(.footnote)
        .multilineTextAlignment(.center)
        .frame(maxWidth: 250)
    } //: VSTACK
  }
  
  @ViewBuilder
  func renderChosenImage() -> some View {
    VStack {
      PhotosPicker(selection: $photosPickerItem, matching: .images) {
        Circle()
          .overlay{
            Image(uiImage: UIImage(data: viewModel.state.profileImage!)!)
              .resizable()
              .scaledToFill()
              .frame(width: 200, height: 200)
              .clipShape(Circle())
          }
          .frame(width: 200, height: 200)
      }
      
      Text("profile.label.filled.title")
        .font(Font.custom("RobotoCondensed-Bold", size: 20))
        .padding(.vertical, 5)
    } //: VSTACK
  }
}

// MARK: - PREVIEW
#Preview {
  ProfileImageSetupView()
    .environmentObject(ProfileImageSetupViewModel())
}
