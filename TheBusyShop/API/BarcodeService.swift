//
//  BarcodeService.swift
//  TheBusyShop
//
//  Created by Antonie on 2020/10/08.
//  Copyright © 2020 Antonie Sander. All rights reserved.
//

import Firebase

public struct BarcodeService {
    static let shared = BarcodeService()
    
    func fetchBarcode(completion: @escaping([BarcodeMeta]) -> Void) {
        
        var codes = [BarcodeMeta]()
        
        DB_REF.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let barcodeId = snapshot.key
            let barcode = BarcodeMeta(uid: barcodeId, itemCount: 0, dictionary: dictionary)
            
            codes.append(barcode)
            completion(codes)
        }
    }
}
