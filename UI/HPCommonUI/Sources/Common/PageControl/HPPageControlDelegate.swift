//
//  HPPageControlDelegate.swift
//  HPCommonUI
//
//  Created by 김남건 on 2023/08/30.
//

import Foundation

public protocol HPPageControlDelegate: AnyObject {
    func didChangePage(to page: Int)
}
