//
//  CoinGameCollectable.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 30/3/24.
//

import Foundation

class CoinGameCollectable: GameCollectable {
    func effectToEntity(_ entity: Entity, delegate: CollectableActionDelegate) {
        let inventoryComponent = delegate.getComponent(of: InventoryComponent.self, for: entity)
        inventoryComponent?.incrementCoin()
    }
}