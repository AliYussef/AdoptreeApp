//
//  StartingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct StartingView: View {
    @State private var isAuthenticated = false
    @ObservedObject var treeViewModel: TreeViewModel
    //@State private var isAuthenticated = false
    
    var body: some View {
        if isAuthenticated {
            ContentView(treeViewModel: treeViewModel)
                .transition(.move(edge: .trailing))
        } else {
            LoginView(isAuthenticated: $isAuthenticated)
        }
        
    }
}

//struct StartingView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartingView()
//    }
//}
