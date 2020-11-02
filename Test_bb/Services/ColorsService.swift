//
//  ColorsService.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public class ColorsService {
    @discardableResult
    static func loadColors() -> Observable<ColorsResponse?> {
        return ApiService.genericRequest(method: .get, endpoint: "interview.json", responseType: ColorsResponse.self)
    }
}
