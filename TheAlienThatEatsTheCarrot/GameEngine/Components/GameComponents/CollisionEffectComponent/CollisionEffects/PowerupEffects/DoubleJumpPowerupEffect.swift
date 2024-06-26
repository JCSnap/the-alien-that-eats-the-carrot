//
//  DoubleJumpPowerupEffect.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 10/4/24.
//

import Foundation

class DoubleJumpPowerupEffect: BasePowerupEffect {
    static let DEFAULT_DURATION = 10.0

    override init(duration: CGFloat = DoubleJumpPowerupEffect.DEFAULT_DURATION) {
        super.init(duration: duration)
    }

    private var jumpStateComponentAffected: JumpStateComponent?

    override func effectWhenCollide(with collidee: Entity, by collider: Entity, delegate: CollisionEffectDelegate) {
        guard
            let jumpStateComponent = delegate.getComponent(of: JumpStateComponent.self, for: collider),
            let colliderPhysicsComponent = delegate.getComponent(of: PhysicsComponent.self, for: collider) else {
            return
        }
        jumpStateComponent.maxJump *= 2
        super.addTimer(to: collider, powerupEffect: self, delegate: delegate)
        EventManager.shared.postEvent(PowerupActivateEvent(type: .doubleJump,
                                                           name: "Double Jump 🪽",
                                                           position: colliderPhysicsComponent.physicsBody.position))
        EventManager.shared.postEvent(RemoveEntityEvent(entity: collidee))
    }

    override func restore() {
        jumpStateComponentAffected?.maxJump /= 2
    }
}
