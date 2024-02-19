//
//  Router.swift
//  coloss
//
//  Created by Dev on 13.02.24.
//

import Foundation
import Observation


final class Router: ObservableObject {
    @Published var plantRoutes: [PlantRoute] = []
}

enum PlantRoute: Hashable {
    case place(String)
    case group(String)
    case plant(String)
}
