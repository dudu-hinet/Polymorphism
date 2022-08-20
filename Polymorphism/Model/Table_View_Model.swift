//
//  Table_View_Model.swift
//  Polymorphism
//
//  Created by MGNE3TA/A on 2022/8/19.
//

import Foundation

protocol Table_View_ViewModel {
	func on_select(_ row: Table_View.Row) -> Void
}
