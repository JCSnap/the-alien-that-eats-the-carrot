//
//  PhysicsWorld.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 2/4/24.
//

import CoreGraphics

final class PhysicsWorld {

    weak var collisionDelegate: PhysicsCollisionDelegate?
    var existingCollisions: Set<Collision>

    init() {
        existingCollisions = []
    }

    func update(_ physicsBodies: [PhysicsBody], deltaTime: CGFloat) {
        updatePhysicsBodies(physicsBodies, deltaTime: deltaTime)
        resolveCollisions(for: physicsBodies, deltaTime: deltaTime)
    }

    func updatePhysicsBodies(_ physicsBodies: [PhysicsBody],
                             deltaTime: CGFloat) {
        for physicsBody in physicsBodies {
            physicsBody.update(deltaTime: deltaTime)
        }
    }

    private func detectCollisions(for physicsBodies: [PhysicsBody], toIgnore: Set<[PhysicsBody]>) -> Set<Collision> {
        var currentCollisions: Set<Collision> = []

        guard physicsBodies.count >= 2 else {
            existingCollisions = []
            return currentCollisions
        }

        for i in 0..<physicsBodies.count - 1 {
            for j in (i + 1)..<physicsBodies.count {
                let bodyA = physicsBodies[i]
                let bodyB = physicsBodies[j]

                if !canCollide(bodyA, bodyB) || toBeIgnored(bodyA, bodyB, toIgnore: toIgnore) {
                    continue
                }

                guard let collision = detectCollision(between: bodyA, and: bodyB) else {
                    continue
                }

                currentCollisions.insert(collision)
            }
        }

        publishCollisions(currentCollisions)

        return currentCollisions
    }

    private func toBeIgnored(_ bodyA: PhysicsBody, _ bodyB: PhysicsBody, toIgnore: Set<[PhysicsBody]>) -> Bool {
        toIgnore.contains([bodyA, bodyB]) || toIgnore.contains([bodyB, bodyA])
    }

    private func publishCollisions(_ currentCollisions: Set<Collision>) {
        publishNewCollisions(currentCollisions)
        publishEndedCollisions(currentCollisions)
    }

    private func publishNewCollisions(_ currentCollisions: Set<Collision>) {
        let newCollisions = currentCollisions.subtracting(existingCollisions)
        for collision in newCollisions {
            collisionDelegate?.didBegin(collision)
        }
    }

    private func publishEndedCollisions(_ currentCollisions: Set<Collision>) {
        let endedCollisions = existingCollisions.subtracting(currentCollisions)
        for collision in endedCollisions {
            collisionDelegate?.didEnd(collision)
        }
    }

    private func detectCollision(between bodyA: PhysicsBody, and bodyB: PhysicsBody) -> Collision? {
        let points = bodyA.collider.checkCollision(with: bodyB.collider)

        guard points.hasCollision else {
            return nil
        }

        let collision = Collision(bodyA: bodyA, bodyB: bodyB, collisionPoints: points)
        return collision
    }

    private func canCollide(_ bodyA: PhysicsBody, _ bodyB: PhysicsBody) -> Bool {
        (bodyA.collisionBitmask & bodyB.categoryBitmask != .zero)
        || (bodyA.categoryBitmask & bodyB.collisionBitmask != .zero)
    }

    func resolveCollisions(for physicsBodies: [PhysicsBody], deltaTime: CGFloat, toIgnore: Set<[PhysicsBody]> = Set()) {
        let collisions = detectCollisions(for: physicsBodies, toIgnore: toIgnore)

        for collision in collisions {
            guard [collision.bodyA, collision.bodyB].allSatisfy({ $0.isTrigger == false }) else {
                continue
            }
            let collisionPoints = collision.collisionPoints
            let bodyA = collision.bodyA
            let bodyB = collision.bodyB

            // only handle dynamic-static, dynamic-dynamic collision
            if bodyA.isDynamic && !bodyB.isDynamic {
                resolveCollision(dynamicBody: bodyA,
                                 staticBody: bodyB,
                                 normal: collisionPoints.normal,
                                 depth: collisionPoints.depth,
                                 deltaTime: deltaTime)
            } else if bodyB.isDynamic && !bodyA.isDynamic {
                resolveCollision(dynamicBody: bodyB,
                                 staticBody: bodyA,
                                 normal: -collisionPoints.normal,
                                 depth: collisionPoints.depth,
                                 deltaTime: deltaTime)
            } else if bodyB.isDynamic && bodyA.isDynamic {
                resolveDynamicCollision(bodyA: bodyA,
                                        bodyB: bodyB,
                                        normal: collisionPoints.normal,
                                        depth: collisionPoints.depth,
                                        deltaTime: deltaTime)
            }
        }
    }

    private func resolveCollision(dynamicBody: PhysicsBody,
                                  staticBody: PhysicsBody,
                                  normal: CGVector,
                                  depth: CGFloat,
                                  deltaTime: CGFloat) {
        // Decouple physics bodies
        dynamicBody.position += normal

        let velocity = dynamicBody.velocity
        let angle = normal.angle

        dynamicBody.velocity = CGVector(
            dx: -velocity.dx * cos(2 * angle) - velocity.dy * sin(2 * angle),
            dy: -velocity.dx * sin(2 * angle) + velocity.dy * cos(2 * angle)
        ) * dynamicBody.restitution
    }

    private func resolveDynamicCollision(bodyA: PhysicsBody, bodyB: PhysicsBody, normal: CGVector, depth: CGFloat, deltaTime: CGFloat) {
        guard bodyA.isDynamic && bodyB.isDynamic else {
            return
        }

        let relativeVelocity = bodyA.velocity - bodyB.velocity
        let velocityAlongNormal = relativeVelocity.dot(normal.unitVector)

        if velocityAlongNormal > 0 {
            return
        }

        let e = min(bodyA.restitution, bodyB.restitution)

        let impulseScalar = -(1 + e) * velocityAlongNormal / (1 / bodyA.mass + 1 / bodyB.mass)

        let impulse = normal.unitVector * impulseScalar
        bodyA.velocity += impulse / bodyA.mass
        bodyB.velocity -= impulse / bodyB.mass
    }
}
