//
//  TreePersonalizationView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import UIKit

struct TreePersonalizationView: View {
    //let tree: Tree
    @State private var treeName = ""
    @State private var treeColor = conve
    //@State private var treeColorr = CGColor(
    
    
    func convertToColor(hexa: String) -> CGColor? {
        let r, g, b, a: CGFloat
        
        if hexa.hasPrefix("#") {
            let start = hexa.index(hexa.startIndex, offsetBy: 1)
            let hexColor = String(hexa[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    return CGColor(red: r, green: g, blue: b, alpha: a)
                }
            }
        }
        
        return nil
    }
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .leading) {
                Text("Personalize your tree")
                    .font(.title)
                    .foregroundColor(.init("color_font_primary"))
                
                Form {
                    Section(header: Text("Tree details"), content: {
                        TextField("Tree name", text: $treeName)
                        //ColorPicker("Tree color", selection: $treeColor)
                        //ColorPicker("Tree color", selection: $treeColor)
                    })
                }
                
                
//                Text("text\(treeColor.toHex() ?? "")")
//                    .foregroundColor(Color(treeColor))
                
            }
            .padding()
        }
    }
}

extension CGColor {
    
//    var toCGColor: CGColor {
//        return toHex()
//    }
    
    public func toCGColor(hex: String) -> CGColor? {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                   return CGColor(red: r, green: g, blue: b, alpha: a)
                    //self.init(red: r, green: g, blue: b, alpha: a)
                    //return
                }
            }
        }
        
        return nil
    }
    

    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        
        guard let components = components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return "#" + String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return "#" + String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

struct TreePersonalizationView_Previews: PreviewProvider {
    static var previews: some View {
        TreePersonalizationView()
    }
}
