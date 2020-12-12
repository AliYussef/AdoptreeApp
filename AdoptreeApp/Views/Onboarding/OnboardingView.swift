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
    
    var body: some View {
        
        if showStartingView {
            StartingView()
                .transition(.move(edge: .trailing))
        } else {
            
            TabView(selection: $currentIndex.animation()) {
                FirstInfoView().tag(0)
                SecondInfoView().tag(1)
                ThirdInfoView(showStartingView: $showStartingView).tag(2)
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(CustomDotsIndexView(numberOfPages: 3, currentIndex: currentIndex), alignment: .bottom)
        }
    }
}

struct CustomDotsIndexView: View {
    let numberOfPages: Int
    let currentIndex: Int
    private let circleSize: CGFloat = 14
    private let circleSpacing: CGFloat = 10
    private let primaryColor = Color.init("color_primary_accent")
    private let secondaryColor = Color.init("color_gray_light")
    private let smallScale: CGFloat = 0.6
    
    var body: some View {
        HStack(spacing: circleSpacing) {
            ForEach(0..<numberOfPages) { index in
                if shouldShowIndex(index) {
                    Circle()
                        .fill(currentIndex == index ? primaryColor : secondaryColor)
                        .scaleEffect(currentIndex == index ? 1 : smallScale)
                        .frame(width: circleSize, height: circleSize)
                        .transition(AnyTransition.opacity.combined(with: .scale))
                        .id(index)
                }
            }
        }
    }
    
    func shouldShowIndex(_ index: Int) -> Bool {
        ((currentIndex - 1)...(currentIndex + 1)).contains(index)
    }
}

