//
//  PowerupComponent.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 22/3/24.
//

import Foundation

class PowerupComponent: Component {
    var entity: Entity
    var powerupType: PowerupType

    init(entity: Entity, powerupType: PowerupType) {
        self.entity = entity
        self.powerupType = powerupType
    }
}
