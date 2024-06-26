//
//  GameEngine.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 11/3/24.
//

import CoreGraphics
import Combine

class GameEngine {
    let nexus = Nexus()
    var systems: [System]
    let physicsWorld = PhysicsWorld()

    let gameMode: GameMode = .normal
    let gameBounds: CGRect
    let gameStats: GameStats
    let gameDuration: CGFloat
    weak var gameLoop: GameLoop?

    init(level: Level,
         bounds: CGRect,
         gameDuration: CGFloat = GameConstants.DEFAULT_GAME_DURATION) {
        self.systems = []
        self.gameBounds = bounds
        self.gameStats = GameStats(nexus: nexus)
        self.gameDuration = gameDuration
        initGameSystems()
        initGameEntities(from: level.boardObjects.allObjects)
        createGameState()
        createCountdown()

        EventManager.shared.postEvent(GameStartEvent())
    }

    func pause() {
        setGameState(gameState: .pause)
    }

    func unpause() {
        setGameState(gameState: .ongoing)
    }

    func end() {
        self.gameLoop?.stop()
        setGameState(gameState: .gameOver)
    }

    private func setGameState(gameState: GameState) {
        guard let gameStateComponent = getGameState() else {
            return
        }
        gameStateComponent.gameState = gameState

    }

    func update(deltaTime: CGFloat) {
        guard let gameStateComponent = getGameState() else {
            return
        }
        if gameStateComponent.gameState == .ongoing {
            updateSystems(deltaTime: deltaTime)
        }
    }

    func getRenderableComponents() -> [RenderableComponent] {
        nexus.getComponents(of: RenderableComponent.self)
    }

    func getPlayerPositions() -> [CGPoint] {
        let playerEntities = nexus.getEntities(with: PlayerComponent.self)
        var offsets: [CGPoint] = []
        for playerEntity in playerEntities {
            guard let renderableComponent = nexus.getComponent(of: RenderableComponent.self, for: playerEntity) else {
                continue
            }
            offsets.append(CGPoint(x: renderableComponent.position.x, y: renderableComponent.position.y))
        }
        return offsets
    }

    func getGameStats() -> GameStats {
        self.gameStats.getLatestGameStats()!
    }

    private func updateSystems(deltaTime: CGFloat) {
        systems.forEach { $0.update(deltaTime: deltaTime) }
    }

    // Note that PhysicsSystem < CollisionSystem, CollisionSystem at the end
    // This is so that PhysicsSystem can update the positions, and if collision occur
    // The other systems can handle the side effects (eg. deal damage, add score etc.)
    // Before the collision is resolved by the CollisionSystem
    // PlayerMovementSystem < PhysicsSystem to prevent jump state bug
    private func initGameSystems() {
        self.systems = [PlayerMovementSystem(nexus: nexus),
                        PhysicsSystem(nexus: nexus, physicsWorld: physicsWorld),
                        MovementSystem(nexus: nexus),
                        TimerSystem(nexus: nexus),
                        DamageSystem(nexus: nexus),
                        FrictionalSystem(nexus: nexus),
                        CreateNewEntitiesSystem(nexus: nexus),
                        CollisionSystem(nexus: nexus, physicsWorld: physicsWorld),
                        GameEndSystem(nexus: nexus, gameEngine: self)]
    }

    private func initGameEntities(from boardObjects: [any BoardObject]) {
        let gameSettings = getGameSettings(gameMode: .normal)
        nexus.addGameSettings(for: gameSettings)
        nexus.addGameEntity(with: gameBounds)
        for boardObject in boardObjects {
            nexus.addEntity(from: boardObject)
        }
    }

    private func getGameSettings(gameMode: GameMode) -> GameSettings {
        switch gameMode {
        case .normal:
            return NormalGameSettings()
        }
    }

    private func getGameState() -> GameStateComponent? {
        nexus.getComponent(of: GameStateComponent.self)
    }
}

extension GameEngine {
    func createGameState() {
        let entity = Entity()
        nexus.addComponent(GameStateComponent(entity: entity), to: entity)
    }

    func createCountdown() {
        let entity = Entity()
        nexus.addComponent(TimerComponent(entity: entity, duration: self.gameDuration, event: GameEndEvent(isWin: false)), to: entity)
    }

}
