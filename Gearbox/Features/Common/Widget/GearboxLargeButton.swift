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
  var isLoading: Bool = false
  let action: () -> Void
  
  init(label: String, isLoading: Bool = false, action: @escaping () -> Void) {
    self.label = label
    self.isLoading = isLoading
    self.action = action
  }
  
  // MARK: - BODY
  var body: some View {
    Button {
      action()
    } label: {
      if isLoading {
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
    .disabled(isLoading)
  }
}

// MARK: - PREVIEW
#Preview {
  GearboxLargeButton(label: "button.next", isLoading: true) {
    print("Button pressed!")
  }
  .padding()
}
