//
//  DestroyableComponent.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 11/3/24.
//

import Foundation

class DestroyableComponent: Component {
    static let DEFAULT_DESTROYABLE_HEALTH = 100.0
    static let DEFAULT_LIVES = 1
    static let DEFAULT_MAX_LIVES = 1
    var entity: Entity
    var health: CGFloat
    var maxHealth: CGFloat
    var lives: Int
    var maxLives: Int
    var isDestroyed: Bool
    var isInvinsible: Bool

    init(entity: Entity, maxHealth: CGFloat = DestroyableComponent.DEFAULT_DESTROYABLE_HEALTH,
         lives: Int = DestroyableComponent.DEFAULT_LIVES, maxLives: Int = DestroyableComponent.DEFAULT_MAX_LIVES,
         isDestroyed: Bool = false, isInvinsible: Bool = false) {
        self.entity = entity
        self.health = maxHealth
        self.maxHealth = maxHealth
        self.lives = lives
        self.maxLives = maxLives
        self.isDestroyed = isDestroyed
        self.isInvinsible = isInvinsible
    }

    func takeDamage(_ damage: CGFloat, delegate: AttackableDelegate) {
        if isDestroyed || isInvinsible {
            return
        }
        health -= damage
        postDamageEvent(damage, delegate: delegate)
        if health <= 0 {
            lives -= 1
            health = maxHealth
            EventManager.shared.postEvent(LiveDecreaseEvent(entity: entity))
        }
        if lives <= 0 {
            isDestroyed = true
            EventManager.shared.postEvent(DestroyEvent(entity: entity))
        }
    }

    func incrementLifeIfPossible() {
        if lives >= maxLives {
            return
        }
        lives += 1
    }

    private func postDamageEvent(_ damage: CGFloat, delegate: AttackableDelegate) {
        guard let renderableComponent = delegate.getComponent(of: RenderableComponent.self, for: entity) else {
            return
        }
        print("Posting damage event")
        let damageEvent = DamageEvent(position: renderableComponent.position, damage: damage)
        EventManager.shared.postEvent(damageEvent)
    }
}
