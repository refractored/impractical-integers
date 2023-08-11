//
//  Animations.swift
//  impracticalint
//
//  Created by David G on 8/11/23.
//

import SwiftUI

struct jiggleEffect: GeometryEffect{
    var amount: CGFloat = 10
    var shakesperunit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesperunit)), y: 0))
    }
}
