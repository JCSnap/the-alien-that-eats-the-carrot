//
//  EnemyType+extensions.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by Sun Xinyu on 23/3/24.
//

import CoreData

extension EnemyType: FromDataAble {
  init(data: EnemyTypeData) throws {
    guard let name = data.typeName,
              let type = EnemyType.typeNameToTypeMap[name] else {
            throw TheAlienThatEatsTheCarrotError.invalidObjectTypeDataError(typeName: data.typeName)
        }
        self = type
  }
}

extension EnemyType: ToDataAble {
    func toData(context: NSManagedObjectContext) -> NSManagedObject {
        let enemyTypeData = EnemyTypeData(context: context)
        enemyTypeData.typeName = EnemyType.typeToTypeNameMap[self]
        return enemyTypeData as NSManagedObject
    }
}
