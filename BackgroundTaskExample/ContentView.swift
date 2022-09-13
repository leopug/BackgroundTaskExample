//
//  ContentView.swift
//  BackgroundTaskExample
//
//  Created by Leonardo Maia Pugliese on 10/09/2022.
//

import SwiftUI
import BackgroundTasks

class ImageStore: ObservableObject {
    @Published var randomImage: UIImage?
}

struct ContentView: View {
    
    @ObservedObject var imageStore: ImageStore
    
    var body: some View {
        VStack {
            
            Button("Local Message Autorization") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                        
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }.buttonStyle(.borderedProminent)
                .padding()
            
            Button("Schedule Background Task") {
                let request = BGAppRefreshTaskRequest(identifier: "randomImage")
                request.earliestBeginDate = Calendar.current.date(byAdding: .second, value: 5, to: Date())
                do {
                    try BGTaskScheduler.shared.submit(request)
                    print("Background Task Scheduled!")
                } catch(let error) {
                    print("Scheduling Error \(error.localizedDescription)")
                }
                
            }.buttonStyle(.bordered)
                .tint(.red)
                .padding()
            
            if let image = imageStore.randomImage {
                Image(uiImage: image)
            }
            
        }
    }
}

// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"randomImage"]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(imageStore: ImageStore())
    }
}
