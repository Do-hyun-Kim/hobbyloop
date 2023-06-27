//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/05/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let common = Project.makeModule(
  name: "HPCommon",
  products: [.framework(.static)],
  dependencies: [
    .Project.Core.extensions,
    .Project.UI.common
  ]
)

