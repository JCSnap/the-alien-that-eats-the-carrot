//
//  CollectableType.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 23/3/24.
//

import Foundation

public enum CollectableType: String, Equatable {
    case coin, carrot, heart

    static let typeToAssetNameMap = [coin: "coin-gold",
                                     carrot: "carrot-collect",
                                     heart: "heart-full"]
    static let typeToSizeMap = [coin: CGSize(width: 2.5, height: 2.5),
                                carrot: CGSize(width: 4, height: 4),
                                heart: CGSize(width: 4, height: 4)]

    var assetName: String? {
        CollectableType.typeToAssetNameMap[self]
    }

    var size: CGSize? {
        CollectableType.typeToSizeMap[self]
    }

    var width: CGFloat {
        CollectableType.typeToSizeMap[self]!.width
    }

    var height: CGFloat {
        CollectableType.typeToSizeMap[self]!.height
    }
}
