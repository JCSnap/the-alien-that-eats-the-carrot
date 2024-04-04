//
//  DoubleJumpPowerupFactory.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 30/3/24.
//

import Foundation

class DoubleJumpPowerupFactory: PowerupFactory {
    override func createComponents() -> [Component] {
        let size = CGSize(width: boardObject.width, height: boardObject.height)
        let powerupComponent = PowerupComponent(entity: entity, powerup: DoubleJumpGamePowerup())
        let renderableComponent = RenderableComponent(entity: entity,
                                                      position: boardObject.position,
                                                      objectType: .powerup(.doubleJump),
                                                      size: size)
        return [powerupComponent, renderableComponent]
    }
}
