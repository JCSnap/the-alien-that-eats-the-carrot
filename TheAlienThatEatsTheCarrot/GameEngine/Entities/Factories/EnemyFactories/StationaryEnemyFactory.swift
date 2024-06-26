//
//  StationaryEnemyFactory.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 29/3/24.
//

import Foundation

class StationaryEnemyFactory: EnemyFactory {
    static let SCORE: Int = 200
    static let DIRECTIONS: [Direction] = [.up]
    override func createComponents() -> [Component] {
        let size = CGSize(width: boardObject.width, height: boardObject.height)
        let enemyComponent = EnemyComponent(entity: entity)
        let renderableComponent = RenderableComponent(entity: entity,
                                                      position: boardObject.position,
                                                      objectType: .enemy(.stationary),
                                                      size: size)
        let physicsBody = PhysicsBody(shape: .rectangle, position: boardObject.position,
                                      size: size, categoryBitmask: Constants.enemyCategoryBitmask,
                                      collisionBitmask: Constants.enemyCollisionBitmask, isDynamic: true)
        let physicsComponent = PhysicsComponent(entity: entity, physicsBody: physicsBody)
        let destroyableComponent = DestroyableComponent(entity: entity, onDestroyed: EnemyKilledEvent(entity: entity))
        let scoreComponent = ScoreComponent(entity: entity, score: StationaryEnemyFactory.SCORE)
        let dissapearWhenCollideWith: [Component.Type] = [PlayerComponent.self, BlockComponent.self]
        let attackStyle = PeriodicallyShootPelletAttackStyle(targetables: [PlayerComponent.self],
                                                             directions: StationaryEnemyFactory.DIRECTIONS,
                                                             dissapearWhenCollideWith: dissapearWhenCollideWith)
        let attackableComponent = AttackableComponent(entity: entity, attackStyles: [attackStyle])
        return [enemyComponent, renderableComponent, physicsComponent,
                destroyableComponent, scoreComponent, attackableComponent]
    }
}
