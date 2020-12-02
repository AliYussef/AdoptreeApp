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
                    Spacer()
                    NavigationLink(destination: TreeFiltersView())
                    {
                        Text("Filters")
                        Image(systemName: "line.horizontal.3.decrease")
                    }
                    .foregroundColor(.black)
                }
                .padding()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        TreeTypeView()
                        TreeTypeView()
                        TreeTypeView()
                    }
                }
                Spacer()
                
                NavigationLink(destination: AdoptionOverviewView())
                {
                    Text("Proceed")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(width: 180, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
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
