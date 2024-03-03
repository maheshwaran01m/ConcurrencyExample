//
//  CustomActorView.swift
//  ConcurrencyExample
//
//  Created by MAHESHWARAN on 03/03/24.
//

import SwiftUI

struct CustomActorView: View {
  
  var body: some View {
    TabView {
      homeView
      browseView
    }
  }
  
  private var homeView: some View {
   CustomActorHomeView()
    .tabItem {
      Label("Home", systemImage: "house.fill")
    }
  }
  
  private var browseView: some View {
    CustomActorBrowseView()
    .tabItem {
      Label("Browse", systemImage: "magnifyingglass")
    }
  }

}

// MARK: - Home

fileprivate struct CustomActorHomeView: View {
  
  @State private var text = ""
  
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  let manager = CustomActorDataManager.shared
  
  var body: some View {
    ZStack {
      Color.gray.opacity(0.3).ignoresSafeArea()
      
      Text(text)
        .font(.headline)
    }
    /*
    .onReceive(timer) { _ in
      DispatchQueue.global(qos: .background).async {
        
        if let data = manager.getRecords() {
          DispatchQueue.main.async {
            self.text = data
          }
        }
      }
    }
    */
  }
}

// MARK: - Browse

fileprivate struct CustomActorBrowseView: View {
  
  @State private var text = ""
  
  let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
  
  let manager = CustomActorManager.shared
  
  var body: some View {
    ZStack {
      Color.blue.opacity(0.3).ignoresSafeArea()
      
      Text(text)
        .font(.headline)
    }
    /*
    .onReceive(timer) { _ in
      DispatchQueue.global(qos: .default).async {
        
        manager.getValue { value in
          if let value {
            DispatchQueue.main.async {
              self.text = value
            }
          }
        }
      }
    }
     */
    
    .onReceive(timer) { _ in
      Task {
        if let value = await manager.getRecords() {
          await MainActor.run {
            self.text = value
          }
        }
      }
    }
  }
}

// MARK: - CustomActorDataManager

class CustomActorDataManager {
  
  static let shared = CustomActorDataManager()
  
  private init() {}
  
  private let queue = DispatchQueue(label: "com.concurrenyExample.actorManager")
  
  var records = [String]()
  
  func getRecords() -> String? {
    var value: String?
    
    queue.sync { [weak self] in
      guard let self else { return }
      self.records.append(UUID().uuidString)
//      debugPrint("Thread: \(Thread.current)")
      
      value = records.randomElement()
    }
    return value
  }
  
  func getValue(_ completion: @escaping (String?) -> ()) {
    queue.async {
      self.records.append(UUID().uuidString)
//      debugPrint("Thread: \(Thread.current)")
      
      completion(self.records.randomElement())
    }
  }
}


// MARK: - CustomActorManager

// Actor's are thread safe, solved `data race` problem in swift

actor CustomActorManager {
  
  static let shared = CustomActorManager()
  
  private init() {}
  
  var records = [String]()
  
  func getRecords() -> String? {
    self.records.append(UUID().uuidString)
//    debugPrint("Thread: \(Thread.current)")
    
    return records.randomElement()
  }
  
  // Without any Task (swift concurreny)
  
  nonisolated func getSavedRecors() -> String {
    return "Value"
  }
  
  nonisolated var getValue: String {
    "Value"
  }
}

// MARK: - Preview

struct CustomActorView_Previews: PreviewProvider {
  static var previews: some View {
    CustomActorView()
  }
}
