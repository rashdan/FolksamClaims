//
//  Views.swift
//  feature_AudioClaim
//
//  Created by Johan Torell on 2021-11-03.
//

import Foundation
import SwiftUI

enum TagColor {
    case purple, green
}

private let darkPurple = Color(red: 128 / 255, green: 94 / 255, blue: 224 / 255)
private let lightPurple = Color(red: 236 / 255, green: 233 / 255, blue: 249 / 255)
private let lightGreen = Color(red: 215 / 255, green: 249 / 255, blue: 251 / 255)
private let darkGreen = Color(red: 93 / 255, green: 177 / 255, blue: 166 / 255)

private let purpleText = Color(red: 74 / 255, green: 24 / 255, blue: 181 / 255)
private let greenText = Color(red: 64 / 255, green: 115 / 255, blue: 110 / 255)

struct LabelTag: View {
    let entity: Entity
    let tagColor: TagColor
    let colors: (group: Color, background: Color, text: Color)

    init(entity: Entity, tagColor: TagColor) {
        self.entity = entity
        self.tagColor = tagColor
        colors = {
            switch tagColor {
            case .purple:
                return (group: darkPurple, background: lightPurple, text: purpleText)
            case .green:
                return (group: darkGreen, background: lightGreen, text: greenText)
            }
        }()
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(entity.word)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(colors.text)
                .padding(5)
            Text(entity.entityGroup)
                .font(.system(size: 10))
                .fontWeight(.black)
                .foregroundColor(colors.background)

                .padding(3)
                .background(colors.group)
                .cornerRadius(5)
        }
        .background(colors.background)
        .cornerRadius(5)
    }
}

struct Views_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LabelTag(entity: Entity(entityGroup: "PM", score: 0.9, word: "Lars Svensson", start: 0, end: 0), tagColor: .purple)
        }
    }
}
