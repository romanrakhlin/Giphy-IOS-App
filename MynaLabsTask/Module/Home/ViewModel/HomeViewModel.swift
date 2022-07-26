//
//  HomeViewModel.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import Foundation

protocol HomeViewModelProtocol {
    func fetchGIFs(with offset: Int, completion: @escaping ([GiphyData]?, Pagenation?, String?) -> Void)
}

class HomeViewModel: HomeViewModelProtocol {
    
    let networkService: NetworkWorker = NetworkWorker()
    
    func fetchGIFs(with offset: Int, completion: @escaping ([GiphyData]?, Pagenation?, String?) -> Void) {
        networkService.sendRequest(urlRequest: HomeRouter.fetchGIFs.createURLRequest(offset: offset), successModel: GiphyListModel.self) { result in
            switch result {
            case .success(let result):
                guard let data = result.data, let pagination = result.pagination else { return }
                completion(data, pagination, nil)
            case .failure(let error):
                completion(nil, nil, error)
            case .badRequest(let error):
                completion(nil, nil, error.errors?.description)
            }
        }
    }
}
