//
//  ViewModel2.swift
//  Polymorphism
//
//  Created by MGNE3TA/A on 2022/8/14.
//

import RxRelay
import RxSwift

class Table_View_ViewModel2 {
	private let _disposeBag = DisposeBag()
	private let _is_selected = BehaviorRelay<Bool>(value: false)
	private let _now = BehaviorRelay<String>(value: "\(Date(timeIntervalSinceNow: 0))")
	
	init() {
		Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
			.map { _ in return "\(Date(timeIntervalSinceNow: 0))" }
			.bind(to: self._now)
			.disposed(by: self._disposeBag)
	}
}
extension Table_View_ViewModel2: Table_View_ViewModel {
	func on_select(_ row: Table_View.Row) -> Void {
		self._is_selected.accept(!self._is_selected.value)
	}
}
extension Table_View_ViewModel2: Table_View_Source {
	var rows: Observable<Array<Table_View.Row>> {
		return Observable.of([
			.default_row(self._is_selected.map { "ViewModel2 selected: \($0)" }.asObservable()),
			.value2_row(Observable.of("Now:"), self._now.asObservable())
		])
	}
}
