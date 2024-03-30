//
//  Nexus+Extensions.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 15/3/24.
//

import Foundation

extension Nexus {
    func addCharacterForPlayerA() {
        let entity = Entity()
        let renderableComponent = RenderableComponent(entity: entity, position: CGPoint(x: 200, y: 200), objectType: .character(.normal))
        let playerComponent = PlayerComponent(entity: entity)
        let jumpStateComponent = JumpStateComponent(entity: entity)
        let inventoryComponent = InventoryComponent(entity: entity)
        let cameraComponent = CameraComponent(entity: entity)
        let attackableComponent = AttackableComponent(entity: entity, attackStyle: MeleeAttackStyle())
        let destroyableComponent = DestroyableComponent(entity: entity, lives: 3, maxLives: 3)
        addComponents([renderableComponent, playerComponent, jumpStateComponent, inventoryComponent, cameraComponent,
                       attackableComponent, destroyableComponent], to: entity)
    }

    /// Factory to create entities
    func addEntity(type: ObjectType) {
        let entity = Entity()
        var factory: EntityFactory
        switch type {
        case .enemy(let enemyType):
            factory = getEnemyFactory(type: enemyType, from: entity)
        case .block(let blockType):
            factory = getBlockFactory(type: blockType, from: entity)
        case .collectable(let collectableType):
            factory = getCollectableFactory(type: collectableType, from: entity)
        case .powerup(let powerupType):
            factory = getPowerupFactory(type: powerupType, from: entity)
        case .character(let characterType):
            factory = getCharacterFactory(type: characterType, from: entity)
        }
        let components = factory.createComponents()
        addComponents(components, to: entity)
    }
}

extension Nexus {
    private func getEnemyFactory(type: EnemyType, from entity: Entity) -> EntityFactory {
        switch type {
        case .normal:
            return getNormalEnemyFactory(from: entity)
        case .fast:
            fatalError("TODO: implement")
        case .stationary:
            fatalError("TODO: implement")
        case .turret:
            fatalError("TODO: implement")
        }
    }

    private func getBlockFactory(type: BlockType, from entity: Entity) -> EntityFactory {
        switch type {
        case .normal:
            return getNormalBlockFactory(from: entity)
        case .ground:
            return getGroundBlockFactory(from: entity)
        case .breakable:
            fatalError("TODO: implement")
        case .pushable:
            fatalError("TODO: implement")
        case .spike:
            fatalError("TODO: implement")
        case .powerup:
            fatalError("TODO: implement")
        }
    }

    private func getCollectableFactory(type: CollectableType, from entity: Entity) -> EntityFactory {
        switch type {
        case .coin:
            return getCoinCollectableFactory(from: entity)
        case .carrot:
            return getCarrotCollectableFactory(from: entity)
        case .heart:
            return getHeartCollectableFactory(from: entity)
        }
    }

    private func getPowerupFactory(type: PowerupType, from entity: Entity) -> EntityFactory {
        switch type {
        case .attack:
            fatalError("TODO: implement")
        case .doubleJump:
            return getDoubleJumpPowerupFactory(from: entity)
        case .invinsible:
            return getInvinsiblePowerupFactory(from: entity)
        case .strength:
            return getStrengthPowerupFactory(from: entity)
        }
    }

    private func getCharacterFactory(type: CharacterType, from entity: Entity) -> EntityFactory {
        switch type {
        case .normal:
            fatalError("TODO: implement")
        }
    }
}

// MARK: Enemies
extension Nexus {
    private func getNormalEnemyFactory(from entity: Entity) -> EntityFactory {
        // TODO: get this from persistence
        let normalEnemyBoardObject = Enemy(enemyType: .normal)
        return NormalEnemyFactory(from: normalEnemyBoardObject, to: entity)
    }
}

// MARK: Blocks
extension Nexus {
    private func getNormalBlockFactory(from entity: Entity) -> EntityFactory {
        // TODO: get this from persistence
        let normalBlockBoardObject = Block(blockType: .normal, containedPowerupType: nil)
        return NormalBlockFactory(from: normalBlockBoardObject, to: entity)
    }

    private func getGroundBlockFactory(from entity: Entity) -> EntityFactory {
        // TODO: get this from persistence
        let groundBlockBoardObject = Block(blockType: .ground, containedPowerupType: nil)
        return GroundBlockFactory(from: groundBlockBoardObject, to: entity)
    }
}

// MARK: Powerups
extension Nexus {
    private func getStrengthPowerupFactory(from entity: Entity) -> EntityFactory {
        let strengthPowerupBoardObject = Powerup(powerupType: .strength, position: CGPoint(x: 200.0, y: 200.0))
        return StrengthPowerupFactory(boardObject: strengthPowerupBoardObject, entity: entity)
    }

    private func getInvinsiblePowerupFactory(from entity: Entity) -> EntityFactory {
        let invinsiblePowerupBoardObject = Powerup(powerupType: .invinsible, position: CGPoint(x: 300.0, y: 200.0))
        return StrengthPowerupFactory(boardObject: invinsiblePowerupBoardObject, entity: entity)
    }

    private func getDoubleJumpPowerupFactory(from entity: Entity) -> EntityFactory {
        let doubleJumpPowerupBoardObject = Powerup(powerupType: .doubleJump, position: CGPoint(x: 300.0, y: 200.0))
        return StrengthPowerupFactory(boardObject: doubleJumpPowerupBoardObject, entity: entity)
    }
}

// MARK: Collectables
extension Nexus {
    private func getCoinCollectableFactory(from entity: Entity) -> EntityFactory {
        let coinCollectableBoardObject = Collectable(collectableType: .coin)
        return CoinCollectableFactory(boardObject: coinCollectableBoardObject, entity: entity)
    }

    private func getCarrotCollectableFactory(from entity: Entity) -> EntityFactory {
        let carrotCollectableBoardObject = Collectable(collectableType: .carrot)
        return DoubleJumpPowerupFactory(boardObject: carrotCollectableBoardObject, entity: entity)
    }

    private func getHeartCollectableFactory(from entity: Entity) -> EntityFactory {
        let heartCollectableBoardObject = Collectable(collectableType: .heart)
        return HeartCollectableFactory(boardObject: heartCollectableBoardObject, entity: entity)
    }
}
