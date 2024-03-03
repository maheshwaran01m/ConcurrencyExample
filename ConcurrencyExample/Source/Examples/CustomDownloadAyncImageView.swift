//
//  CustomDownloadAyncImageView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 02/03/24.
//

import SwiftUI
import Combine

struct CustomDownloadAyncImageView: View {
  
  @StateObject private var viewModel = CustomDownloadAyncImageViewModel()
  
  var body: some View {
    ZStack {
      if let image = viewModel.image {
        image
          .renderingMode(.original)
          .resizable()
          .scaledToFit()
          .frame(width: 150, height: 150)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }
    }
    .task {
      // it cancel the task, when view disappears
    }
  }
}

// MARK: - Preview

struct CustomDownloadAyncImageView_Previews: PreviewProvider {
  static var previews: some View {
    CustomDownloadAyncImageView()
  }
}

// MARK: - ViewModel

fileprivate class CustomDownloadAyncImageViewModel: ObservableObject {
  
  @Published var image: Image?
  @Published var task: Task<(), Error>?
  
  let url = URL(string: "https://picsum.photos/200")!
  
  init() {
    fetchImage()
  }
  
  var cancelBag = Set<AnyCancellable>()
  
  func fetchImage() {
    image = .init(systemName: "person.circle")
    
    // completion
    /*
    downloadImage { [weak self] image, error in
      if let image {
        DispatchQueue.main.async {
          self?.image = .init(uiImage: image)
        }
      }
    }
     */
    
    // combine
    /*
    downloadImageUsingCombine()
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { [weak self] image in
        guard let self, let image else { return }
        self.image = .init(uiImage: image)
      }
      .store(in: &cancelBag)
     */
    
    // async
    task = Task {
      if let image = try await downloadWithAsync(){
        await MainActor.run {
          self.image = .init(uiImage: image)
        }
      }
    }
  }
  
  deinit {
    task?.cancel()
  }
  
  func downloadImage(completion: @escaping (UIImage?, Error?) -> ()) {
    
    URLSession
      .shared
      .dataTask(with: url) { [weak self] data, response, error in
        
        let image = self?.handleResponse(data, response: response)
        completion(image, error)
      }
      .resume()
  }
  
  func downloadImageUsingCombine() -> AnyPublisher<UIImage?, Error> {
    URLSession
      .shared
      .dataTaskPublisher(for: url)
      .map(handleResponse)
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func downloadWithAsync() async throws -> UIImage? {
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      try Task.checkCancellation()
      
      return handleResponse(data, response: response)
    } catch {
      throw error
    }
  }
  
  func handleResponse(_ data: Data?, response: URLResponse?) -> UIImage? {
    guard let data, let image = UIImage(data: data),
          let response = response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
      return nil
    }
    return image
  }
}
