//
//  ViewModel1.swift
//  Polymorphism
//
//  Created by MGNE3TA/A on 2022/8/14.
//

import RxRelay
import RxSwift

class Table_View_ViewModel1 {
	private let _is_selected = BehaviorRelay<Bool>(value: false)
}
extension Table_View_ViewModel1: Table_View_ViewModel {
	func on_select(_ row: Table_View.Row) -> Void {
		self._is_selected.accept(!self._is_selected.value)
	}
}
extension Table_View_ViewModel1: Table_View_Source {
	var rows: Observable<Array<Table_View.Row>> {
		Observable.of([
			.default_row(self._is_selected.map { "ViewModel1 selected: \($0)" }.asObservable()),
		])
	}
}
