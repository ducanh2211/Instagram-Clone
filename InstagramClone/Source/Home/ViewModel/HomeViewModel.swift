//
//  HomeViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/04/2023.
//

import Foundation

class HomeViewModel {
  let user: User
  
  init(user: User) {
    self.user = user
    print(user)
  }
}
