//
//  BlockType.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 23/3/24.
//

import Foundation

public enum BlockType: String {
    case normal, ground, spike, breakable, pushable, mushroom, roller, temporary, gravity,
         doubleJumpPowerup, strengthPowerup, attackPowerup, invinciblePowerup, exit

    static let typeToAssetNameMap = [normal: "land-top",
                                     ground: "land-bottom",
                                     spike: "spike",
                                     breakable: "block-breakable",
                                     pushable: "block-pushable",
                                     mushroom: "mushroom-1",
                                     roller: "platform-oneway",
                                     temporary: "platform-solid",
                                     gravity: "block-nonbreakable",
                                     doubleJumpPowerup: "powerup-doublejump-block",
                                     strengthPowerup: "powerup-strength-block",
                                     attackPowerup: "powerup-attack-block",
                                     invinciblePowerup: "powerup-invincibility-block",
                                     exit: "exit"]
    static let typeToSizeMap = [normal: CGSize(width: 5, height: 5),
                                ground: CGSize(width: 5, height: 5),
                                spike: CGSize(width: 5, height: 2.1429),
                                breakable: CGSize(width: 5, height: 5),
                                mushroom: CGSize(width: 3.57143, height: 2.6191),
                                roller: CGSize(width: 5, height: 1.9048),
                                temporary: CGSize(width: 5, height: 2.6191),
                                gravity: CGSize(width: 5, height: 5),
                                pushable: CGSize(width: 5, height: 5),
                                doubleJumpPowerup: CGSize(width: 5, height: 5),
                                strengthPowerup: CGSize(width: 5, height: 5),
                                attackPowerup: CGSize(width: 5, height: 5),
                                invinciblePowerup: CGSize(width: 5, height: 5),
                                exit: CGSize(width: 5, height: 5)
    ]

    var assetName: String? {
        BlockType.typeToAssetNameMap[self]
    }

    var size: CGSize? {
        BlockType.typeToSizeMap[self]
    }

    var width: CGFloat {
        BlockType.typeToSizeMap[self]!.width
    }
    var height: CGFloat {
        BlockType.typeToSizeMap[self]!.height
    }
}

extension BlockType: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
