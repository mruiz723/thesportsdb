//
//  BasePresenter.swift
//  thesportsdb
//
//  Created by Luis F Ruiz Arroyave on 11/21/18.
//  Copyright © 2018 mruiz723. All rights reserved.
//

import Foundation

protocol BasePresenter {
    associatedtype View
    func attachView(view : View)
    func detachView()
    func destroy()
}
