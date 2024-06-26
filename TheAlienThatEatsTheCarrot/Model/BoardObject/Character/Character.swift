//
//  Character.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 12/3/24.
//

import Foundation

final class Character: BoardObject {
    var position: CGPoint = .zero
    var width: CGFloat
    var height: CGFloat
    var imageName: String?
    var characterType: CharacterType
    var type: ObjectType {
        .character(self.characterType)
    }

    init(characterType: CharacterType, position: CGPoint = .zero) {
        self.characterType = characterType
        self.position = position
        self.imageName = characterType.assetName
        self.width = characterType.width
        self.height = characterType.height
    }

    func move(to newPosition: CGPoint) {
        self.position = newPosition
    }

    func isOverlapping(with boardObject: BoardObject) -> Bool {
        let minX1 = position.x - width / 2
        let maxX1 = position.x + width / 2
        let minY1 = position.y - height / 2
        let maxY1 = position.y + height / 2

        let minX2 = boardObject.position.x - boardObject.width / 2
        let maxX2 = boardObject.position.x + boardObject.width / 2
        let minY2 = boardObject.position.y - boardObject.height / 2
        let maxY2 = boardObject.position.y + boardObject.height / 2

        return minX1 < maxX2 && maxX1 > minX2 && minY1 < maxY2 && maxY1 > minY2
    }

    func contains(point: CGPoint) -> Bool {
        let minX = position.x - width / 2
        let maxX = position.x + width / 2
        let minY = position.y - height / 2
        let maxY = position.y + height / 2
        return point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
    }
}

extension Character: Hashable {
    public static func == (lhs: Character, rhs: Character) -> Bool {
        lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
