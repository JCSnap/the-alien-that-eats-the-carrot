//
//  NormalBlockFactory.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 29/3/24.
//

import Foundation

class NormalBlockFactory: BlockFactory {
    override func createComponents() -> [Component] {
        let size = CGSize(width: boardObject.width, height: boardObject.height)
        let blockComponent = BlockComponent(entity: entity)
        let renderableComponent = RenderableComponent(entity: entity,
                                                      position: boardObject.position,
                                                      objectType: .block(.normal),
                                                      size: size)
        let physicsBody = PhysicsBody(shape: .rectangle, position: boardObject.position,
                                      size: size, categoryBitmask: Constants.blockCategoryBitmask,
                                      collisionBitmask: Constants.blockCollisionBitmask,
                                      isDynamic: false)
        let physicsComponent = PhysicsComponent(entity: entity, physicsBody: physicsBody)
        let frictionalComponent = FrictionalComponent(entity: entity)
        let destroyableComponent = DestroyableComponent(entity: entity, maxHealth: 10.0, maxLives: 1, isInvinsible: false)
        return [blockComponent, renderableComponent, physicsComponent, frictionalComponent, destroyableComponent]
    }
}
