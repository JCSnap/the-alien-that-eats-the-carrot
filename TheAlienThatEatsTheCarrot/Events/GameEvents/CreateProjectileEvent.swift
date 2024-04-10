//
//  CreateProjectileEvent.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 10/4/24.
//

import Foundation

struct CreateProjectileEvent: Event {
    static var name: Notification.Name = .createProjectile
    let projectileType: ProjectileType
    let position: CGPoint
    let velocity: CGVector
    let size: CGSize
}

extension Notification.Name {
    static let createProjectile = Notification.Name("createProjectile")
}
