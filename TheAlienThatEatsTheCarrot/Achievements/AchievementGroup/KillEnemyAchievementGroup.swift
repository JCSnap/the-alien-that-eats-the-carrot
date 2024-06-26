//
//  KillEnemyAchievementGroup.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 11/4/24.
//

import Foundation

class KillEnemyAchievementGroup: AchievementGroup {
    weak var achievementManagerDelegate: AchievementManagerDelegate?
    var achievementTiers: [Achievement]
    private var enemiesKilledStatusUpdateObserver: NSObjectProtocol?

    init() {
        self.achievementTiers = [
            KillEnemies(criterion: 1),
            KillEnemies(criterion: 5),
            KillEnemies(criterion: 10),
            KillEnemies(criterion: 25),
            KillEnemies(criterion: 50),
            KillEnemies(criterion: 100),
            KillEnemies(criterion: 250),
            KillEnemies(criterion: 1_000)
        ]
    }

    deinit {
        if let observer1 = enemiesKilledStatusUpdateObserver {
            EventManager.shared.unsubscribe(from: observer1)
        }
    }

    func subscribeToEvents() {
        enemiesKilledStatusUpdateObserver = EventManager.shared.subscribe(to: EnemiesKilledStatUpdateEvent.self, using: onEnemiesKilledStatUpdated)
    }

    private lazy var onEnemiesKilledStatUpdated = { [weak self] (_ event: Event) -> Void in
        guard let self = self,
              let statUpdateEvent = event as? EnemiesKilledStatUpdateEvent else {
                  return
              }
        self.checkIfCompleted(gameStats: statUpdateEvent.gameStats)
    }
}

extension KillEnemyAchievementGroup {
    class KillEnemies: Achievement {
        let criterion: Int
        var isCompleted = false
        let isRepeatable = true
        var name: String {
            "Kill \(criterion) enemies"
        }

        init(criterion: Int) {
            self.criterion = criterion
        }

        func checkIfCompleted(gameStats: GameStats?) -> Bool {
            guard let gameStats = gameStats else {
                return false
            }
            if !isCompleted && gameStats.enemiesKilled >= criterion {
                isCompleted = true
                return true
            }
            return false
        }
    }
}
