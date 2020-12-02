//
//  OnboardingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct OnboardingView: View {
    @State var showStartingView = false
    @State private var currentIndex = 0
    @ObservedObject var treeViewModel: TreeViewModel
    
    var body: some View {
        //NavigationView {
        if showStartingView {
            StartingView(treeViewModel: treeViewModel)
                .transition(.move(edge: .trailing))
            //                .animation(.linear)
            //                .transition(.slide)
        }else{
            
            TabView(selection: $currentIndex.animation()) {
                FirstInfoView().tag(0)
                SecondInfoView().tag(1)
                ThirdInfoView(showStartingView: $showStartingView).tag(2)
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(Fancy3DotsIndexView(numberOfPages: 3, currentIndex: currentIndex), alignment: .bottom)
        }
        
        //        }
        //        .navigationBarTitle("")
        //        .navigationBarHidden(true)
    }
}

struct Fancy3DotsIndexView: View {
    
    // MARK: - Public Properties
    
    let numberOfPages: Int
    let currentIndex: Int
    
    
    // MARK: - Drawing Constants
    
    private let circleSize: CGFloat = 14
    private let circleSpacing: CGFloat = 10
    
    private let primaryColor = Color.init("color_primary_accent")
    private let secondaryColor = Color.init("color_gray_light")
    
    private let smallScale: CGFloat = 0.6
    
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: circleSpacing) {
            ForEach(0..<numberOfPages) { index in // 1
                if shouldShowIndex(index) {
                    Circle()
                        .fill(currentIndex == index ? primaryColor : secondaryColor) // 2
                        .scaleEffect(currentIndex == index ? 1 : smallScale)
                        
                        .frame(width: circleSize, height: circleSize)
                        
                        .transition(AnyTransition.opacity.combined(with: .scale)) // 3
                        
                        .id(index) // 4
                }
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    func shouldShowIndex(_ index: Int) -> Bool {
        ((currentIndex - 1)...(currentIndex + 1)).contains(index)
    }
}

