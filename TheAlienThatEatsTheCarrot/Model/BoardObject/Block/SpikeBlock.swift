//
//  SpikeBlock.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 12/3/24.
//

import CoreGraphics

class SpikeBlock: Block {
    // TODO: update when adding asset
    static let imageName = ""

    init(position: CGPoint = .zero) {
        super.init(imageName: SpikeBlock.imageName, position: position)
    }
}