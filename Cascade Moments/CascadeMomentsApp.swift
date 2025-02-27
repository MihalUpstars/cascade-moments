

import SwiftUI
import WebKit
import AppTrackingTransparency
import AdSupport
import OneSignalFramework
import AdServices

struct DotsLoaderView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
                    .opacity(isAnimating ? 0.3 : 1.0)
                    .scaleEffect(isAnimating ? 0.8 : 1.2)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(0.2 * Double(index)),
                        value: isAnimating
                    )
            }
        }
        .onAppear { isAnimating = true }
    }
}

@main
struct CascadeMomentsApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegateNapoLega.self) var delegate
    @State private var appState2: AppState2 = .loading1
    
    enum AppState2 {
        case loading1, loading2, webView, game
    }
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                switch appState2 {
                case .loading1:
                    VStack {
                        DotsLoaderView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .background(
                        Image("loader 97")
                            .resizable()
                            .ignoresSafeArea()
                    )
                case .loading2:
                    VStack {
                        DotsLoaderView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .background(
                        Image("loader 98")
                            .resizable()
                            .ignoresSafeArea()
                    )
                
                case .game:
                    ContentView()
                        .onAppear { requestTrackingPermission() }
                
                case .webView:
                    ZStack{}.onAppear(){
                        print("")
                    }
                }
            }.onAppear { startLoadingAnimation() }
        }
    }

   

    @MainActor
    private func startLoadingAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            appState2 = .loading2
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                appState2 = .game
               
            }
        }
        
       
       
    }

    private func requestTrackingPermission() {
        guard #available(iOS 14, *) else { return }

        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .denied, .restricted:
                    NotificationCenter.default.post(name: .didReceiveTrackNapoLega, object: nil)

                case .notDetermined:
                    requestTrackingPermission()

                @unknown default:
                    print("Unknown tracking permission status")
                }
            }
        }
    }

 
}

