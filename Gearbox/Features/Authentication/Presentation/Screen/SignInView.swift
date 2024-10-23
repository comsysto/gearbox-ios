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
  @EnvironmentObject private var viewModel: SignInViewModel
  
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
        GearboxTextField("label.email", text: $viewModel.state.email, type: .email)
          .focused($focusedField, equals: .email)
          .submitLabel(.next)
        
        GearboxTextField("label.password", text: $viewModel.state.password, type: .password)
          .focused($focusedField, equals: .password)
          .submitLabel(.done)
        
        
        Spacer()
          .frame(minHeight: 20, idealHeight: 40, maxHeight: 100)
          .fixedSize()
        
        // MARK: - ACTION
        GearboxLargeButton(label: "authentication.sign-in", isLoading: $viewModel.state.isLoading) {
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
  
  private func handleStateChange(newState: SignInAuthState) {
    if newState == .authenticated {
      router.navigateTo(.home)
    }
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
