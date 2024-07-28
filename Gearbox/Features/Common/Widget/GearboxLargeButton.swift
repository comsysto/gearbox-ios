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
  let action: () -> Void
  
  // MARK: - BODY
  var body: some View {
    Button {
      action()
    } label: {
      Text(LocalizedStringKey(label))
        .frame(maxWidth: .infinity)
        .font(Font.custom("RobotoCondensed-Bold", size: 20))
        .foregroundStyle(.white)
        .padding(.vertical)
        .padding(.horizontal, 40)
    }
    .background(Color.brand)
    .cornerRadius(7)
    .shadow(color: .brand.opacity(0.25), radius: 5, x: 0, y: 5)
  }
}

// MARK: - PREVIEW
#Preview {
  GearboxLargeButton(label: "button.next") {
    print("Button pressed!")
  }
  .padding()
}
