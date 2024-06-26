//
//  FastEnemyFactory.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 2/4/24.
//

import Foundation

class FastEnemyFactory: EnemyFactory {
    static let SCORE: Int = 200
    override func createComponents() -> [Component] {
        let size = CGSize(width: boardObject.width, height: boardObject.height)
        let enemyComponent = EnemyComponent(entity: entity)
        let renderableComponent = RenderableComponent(entity: entity,
                                                      position: boardObject.position,
                                                      objectType: .enemy(.fast),
                                                      size: size)
        let movableComponent = MovableComponent(entity: entity, pattern: RandomPattern())
        let attackStyles = [MeleeAttackStyle(targetables: [PlayerComponent.self])]
        let attackableComponent = AttackableComponent(entity: entity,
                                                      attackStyles: attackStyles)
        let physicsBody = PhysicsBody(shape: .rectangle,
                                      position: boardObject.position,
                                      size: size,
                                      categoryBitmask: Constants.enemyCategoryBitmask,
                                      collisionBitmask: Constants.enemyCollisionBitmask,
                                      isDynamic: false)
        physicsBody.velocity = CGVector(dx: 40.0, dy: 0)
        let physicsComponent = PhysicsComponent(entity: entity,
                                                physicsBody: physicsBody)
        let destroyableComponent = DestroyableComponent(entity: entity, onDestroyed: EnemyKilledEvent(entity: entity))
        let scoreComponent = ScoreComponent(entity: entity, score: FastEnemyFactory.SCORE)
        return [enemyComponent, renderableComponent, movableComponent, attackableComponent,
                physicsComponent, destroyableComponent, scoreComponent]
    }
}
