//
//  AdoptreeAppApp.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import UIKit

@main
struct AdoptreeAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var notificationViewModel: NotificationViewModel
    var userViewModel: UserViewModel
    var orderViewModel: OrderViewModel
    var treeViewModel: TreeViewModel
    var timelineViewModel: TimelineViewModel
    var newsViewModel: NewsViewModel
    var viewRouter: ViewRouter
    private let viewModelFactory: ViewModelFactory
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_font_primary") ?? .black]
        
        viewModelFactory = ViewModelFactory()
        notificationViewModel = NotificationViewModel.shared
        userViewModel = UserViewModel.shared
        orderViewModel = viewModelFactory.makeOrderViewModel()
        treeViewModel = viewModelFactory.makeTreeViewModel()
        timelineViewModel = viewModelFactory.makeTimelineViewModel()
        newsViewModel = viewModelFactory.makeNewsViewModel()
        viewRouter = ViewRouter()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                Color.init("color_background")
                    .edgesIgnoringSafeArea(.all)
                
                RootView().environmentObject(viewRouter).environmentObject(orderViewModel)
                    .environmentObject(notificationViewModel).environmentObject(userViewModel).environmentObject(treeViewModel).environmentObject(timelineViewModel).environmentObject(newsViewModel)
            }
            .accentColor(.init("color_primary_accent"))
            .environment(\.locale, .init(identifier: notificationViewModel.languagesIndex == 0 ? "en" : "nl"))
        }
    }
}

extension UIColor {
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if hexColor.count == 8 {
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else {
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        
        return nil
    }
    
    func toHex() -> String? {
        
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if components.count == 4 {
            return "#" + String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return "#" + String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
