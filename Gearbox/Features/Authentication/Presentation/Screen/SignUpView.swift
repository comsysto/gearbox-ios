//
//  SignUpView.swift
//  Gearbox
//
//  Created by Filip Kisić on 28.07.2024..
//

import SwiftUI

struct SignUpView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var viewModel: SignUpViewModel
  
  @FocusState private var focusedField: FocusedField?
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color(.background)
        .edgesIgnoringSafeArea(.all)
      
      VStack (alignment: .leading) {
        // MARK: - HEADING
        Text("authentication.sign-up.title")
          .font(Font.custom("RobotoCondensed-Bold", size: 28))
          .padding(.top, 20)
        Text("authentication.sign-up.subtitle")
          .font(.system(size: 16, design: .rounded))
          .padding(.bottom, 20)
        
        GearboxTextField(
          "label.email",
          text: $viewModel.state.email,
          type: .email,
          validate: { FormValidator.validate(viewModel.state.email, for: .email) }
        )
        .focused($focusedField, equals: .email)
        .submitLabel(.next)
        
        GearboxTextField(
          "label.username",
          text: $viewModel.state.username,
          type: .username,
          validate: { FormValidator.validate(viewModel.state.username, for: .username) }
        )
        .focused($focusedField, equals: .username)
        .submitLabel(.next)
        
        GearboxTextField(
          "label.password",
          text: $viewModel.state.password,
          type: .password,
          validate: { FormValidator.validate(viewModel.state.password, for: .passwordObeyPolicy) }
        )
        .focused($focusedField, equals: .password)
        .submitLabel(.next)
        
        GearboxTextField(
          "label.confirm-password",
          text: $viewModel.state.confirmPassword,
          type: .password,
          validate: { FormValidator.validate(viewModel.state.password, for: .passwordObeyPolicy) }
        )
        .focused($focusedField, equals: .confirmPassword)
        .submitLabel(.done)
        
        Spacer()
          .frame(minHeight: 20, idealHeight: 20, maxHeight: 30)
          .fixedSize()
        
        // MARK: - ACTION
        GearboxLargeButton(
          label: "authentication.sign-up",
          isLoading: $viewModel.state.isLoading
        ) { signUp() }
        
        Spacer()
        
        // MARK: - FOOTER
        HStack() {
          Spacer()
          Text("authentication.no-account.sign-in.label")
            .font(.system(size: 16, design: .rounded))
          Button {
            router.navigateBack()
          } label: {
            Text("authentication.no-account.sign-in.action")
              .foregroundStyle(Color.brand)
              .font(.system(size: 16, weight: .bold, design: .rounded))
          }
          Spacer()
        } //: HSTACK
      } //: VSTACK
      .padding()
      .onSubmit(handleOnSubmit)
      .onChange(of: viewModel.state.authState, perform: handleStateChange)
      .alert(isPresented: $viewModel.state.isErrorShown) {
        Alert(
          title: Text("error.title"),
          message: Text(LocalizedStringKey(viewModel.state.errorMessage)),
          dismissButton: .default(Text("ok"))
        )
      }
    } //: ZSTACK
    .navigationBarBackButtonHidden()
  }
  
  // MARK: - FUNCTIONS
  private func signUp() {
    focusedField = nil
    viewModel.signUp()
  }
  
  private func handleOnSubmit() {
    switch focusedField {
      case .email:
        focusedField = .username
      case .username:
        focusedField = .password
      case .password:
        focusedField = .confirmPassword
      case .confirmPassword:
        focusedField = nil
        signUp()
      case nil:
        break
    }
  }
  
  private func handleStateChange(state: SignUpAuthState) {
    if state == .authenticated {
      router.navigateTo(.home)
    }
  }
}

// MARK: - PREVIEW
#Preview {
  SignUpView()
}

// MARK: - FOCUSED FIELD ENUM
private enum FocusedField {
  case email
  case username
  case password
  case confirmPassword
}
