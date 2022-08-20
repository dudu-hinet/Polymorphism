//
//  ViewController.swift
//  Polymorphism
//
//  Created by MGNE3TA/A on 2022/8/14.
//

import RxSwift
import SnapKit
import UIKit

class ViewController: UIViewController {
	private lazy var _button1: UIButton = {
		let view = UIButton(type: .roundedRect)
		view.setTitle("Change to \n ViewModel1", for: .normal)
		view.titleLabel?.numberOfLines = 0
		view.titleLabel?.textAlignment = .center
		
		return view
	}()
	private lazy var _button2: UIButton = {
		let view = UIButton(type: .roundedRect)
		view.setTitle("Change to \n ViewModel2", for: .normal)
		view.titleLabel?.numberOfLines = 0
		view.titleLabel?.textAlignment = .center
		
		return view
	}()
	private let _disposeBag = DisposeBag()
	private var _table_view: Table_View!
	private var _table_view_disposeBag = DisposeBag()
	private var _viewModel: (Table_View_Source & Table_View_ViewModel)!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		let buttons = self.create_buttons()
		self.view.addSubview(buttons)
		buttons.snp.makeConstraints { make in
			make.bottom.equalToSuperview().labeled("buttons.bottom")
			make.height.equalTo(88).labeled("buttons.height")
			make.left.equalToSuperview().labeled("buttons.left")
			make.right.equalToSuperview().labeled("buttons.right")
		}
		
		self._viewModel = Table_View_ViewModel1()
		self._table_view = Table_View(self._viewModel)
		self.view.addSubview(self._table_view)
		self._table_view.snp.makeConstraints { make in
			make.bottom.equalTo(buttons.snp.top).labeled("_table_view.bottom")
			make.left.equalToSuperview().labeled("_table_view.left")
			make.right.equalToSuperview().labeled("_table_view.right")
			make.top.equalToSuperview().labeled("_table_view.top")
		}

		self.bind()
		self.bind_tableView(self._viewModel)
	}
	
	private func create_buttons() -> UIView {
		let container = UIView()
		let stackView = UIStackView(arrangedSubviews: [self._button1, self._button2])
		stackView.alignment = .center
		stackView.axis = .horizontal
		stackView.backgroundColor = .gray
		stackView.distribution = .fillEqually
		container.addSubview(stackView)
		stackView.snp.makeConstraints { make in
			make.edges.equalToSuperview().labeled("stackView.edges")
		}
		
		return container
	}

	private func bind() -> Void {
		self._button1.rx.tap.throttle(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] in
			self?.bind_tableView(Table_View_ViewModel1())
		}).disposed(by: self._disposeBag)
		self._button2.rx.tap.throttle(.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] in
			self?.bind_tableView(Table_View_ViewModel2())
		}).disposed(by: self._disposeBag)
	}
	
	private func bind_tableView(_ viewModel: Table_View_Source & Table_View_ViewModel) -> Void {
		self._table_view_disposeBag = DisposeBag()
		
		self._viewModel = viewModel
		self._table_view.source = self._viewModel
		self._table_view.on_select.subscribe(onNext: { [weak self] in
			self?._viewModel.on_select($0)
		}).disposed(by: self._table_view_disposeBag)
	}
}
