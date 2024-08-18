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
  @EnvironmentObject private var userViewModel: UserViewModel
  
  @State private var email: String = ""
  @State private var username: String = ""
  @State private var password: String = ""
  @State private var confirmPassword: String = ""
  
  @State private var isLoading: Bool = false
  @State private var isErrorShown: Bool = false
  @State private var errorMessage: String = ""
  
  @FocusState private var focusedField: FocusedField?
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color(.background)
        .edgesIgnoringSafeArea(.all)
      
      VStack(alignment: .leading) {
        // MARK: - HEADING
        Text("authentication.sign-in.title")
          .font(Font.custom("RobotoCondensed-Bold", size: 28))
          .padding(.top, 20)
        Text("authentication.sign-in.subtitle")
          .font(.system(size: 16, design: .rounded))
          .padding(.bottom, 20)
        
        GearboxTextField("label.email", text: $email, type: .email)
          .focused($focusedField, equals: .email)
          .submitLabel(.next)
        
        GearboxTextField("label.username", text: $username, type: .username)
          .focused($focusedField, equals: .username)
          .submitLabel(.next)
        
        GearboxTextField("label.password", text: $password, type: .password)
          .focused($focusedField, equals: .password)
          .submitLabel(.next)
        
        GearboxTextField("label.confirm-password", text: $confirmPassword, type: .password)
          .focused($focusedField, equals: .confirmPassword)
          .submitLabel(.done)
        
        Spacer()
          .frame(minHeight: 20, idealHeight: 20, maxHeight: 30)
          .fixedSize()
        
        // MARK: - ACTION
        GearboxLargeButton(label: "authentication.sign-up", isLoading: $isLoading) {
          signUp()
        }
        
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
      .onChange(of: userViewModel.authenticationState, perform: handleStateChange)
      .alert(isPresented: $isErrorShown) {
        Alert(
          title: Text("error.title"),
          message: Text(LocalizedStringKey(errorMessage)),
          dismissButton: .default(Text("ok"))
        )
      }
    } //: ZSTACK
    .navigationBarBackButtonHidden()
  }
  
  // MARK: - FUNCTIONS
  private func signUp() {
    Task {
      await userViewModel.signUp(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword
      )
    }
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
  
  private func handleStateChange(state: AuthenticationState) {
    switch state {
      case .loading:
        isLoading = true
      case .authenticated(_):
        isLoading = false
        isErrorShown = false
        router.navigateTo(.home)
      case .unauthenticated(let error):
        isLoading = false
        isErrorShown = true
        setErrorMessage(error)
    }
  }
  
  private func setErrorMessage(_ error: AuthError?) {
    switch error {
      case .invalidRequest(let message),
          .userNotFound(let message),
          .userAlreadyExists(let message),
          .expiredToken(let message),
          .serverError(let message):
        errorMessage = message
      default:
        errorMessage = "error.unknown"
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
