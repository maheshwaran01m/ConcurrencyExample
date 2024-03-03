//
//  CustomTaskView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 02/03/24.
//

import SwiftUI

struct CustomTaskView: View {
  
  @StateObject private var viewModel = CustomTaskViewModel()
  
  var body: some View {
    VStack {
      if let image = viewModel.image {
        image
          .resizable()
          .scaledToFit()
          .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }
      
      if let image = viewModel.image1 {
        image
          .resizable()
          .scaledToFit()
          .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }
    }
  }
}

// MARK: - Preview

struct CustomTaskView_Previews: PreviewProvider {
  static var previews: some View {
    CustomTaskView()
  }
}

// MARK: - ViewModel

class CustomTaskViewModel: ObservableObject {
  
  @Published var image: Image?
  @Published var image1: Image?
  
  init() {
    fetchImage()
  }
  
  func fetchImage() {
    
    Task {
      print(Task.currentPriority)
      await getImage()
    }
    
    // .userInitiated, .high, medium, .low, .utility, .background
    Task(priority: .userInitiated) {
      await getImage1()
    }
  }
  
  func getImage() async {
    do {
      guard let url = URL(string: "https://picsum.photos/200") else {
        return
      }
      let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        await MainActor.run {
          self.image = .init(uiImage: image)
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func getImage1() async {
    do {
      guard let url = URL(string: "https://picsum.photos/200") else {
        return
      }
      let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        await MainActor.run {
          self.image1 = .init(uiImage: image)
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }
}
