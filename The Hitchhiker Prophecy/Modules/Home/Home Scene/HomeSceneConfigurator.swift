//
//  HomeSceneConfigurator.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/14/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

enum HomeSceneConfigurator {
    static func configure() -> UINavigationController {
        let sb = UIStoryboard.init(name: "Storyboard", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "HomeSceneViewController") as! HomeSceneViewController
        let presenter = HomeScenePresneter(displayView: viewController)
        let worker = HomeSearchWorker()
        let interactor = HomeSceneInteractor(worker: worker, presenter: presenter)
        let router = HomeSceneRouter()
        
        router.dataStore = interactor
        router.viewController = viewController
        viewController.interactor = interactor
        viewController.router = router
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
