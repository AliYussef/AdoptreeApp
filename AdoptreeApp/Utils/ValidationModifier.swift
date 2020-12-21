//
//  ValidationModifier.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 20/12/2020.
//

import Foundation
import SwiftUI

struct ValidationModifier: ViewModifier {

    @State var latestValidation: InputValidation = .success
    
    let validationPublisher: ValidationPublisher
    
    func body(content: Self.Content) -> some View {
        VStack(alignment: .leading) {
            content
            validationMessage
        }.onReceive(validationPublisher) { validation in
            self.latestValidation = validation
        }
    }

    var validationMessage: some View {
        switch latestValidation {
            case .success:
                return AnyView(EmptyView())
            case .failure(let message):
                let text = Text(message)
                    .foregroundColor(Color.red)
                    .font(.caption)
                return AnyView(text)
        }
    }
}

extension View {
    
    func validation(_ validationPublisher: ValidationPublisher) -> some View {
        self.modifier(ValidationModifier(validationPublisher: validationPublisher))
    }
    
}
