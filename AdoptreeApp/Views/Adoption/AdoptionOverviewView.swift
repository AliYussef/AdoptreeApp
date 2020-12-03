//
//  AdoptionOverviewView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AdoptionOverviewView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isChecked:Bool = false
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Text("Overview")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.init("color_font_primary"))
                    .padding(.top)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        
                        RoundedRectangle(cornerRadius: 12.0)
                            .fill(Color.white)
                            .frame(width: .none, height: 250, alignment: .leading)
                            .overlay(
                                VStack {
                                    
                                    HStack(alignment: .top) {
                                        Image("tree2")
                                            .resizable()
                                            .frame(width: 85, height: 100, alignment: .leading)
                                        
                                        VStack (alignment: .leading) {
                                            Text("WHITE OAK")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(.init("color_font_secondary"))
                                                .padding(.bottom, 1)
                                            Text("CO2: -1500Kg")
                                                .font(.footnote)
                                                .foregroundColor(.init("color_font_secondary"))
                                            Text("Age: 3 weeks")
                                                .font(.footnote)
                                                .foregroundColor(.init("color_font_secondary"))
                                            Text("Price: € 35 EUR")
                                                .font(.footnote)
                                                .foregroundColor(.init("color_font_secondary"))
                                            
                                        }
                                        Spacer()
                                        Text(" 1 x € 35 EUR")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.init("color_font_secondary"))
                                            .padding(.bottom, 1)
                                    }
                                    .padding(.bottom)
                                    
                                    HStack {
                                        Text("Location")
                                            .font(.subheadline)
                                            .foregroundColor(.init("color_font_secondary"))
                                        Spacer()
                                        Text("Mastbos, NL")
                                            .font(.subheadline)
                                            .foregroundColor(.init("color_font_secondary"))
                                    }
                                    
                                    Divider()
                                    
                                    HStack {
                                        VStack (alignment: .leading) {
                                            Text("Personal sign")
                                                .font(.subheadline)
                                                .foregroundColor(.init("color_font_secondary"))
                                            Text("Peter")
                                                .font(.subheadline)
                                                .foregroundColor(.init("color_font_secondary"))
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {self.isChecked.toggle()}, label: {
                                            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(.init("color_primary_accent"))
                                        })
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.init("color_primary_accent"))
                                        
                                    }
                                    .padding(.top)
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text("Personal sign can be added later as well")
                                            .font(.footnote)
                                            .foregroundColor(.init("color_font_secondary"))
                                        Spacer()
                                        Text("€ 5 EUR")
                                            .font(.subheadline)
                                            .foregroundColor(.init("color_font_secondary"))
                                    }
                                    
                                    
                                })
                            .padding()
                            .frame(width: .none, height: .none)
                            .background(Color.white)
                            .cornerRadius(12.0)
                            .padding(.bottom, 10)
                        
                        HStack {
                            Text("Total:")
                                .font(.footnote)
                                .foregroundColor(.init("color_font_secondary"))
                            
                            Spacer()
                            
                            Text("€ 40 EUR")
                                .font(.footnote)
                                .foregroundColor(.init("color_font_secondary"))
                        }
                        .padding()
                        .frame(width: .none, height: .none)
                        .background(Color.white)
                        .cornerRadius(12.0)
                        .padding(.bottom, 10)
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                        Text("Adopt more")
                            .bold()
                            .foregroundColor(.white)
                    })
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    
                    NavigationLink(destination: AdoptionLoginView())
                    {
                        Text("Proceed")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.4, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                }
                
            }
        }
        
    }
}

struct AdoptionOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptionOverviewView()
    }
}
