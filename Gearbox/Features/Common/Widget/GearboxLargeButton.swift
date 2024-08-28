//
//  GearboxLargeButton.swift
//  Gearbox
//
//  Created by Filip Kisić on 12.07.2024..
//

import SwiftUI

struct GearboxLargeButton: View {
  // MARK: - PROPERTIES
  let label: String
  var isLoading: Binding<Bool>
  let action: () -> Void
  
  init(
    label: String,
    isLoading: Binding<Bool> = .constant(false),
    action: @escaping () -> Void
  ) {
    self.label = label
    self.isLoading = isLoading
    self.action = action
  }
  
  // MARK: - BODY
  var body: some View {
    Button {
      action()
    } label: {
      if isLoading.wrappedValue {
        ProgressView()
          .progressViewStyle(.circular)
          .tint(.white)
          .scaleEffect(1.2, anchor: .center)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 18)
      } else {
        Text(LocalizedStringKey(label))
          .frame(maxWidth: .infinity)
          .font(Font.custom("RobotoCondensed-Bold", size: 20))
          .foregroundStyle(.white)
          .padding(.vertical)
          .padding(.horizontal, 40)
      }
    }
    .background(Color.brand)
    .cornerRadius(7)
    .shadow(color: .brand.opacity(0.25), radius: 5, x: 0, y: 5)
    .disabled(isLoading.wrappedValue)
  }
}

// MARK: - PREVIEW
#Preview {
  @State var isLoading = false
  
  return GearboxLargeButton(label: "button.next", isLoading: $isLoading) {
    print("Button pressed!")
  }
  .padding()
}
