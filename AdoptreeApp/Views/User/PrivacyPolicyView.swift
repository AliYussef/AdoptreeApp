//
//  PrivacyPolicyView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct PrivacyPolicyView: View {
    
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    Text("Privacy policy")
                        .font(.title)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom)
                    
                    Text("Privacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy rivacy policy")
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .leading)
                .padding()
            }
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
