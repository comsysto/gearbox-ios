//
//  SignInView.swift
//  Gearbox
//
//  Created by Filip Kisić on 08.07.2024..
//

import SwiftUI
import GearboxDatasource

struct SignInView: View {
  // MARK: - PROPERTIES
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var userViewModel: UserViewModel
  
  @State private var email: String = ""
  @State private var password: String = ""
  
  @State private var isLoading: Bool = false
  @State private var isErrorShown: Bool = false
  @State private var errorMessage: String = ""
  
  @FocusState private var focusedField: FocusedField?
  
  // MARK: - BODY
  var body: some View {
    ZStack {
      Color(.background)
        .edgesIgnoringSafeArea(.all)
      
      VStack (alignment: .leading) {
        // MARK: - HEADING
        Text("authentication.sign-in.title")
          .font(Font.custom("RobotoCondensed-Bold", size: 28))
          .padding(.top, 20)
        Text("authentication.sign-in.subtitle")
          .font(.system(size: 16, design: .rounded))
        
        Spacer()
          .frame(minHeight: 20, idealHeight: 60, maxHeight: 100)
          .fixedSize()
        
        // MARK: - INPUT
        GearboxTextField("label.email", text: $email, type: .email)
          .focused($focusedField, equals: .email)
          .submitLabel(.next)
        
        GearboxTextField("label.password", text: $password, type: .password)
          .focused($focusedField, equals: .password)
          .submitLabel(.done)
        
        
        Spacer()
          .frame(minHeight: 20, idealHeight: 40, maxHeight: 100)
          .fixedSize()
        
        // MARK: - ACTION
        GearboxLargeButton(label: "authentication.sign-in", isLoading: $isLoading) {
          signIn()
        }
        
        Spacer()
        
        // MARK: - FOOTER
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
      } //: VSTACK
      .padding()
      .onSubmit(handleOnSubmit)
      .onChange(of: userViewModel.authenticationState, perform: handleStateChange)
      // MARK: - ERROR ALERT
      .alert(isPresented: $isErrorShown) {
        Alert(
          title: Text("error.title"),
          message: Text(LocalizedStringKey(errorMessage)),
          dismissButton: .default(Text("ok"))
        )
      }
    } //: ZSTACK
  }
  
  // MARK: - FUNCTIONS
  private func signIn() {
    focusedField = nil
    
    if isInputValid() {
      Task {
        await userViewModel.signIn(email: email, password: password)
      }
    }
  }
  
  private func isInputValid() -> Bool {
    return email.validateAsEmail() == nil && password.validateAsPassword() == nil
  }
  
  private func handleOnSubmit() {
    focusedField == .email ? focusedField = .password : signIn()
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
  SignInView()
}

// MARK: - FOCUSED FIELD ENUM
private enum FocusedField {
  case email
  case password
}
