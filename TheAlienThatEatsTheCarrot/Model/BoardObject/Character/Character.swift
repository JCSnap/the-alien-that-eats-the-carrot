//
//  Character.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 12/3/24.
//

import Foundation

class Character: BoardObject {
    var position: CGPoint = .zero
    var width: CGFloat
    var height: CGFloat
    var imageName: String?

    init(imageName: String, width: CGFloat, height: CGFloat, position: CGPoint = .zero) {
        self.imageName = imageName
        self.width = width
        self.height = height
        self.position = position
    }

    func move(to newPosition: CGPoint) {
        self.position = newPosition
    }
}
