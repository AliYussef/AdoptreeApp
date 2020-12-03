//
//  TreeSelectionView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreeSelectionView: View {
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            // ScrollView {
            VStack {
                
                HStack {
                   
                    NavigationLink(destination: TreeFiltersView())
                    {
                       
                        Label("Filters", systemImage: "line.horizontal.3.decrease")
                            .foregroundColor(.black)
                    }
                    .foregroundColor(.black)
                   
                    Spacer()
                    
                    NavigationLink(destination: AdoptionOverviewView())
                    {
                        Label("Cart", systemImage: "cart")
                            .foregroundColor(.black)
                    }
                  
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none)
                .padding(.bottom)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        TreeTypeView()
                        TreeTypeView()
                        TreeTypeView()
                    }
                }
                Spacer()
                
               
                //.padding()
            }
            //}
        }
        .navigationBarTitle("ADOPTION", displayMode: .inline)
    }
}

struct TreeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TreeSelectionView()
    }
}
