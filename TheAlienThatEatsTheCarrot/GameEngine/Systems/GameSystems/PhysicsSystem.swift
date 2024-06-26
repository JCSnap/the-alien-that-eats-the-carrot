//
//  PhysicsSystem.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 2/4/24.
//

import CoreGraphics

final class PhysicsSystem: System {
    static let GRAVITY_FORCE = CGVector(dx: 0, dy: 300.0)
    let nexus: Nexus
    let physicsWorld: PhysicsWorld

    init(nexus: Nexus, physicsWorld: PhysicsWorld) {
        self.nexus = nexus
        self.physicsWorld = physicsWorld
    }

    func update(deltaTime: CGFloat) {
        let entities = nexus.getEntities(with: PhysicsComponent.self)

        entities.forEach { entity in
            updateRenderable(entity)
            applyGravity(to: entity)
        }

        updatePhysicsBodies(deltaTime: deltaTime)
        nexus.removeComponents(of: CollisionComponent.self)
    }

    private func updatePhysicsBodies(deltaTime: CGFloat) {
        let physicsBodies = nexus.getComponents(of: PhysicsComponent.self).map { $0.physicsBody }
        physicsWorld.updatePhysicsBodies(physicsBodies, deltaTime: deltaTime)
    }

    private func updateRenderable(_ entity: Entity) {
        guard
            let renderableComponent = nexus.getComponent(of: RenderableComponent.self, for: entity),
            let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
            return
        }
        renderableComponent.position = physicsComponent.physicsBody.position
    }

    private func applyGravity(to entity: Entity) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity) else {
            return
        }
        if physicsComponent.disableGravity || !physicsComponent.physicsBody.isDynamic {
            return
        }
        physicsComponent.physicsBody.applyForce(PhysicsSystem.GRAVITY_FORCE)
    }
}
