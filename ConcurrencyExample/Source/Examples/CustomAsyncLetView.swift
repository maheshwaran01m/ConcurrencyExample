//
//  CustomAsyncLetView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

struct CustomAsyncLetView: View {
  
  @State private var images = [UIImage]()
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(images, id: \.self) { image in
           Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .frame(height: 100)
          }
        }
      }
      .navigationTitle("Async Let")
      .onAppear(perform: fetchImages)
    }
  }
  
  private func fetchImages() {
    Task {
      do {
        
        // It will be serial queue, it will run one after another
        // so we are using `async let`
        /*
        let image1 = try await downloadImage()
        self.images.append(image1)
        
        let image2 = try await downloadImage()
        self.images.append(image2)
        
        let image3 = try await downloadImage()
        self.images.append(image3)
        
        let image4 = try await downloadImage()
        self.images.append(image4)
         */
        
        async let image1 = downloadImage()
        async let image2 = downloadImage()
        async let image3 = downloadImage()
        async let image4 = downloadImage()
        
        let (one, two, three, four) = await (try image1, try image2, try image3, try image4)
        
        self.images.append(contentsOf: [one, two, three, four])
        
      } catch {
        
      }
    }
  }
  
  private func downloadImage() async throws -> UIImage {
    guard let url = URL(string: "https://picsum.photos/200") else {
      throw URLError(.badURL)
    }
    
    do {
     let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        return image
      } else {
        throw URLError(.badServerResponse)
      }
    } catch {
      throw error
    }
  }
}

// MARK: - Preview

struct CustomAsyncLetView_Previews: PreviewProvider {
  static var previews: some View {
    CustomAsyncLetView()
  }
}

