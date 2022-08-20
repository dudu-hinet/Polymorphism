//
//  TableView.swift
//  Polymorphism
//
//  Created by MGNE3TA/A on 2022/8/14.
//

import RxDataSources
import RxSwift
import UIKit

protocol Table_View_Source {
	var rows: Observable<Array<Table_View.Row>> { get }
}

protocol Table_View_Protocol {
	var on_select: Observable<Table_View.Row> { get }
}

private class Table_View_Cell: UITableViewCell {
	let disposeBag = DisposeBag()
}

class Table_View: UITableView, Table_View_Protocol {
	enum Row: Equatable, IdentifiableType {
		case default_row(Observable<String>)
		case value2_row(Observable<String>, Observable<String>)
		
		static func == (lhs: Table_View.Row, rhs: Table_View.Row) -> Bool {
			return lhs.identity == rhs.identity
		}
		var identity: String { return "\(self)" }
	}
	
	var on_select: Observable<Row> { return self._on_select.asObservable() }
	var source: Table_View_Source {
		didSet {
			self.bind()
		}
	}
	
	private var _disposeBag = DisposeBag()
	private let _on_select = PublishSubject<Row>()
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(_ source: Table_View_Source) {
		self.source = source
		super.init(frame: .zero, style: .plain)
		
		self.bind()
	}
	
	private func bind() -> Void {
		self._disposeBag = DisposeBag()
		
		self.source.rows.subscribeOn(ConcurrentMainScheduler.instance)
			.map { return [AnimatableSectionModel(model: "", items: $0)] }
			.subscribeOn(ConcurrentMainScheduler.instance)
			.bind(to: self.rx.items(dataSource: self.get_dataSource()))
			.disposed(by: self._disposeBag)
		self.rx.modelSelected(Row.self)
			.bind(to: self._on_select)
			.disposed(by: self._disposeBag)
	}
	
	private func get_dataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Row>> {
		return RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Row>>(
			configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
				switch dataSource[indexPath] {
				case .default_row(let title):
					let table_cell = tableView.dequeueReusableCell(withIdentifier: "Default_Cell") as? Table_View_Cell ?? {
						return Table_View_Cell(style: .default, reuseIdentifier: "Default_Cell")
					}()
					guard let textLabel = table_cell.textLabel else {
						return table_cell
					}
					
					title.bind(to: textLabel.rx.text).disposed(by: table_cell.disposeBag)
					
					return table_cell
					
				case .value2_row(let title, let text):
					let table_cell = tableView.dequeueReusableCell(withIdentifier: "Value2_Cell") as? Table_View_Cell ?? {
						return Table_View_Cell(style: .value2, reuseIdentifier: "Value2_Cell")
					}()
					guard let textLabel = table_cell.textLabel,
							let detailTextLabel = table_cell.detailTextLabel else {
						return table_cell
					}
					
					title.bind(to: textLabel.rx.text).disposed(by: table_cell.disposeBag)
					text.bind(to: detailTextLabel.rx.text).disposed(by: table_cell.disposeBag)
					
					return table_cell
				}
			})
	}
}
