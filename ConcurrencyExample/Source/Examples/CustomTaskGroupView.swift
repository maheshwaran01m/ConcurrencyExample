//
//  CustomTaskGroupView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

struct CustomTaskGroupView: View {
  
  @StateObject private var viewModel = CustomTaskGroupViewModel()
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: viewModel.columns) {
          ForEach(viewModel.images, id: \.self) { image in
           Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .frame(height: 100)
          }
        }
      }
      .navigationTitle("Task Group")
      .onAppear(perform: fetchImages)
    }
  }
  
  private func fetchImages() {
    Task {
      await viewModel.fetchImages()
    }
  }
}

// MARK: - URL

let imageURL = URL(string: "https://picsum.photos/200")!

// MARK: - Preview

struct CustomTaskGroupView_Previews: PreviewProvider {
  static var previews: some View {
    CustomTaskGroupView()
  }
}

// MARK: - ViewModel

fileprivate class CustomTaskGroupViewModel: ObservableObject {
  
  @Published var images = [UIImage]()
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  let manager = CustomTaskGroupManager()
  
  func fetchImages() async {
    if let images = try? await manager.fetchImagesUsingTaskGroup() {
      self.images.append(contentsOf: images)
    }
  }
}

// MARK: - Manager

fileprivate class CustomTaskGroupManager {
  
  
  private func downloadImage(url: URL? = imageURL) async throws -> UIImage {
    
    guard let url else {
      throw URLError(.badURL)
    }
     let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        return image
      } else {
        throw URLError(.badServerResponse)
      }
  }
  
  // async Let
  func fetchImagesUsingAsyncLet() async throws -> [UIImage] {
      async let image1 = downloadImage()
      async let image2 = downloadImage()
      async let image3 = downloadImage()
      async let image4 = downloadImage()
      
      let (one, two, three, four) = await (try image1, try image2, try image3, try image4)
      
      return [one, two, three, four]
  }
  
  // Task group
  
  func fetchImagesUsingTaskGroup() async throws -> [UIImage] {
    
    return try await withThrowingTaskGroup(of: UIImage?.self) { group in
      
      var images = [UIImage]()
      images.reserveCapacity(11) // performance boost
      
      for _ in 0...10 {
        group.addTask {
          try? await self.downloadImage()
        }
      }
      
      for try await image in group {
        if let image {
          images.append(image)
        }
      }
      
      return images
    }
  }
}
