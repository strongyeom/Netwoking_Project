//
//  BeerViewModel.swift
//  Netwoking_Project
//
//  Created by 염성필 on 2023/09/14.
//

import Foundation

class BeerViewModel {
    
    let list = Observable<[Beer]>([])
    
    func callRequst() {
        NetworkManager.shared.callRequest { beer in
            self.list.value = beer
            
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return list.value.count
    }
    
    func tableCellForRowAt(indexPath: IndexPath) -> Beer {
        return list.value[indexPath.row]
    }
    
    func collectionCellForRowAt(indexPath: IndexPath) -> Beer {
        return list.value[indexPath.item]
    }
    
    
}
