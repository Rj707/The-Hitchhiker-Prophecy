//
//  HomeScenePresenter.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/13/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation

class HomeScenePresneter: HomeScenePresentationLogic {
    var displayView: HomeSceneDisplayView?
    
    init(displayView: HomeSceneDisplayView) {
        self.displayView = displayView
    }
    
    func presentCharacters(_ response: HomeScene.Search.Response) {
        // TODO: Implement
        switch response {
        case .success(let Output):
            print("")
            self.displayView?.didFetchCharacters(viewModel: Output.data.toHomeSceneViewMode())
        case .failure(let error):
            self.displayView?.failedToFetchCharacters(error: error)
            
        }
    }
}
