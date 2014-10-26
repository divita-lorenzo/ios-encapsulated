//
//  Util.swift
//  QapaEncapsulated
//
//  Created by Lorenzo DI VITA on 06/10/2014.
//  Copyright (c) 2014 Lorenzo DI VITA. All rights reserved.
//

import UIKit

// Constants
let qapaMobileRootUrl = "http://m.qapa.fr"
let qapaMobilePath = "/mobile"
let qapaHomePath = "/index/index"

func createUrlRequest(urlString: String!) -> NSURLRequest
{
    let url = NSURL(string: urlString)
    return NSURLRequest(URL: url!)
}