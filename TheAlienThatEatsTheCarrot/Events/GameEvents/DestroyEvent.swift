//
//  DestroyEvent.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Justin Cheah Yun Fei on 30/3/24.
//

import Foundation

class DestroyEvent: Event {
    static var name: Notification.Name = .destroy
    let entity: Entity

    init(entity: Entity) {
        self.entity = entity
    }
}

extension Notification.Name {
    static let destroy = Notification.Name("destroy")
}