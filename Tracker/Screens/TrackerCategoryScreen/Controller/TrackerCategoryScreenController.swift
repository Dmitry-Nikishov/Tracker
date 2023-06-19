//
//  TrackerCategoryScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 19.06.2023.
//

import UIKit

protocol TrackerCategoryConfigurationDelegate: AnyObject {
    var previousSelectedCategory: String { get }
    func updateCategory(withCategory category: String)
}

final class TrackerCategoryScreenController: StyledScreenController {
    let screenView = TrackerCategoryScreenView()
    private var presenter: TrackerCategoryScreenPresenter?
    weak var delegate: TrackerCategoryConfigurationDelegate?

    private func setupConstraints() {
        let constraints = [
            screenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenView.topAnchor.constraint(equalTo: view.topAnchor),
            screenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    private func setupSubViews() {
        view.backgroundColor = .appWhite
        view.addSubview(screenView)
        setupConstraints()
        setTableViewVisibleState(isToBeHidden: true)
        presenter = TrackerCategoryScreenPresenter(controller: self)
        presenter?.setPreviouslySelectedCategory(
            with: delegate?.previousSelectedCategory ?? ""
        )
        screenView.delegate = self
        screenView.categoriesTableView.dataSource = self
        screenView.categoriesTableView.delegate = self
    }
    
    convenience init(delegate: TrackerCategoryConfigurationDelegate?) {
        self.init()
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    func setTableViewVisibleState(isToBeHidden: Bool) {
        if isToBeHidden {
            screenView.noDataImageView.isHidden = false
            screenView.noDataLabel.isHidden = false
            screenView.categoriesTableView.isHidden = true
        } else {
            screenView.noDataImageView.isHidden = true
            screenView.noDataLabel.isHidden = true
            screenView.categoriesTableView.isHidden = false
        }
    }
    
    func showAlertWhenDeleting(for indexPath: IndexPath) {
        let controller = UIAlertController(
            title: "Эта категория точно не нужна?",
            message: nil,
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(
            title: "Удалить",
            style: .destructive
        ) { [weak self] _ in
            self?.presenter?.deleteCategoryFromStore(at: indexPath.row)
            self?.screenView.categoriesTableView.reloadData()
            self?.presenter?.updateTableViewVisibility()
        }
        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel
        )
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }

}

extension TrackerCategoryScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getNumberOfCategories() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.configureCell(forTableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension TrackerCategoryScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateCategory(
            withCategory: presenter?.getSelectedCategory(forIndexPath: indexPath) ?? ""
        )
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            return UIMenu(children: [
                UIAction(title: "Редактировать") { _ in
                    self?.presenter?.editCategory(at: indexPath.row)
                },
                UIAction(title: "Удалить", attributes: .destructive) { _ in
                    self?.showAlertWhenDeleting(for: indexPath)
                }
            ])
        })
    }
}

extension TrackerCategoryScreenController: TrackerCategoryScreenViewDelegate {
    func createNewCategory() {
        present(CategoryCreationScreenController(delegate: presenter), animated: true)
    }
}

