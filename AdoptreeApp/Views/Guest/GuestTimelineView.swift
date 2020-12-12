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
            
            Text("Login or adopt a tree to stay up to date with all your tree's achievments and milestones")
                .font(.body)
                .foregroundColor(.init("color_font_secondary"))
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

struct GuestTimelineView_Previews: PreviewProvider {
    static var previews: some View {
        GuestTimelineView()
    }
}
