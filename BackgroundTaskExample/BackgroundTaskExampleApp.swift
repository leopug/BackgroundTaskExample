//
//  BackgroundTaskExampleApp.swift
//  BackgroundTaskExample
//
//  Created by Leonardo Maia Pugliese on 10/09/2022.
//

import SwiftUI
import BackgroundTasks

@main
struct BackgroundTaskExampleApp: App {
    @StateObject var imageStore = ImageStore()
    
    var body: some Scene {
        WindowGroup {
            AnyView( ContentView(imageStore: imageStore)
                .environmentObject(imageStore)) // adding this the project will not compile anymore
        }
        .backgroundTask(.appRefresh("randomImage")) {
            await refreshAppData()
        }
    }
    
    func refreshAppData() async {
        let content = UNMutableNotificationContent()
        content.title = "A Random Photo is awaiting for you!"
        content.subtitle = "Check it now!"
        
        if await fetchRandomImage() {
            try? await UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "test", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)))
        }
    }
    
    func fetchRandomImage() async -> Bool {
        guard let url = URL(string: "https://picsum.photos/200/300"),
              let (data, response) = try? await URLSession.shared.data(from: url),
              let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            return false
        }
        
        imageStore.randomImage = UIImage(data: data)
        
        return true
    }
}
