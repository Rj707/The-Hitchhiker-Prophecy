//
//  HomeSceneInteractor.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/13/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation

class HomeSceneInteractor: HomeSceneDataStore {
    
    let worker: HomeWorkerType
    var presenter: HomeScenePresentationLogic{
        willSet{
            print("Presenter value changed")
            print(self.presenter as Any)
        }
    }
    
    var result: Characters.Search.Results?
    
    init(worker: HomeWorkerType, presenter: HomeScenePresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }
    
    deinit {
            print("\(self) deinit")
        }
}

extension HomeSceneInteractor: HomeSceneBusinessLogic {
    func fetchCharacters() {
        
        let ts = "\(Int(NSDate().timeIntervalSince1970))"
        let hash = "\(ts)\(NetworkConstants.privateKey)\(NetworkConstants.publicKey)".MD5() // TODO: Implement
        let limit = HomeScene.Search.Constants.searchPageLimit
        let offset = result?.offset ?? 0
        let input = Characters.Search.Input(timeStamp: ts, apiKey: NetworkConstants.publicKey, hash: hash, offset: offset, limit: limit, orderBy: .modifiedDateDescending)
        
        worker.getCharacters(input) { [weak self] (result) in
            switch result {
            case .success(let value):
                var newData = value
                var oldCharacters = self?.result?.results ?? []
                oldCharacters.append(contentsOf: newData.data.results)
                newData.data.results = oldCharacters
                self?.result = newData.data
            case .failure(let error):
                print(error)
            }
            self?.presenter.presentCharacters(result)
        }
    }
}
