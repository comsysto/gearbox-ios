//
//  GearboxTextField.swift
//  Gearbox
//
//  Created by Filip Kisić on 10.07.2024..
//

import SwiftUI

struct GearboxTextField: View {
  // MARK: - PROPERTIES
  let placeholder: String
  let type: InputType
  
  @Binding var text: String
  
  @State private var errorMessage: String = .empty()
  
  // MARK: - INITIALIZER
  init(_ placeholder: String, text: Binding<String>, type: InputType) {
    self.placeholder = placeholder
    self._text = text
    self.type = type
  }
  
  // MARK: - BODY
  var body: some View {
    VStack(alignment: .leading) {
      if type == .password {
        SecureField(LocalizedStringKey(placeholder), text: $text)
          .modifier(GearboxInputFieldModifier())
          .onChange(of: text, validate)
          .keyboardType(getKeyboardType())
          .textContentType(getTextContentType())
      } else {
        TextField(LocalizedStringKey(placeholder), text: $text)
          .modifier(GearboxInputFieldModifier())
          .onChange(of: text, validate)
          .keyboardType(getKeyboardType())
          .textContentType(getTextContentType())
      }
      
      Text(LocalizedStringKey(errorMessage))
        .font(.system(size: 12, design: .rounded))
        .foregroundStyle(.error)
        .padding(.leading)
    } //: VSTACK
  }
  
  // MARK: - FUNCTIONS
  private func validate() {
    switch type {
      case .email:
        errorMessage = text.validateAsEmail() ?? .empty()
      case .password:
        errorMessage = text.validateAsPassword() ?? .empty()
      case .username:
        errorMessage = text.validateAsUsername() ?? .empty()
    }
  }
  
  private func getKeyboardType() -> UIKeyboardType {
    return switch type {
      case .email:
          .emailAddress
      case .password:
          .asciiCapable
      case .username:
          .default
    }
  }
  
  private func getTextContentType() -> UITextContentType? {
    return switch type {
      case .email:
          .emailAddress
      case .password:
          .password
      default:
        nil
    }
  }
}

// MARK: - VIEW MODIFIER
struct GearboxInputFieldModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .overlay(
        RoundedRectangle(cornerRadius: 7)
          .stroke(Color.text, lineWidth: 1)
      )
      .textFieldStyle(RoundedGearboxTextStyle())
      .autocorrectionDisabled()
      .textInputAutocapitalization(.never)
  }
}

// MARK: - TEXT FIELD STYLE
struct RoundedGearboxTextStyle: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(15)
      .background(Color.background)
  }
}

// MARK: - PREVIEW
#Preview(traits: .sizeThatFitsLayout) {
  @State var text: String = ""
  return GearboxTextField("label.email", text: $text, type: .email).padding(10)
}

enum InputType {
  case email, password, username
}
