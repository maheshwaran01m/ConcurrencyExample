//
//  CustomContinuationView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

struct CustomContinuationView: View {
  
  @StateObject private var viewModel = CustomContinuationViewModel()
  
  var body: some View {
    VStack {
      if let image = viewModel.image {
        image
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }
    }
    .task {
      await viewModel.getImage()
    }
  }
}

// MARK: - Preview

struct CustomContinuationView_Previews: PreviewProvider {
  static var previews: some View {
    CustomContinuationView()
  }
}

// MARK: - CustomContinuationViewModel

fileprivate class CustomContinuationViewModel: ObservableObject {
  
  @Published var image: Image?
  
  func getImage() async {
    if let data = try? await getData(), let image = UIImage(data: data) {
      await MainActor.run {
        self.image = .init(uiImage: image)
      }
    }
  }
  
  private func getData() async throws -> Data {
    
    return try await withCheckedThrowingContinuation { continuation in
      
      URLSession
        .shared
        .dataTask(with: imageURL) { data, response, error in
          
          if let data {
            continuation.resume(returning: data)
          } else if let error {
            continuation.resume(throwing: error)
          } else {
            continuation.resume(throwing: URLError(.badServerResponse))
          }
        }
        .resume()
    }
  }
}
