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
  @EnvironmentObject var router: Router
  @StateObject private var userViewModel = UserViewModel()
  
  @State private var email: String = ""
  @State private var password: String = ""
  
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
        GearboxLargeButton(label: "authentication.sign-in", isLoading: isLoading()) {
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
    } //: ZSTACK
  }
  
  // MARK: - FUNCTIONS
  private func isLoading() -> Bool {
    if case .loading = userViewModel.authenticationState {
      return true
    }
    return false
  }
  
  private func signIn() {
    focusedField = nil
    if isInputValid() {
      Task {
        //await sign in response from API
        await userViewModel.signIn(email: email, password: password)
      }
      print("Sign in action pressed!")
      //redirect to Main screen
    }
  }
  
  private func isInputValid() -> Bool {
    return email.validateAsEmail() == nil && password.validateAsPassword() == nil
  }
  
  private func handleOnSubmit() {
    focusedField == .email ? focusedField = .password : signIn()
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
