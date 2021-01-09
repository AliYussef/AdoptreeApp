//
//  GuestTimelineView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 03/12/2020.
//

import SwiftUI

struct GuestTimelineView: View {
    var body: some View {
        
        VStack {
            Image("timeline_tree")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300, alignment: .center)
                .padding(.bottom)
            
            Text(Localization.timelineGuestText)
                .font(.body)
                .foregroundColor(.init("color_font_secondary"))
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}
