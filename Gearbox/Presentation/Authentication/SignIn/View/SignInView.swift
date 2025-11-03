//
//  SignInView.swift
//  Gearbox
//
//  Created by Filip Kisić on 08.07.2024.
//

import SwiftUI

struct SignInView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var viewModel: SignInViewModel
  
  @FocusState private var focusedField: FocusedField?
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color(.background)
        .edgesIgnoringSafeArea(.all)
      
      VStack (alignment: .leading) {
        header()
        
        Spacer()
          .frame(minHeight: 20, idealHeight: 60, maxHeight: 100)
          .fixedSize()
        
        textInput()
        
        Spacer()
          .frame(minHeight: 20, idealHeight: 40, maxHeight: 100)
          .fixedSize()
        
        GearboxLargeButton(
          label: "authentication.sign-in",
          isLoading: $viewModel.state.isLoading
        ) { signIn() }
        
        Spacer()
        
        footer()
      } //: VSTACK
      .padding()
      .onSubmit(handleOnSubmit)
      .onChange(of: viewModel.state.authState, perform: handleStateChange)
      // MARK: - ERROR ALERT
      .alert(isPresented: $viewModel.state.isErrorShown) {
        Alert(
          title: Text("error.title"),
          message: Text(LocalizedStringKey(viewModel.state.errorMessage)),
          dismissButton: .default(Text("ok"))
        )
      } //: ALERT
    } //: ZSTACK
    .navigationBarBackButtonHidden()
  }
  
  // MARK: - FUNCTIONS
  private func signIn() {
    focusedField = nil
    viewModel.signIn()
  }
  
  private func handleOnSubmit() {
    focusedField == .email ? focusedField = .password : signIn()
  }
  
  private func handleStateChange(state: SignInAuthState) {
    if state == .authenticated {
      router.navigateTo(.home)
    }
  }
}

private extension SignInView {
  @ViewBuilder
  func header() -> some View {
    Text("authentication.sign-in.title")
      .font(Font.custom("RobotoCondensed-Bold", size: 28))
      .padding(.top, 20)
    Text("authentication.sign-in.subtitle")
      .font(.system(size: 16, design: .rounded))
  }
  
  @ViewBuilder
  func textInput() -> some View {
    GearboxTextField(
      "label.email",
      text: $viewModel.state.email,
      type: .email,
      validate: { FormValidator.validate(viewModel.state.email, for: .email) }
    )
    .focused($focusedField, equals: .email)
    .submitLabel(.next)
    
    GearboxTextField(
      "label.password",
      text: $viewModel.state.password,
      type: .password,
      validate: { FormValidator.validate(viewModel.state.password, for: .passwordObeyPolicy) }
    )
    .focused($focusedField, equals: .password)
    .submitLabel(.done)
  }
  
  @ViewBuilder
  func footer() -> some View {
    HStack() {
      Spacer()
      Text("authentication.no-account.sign-up.label")
        .font(.system(size: 16, design: .rounded))
      Button {
        router.navigateTo(.signUp)
      } label: {
        Text("authentication.no-account.sign-up.action")
          .foregroundStyle(Color.brand)
          .font(.system(size: 16, weight: .bold, design: .rounded))
      }
      Spacer()
    } //: HSTACK
  }
}

// MARK: - PREVIEW
#Preview {
  var router = Router()
  var viewModel = SignInViewModel()
  ZStack {
    SignInView()
  }.environmentObject(router)
    .environmentObject(viewModel)
}

// MARK: - FOCUSED FIELD ENUM
private enum FocusedField {
  case email
  case password
}
