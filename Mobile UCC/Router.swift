//
//  Router.swift
//  Mobile UCC
//
//  Created by MacbookPRO on 15/05/19.
//  Copyright © 2019 LabSE Siskom. All rights reserved.
//

import Foundation

protocol Router {
    func route (
        to routeID: String,
        from context: UIViewController,
        parameters: Any?
    )
}
