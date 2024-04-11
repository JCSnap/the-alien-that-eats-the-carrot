//
//  AttackIfOutOfBoundsAttackStyle.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 11/4/24.
//

import Foundation

class AttackIfOutOfBoundsAttackStyle: AttackStyle {
    static let DEFAULT_TARGETABLES: [Component.Type] = [PlayerComponent.self]
    static let VERY_LARGE_DAMAGE = 10_000.0
    var targetables: [Component.Type]

    var damage: CGFloat
    var bounds: CGRect

    init(bounds: CGRect, targetables: [Component.Type] = AttackIfOutOfBoundsAttackStyle.DEFAULT_TARGETABLES,
         damage: CGFloat = AttackIfOutOfBoundsAttackStyle.VERY_LARGE_DAMAGE) {
        self.bounds = bounds
        self.targetables = targetables
        self.damage = damage
    }

    func attack(attacker: Entity, attackee: Entity, delegate: AttackableDelegate) {
        guard
            let renderableComponent = delegate.getComponent(of: RenderableComponent.self, for: attackee),
            let destroyableComponent = delegate.getComponent(of: DestroyableComponent.self, for: attackee) else {
            return
        }
        if attacker != attackee
            && canAttack(attackee, with: targetables, using: delegate)
            && !bounds.intersects(renderableComponent.getRect()) {
            dealDamage(damage, to: attackee, delegate: delegate)
        }
    }
}
