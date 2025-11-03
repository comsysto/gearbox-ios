//
//  BlogDetailsState.swift
//  Gearbox
//
//  Created by Filip Kisić on 21.02.2025..
//

struct BlogDetailsState: Equatable {
  var blog: Blog?
  var isSheetPresented: Bool = false
  
  var commentList: [Comment] = []
  var isLoadingComments: Bool = false
  var isLoadingMore: Bool = false
  
  var errorMessage: String = ""
}
