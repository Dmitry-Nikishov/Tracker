//
//  TrackerCategoryScreenController.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

protocol TrackerCategoryConfigurationDelegate: AnyObject {
    var previousSelectedCategory: String { get }
    func updateCategory(withCategory category: String)
}

final class TrackerCategoryScreenController: StyledScreenController {
    weak var delegate: TrackerCategoryConfigurationDelegate?
    private var viewModel: TrackerCategoryScreenViewModel?

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Категория"
        return view
    }()

    private lazy var noDataImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "dizzy")
        return view
    }()

    private lazy var noDataLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Привычки и события можно объединить по смыслу"
        return view
    }()

    private lazy var categoriesTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.register(
            CategorySelectionCell.self,
            forCellReuseIdentifier: String(describing: CategorySelectionCell.self)
        )
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .appWhite
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBlack
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("Добавить категорию", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(nil, action: #selector(addButtonClicked), for: .touchUpInside)
        return view
    }()
    
    @objc private func addButtonClicked() {
        present(
            CategoryCreationScreenController(
                delegate: viewModel
            ),
            animated: true
        )
    }

    convenience init(
        delegate: TrackerCategoryConfigurationDelegate?,
        viewModel: TrackerCategoryScreenViewModel
    ) {
        self.init()
        self.delegate = delegate
        self.viewModel = viewModel
        setupBindings()
    }
    
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        viewModel.$isData.bind { [weak self] newValue in
            guard let self else { return }
            self.setTableViewVisibleState(isToBeHidden: !newValue)
        }
        
        viewModel.$shouldTableBeReloaded.bind { [weak self] newValue in
            guard let self else { return }
            if newValue {
                self.categoriesTableView.reloadData()
            }
        }
        viewModel.$updates.bind { [weak self] newValue in
            guard let self,
                  let newValue else { return }
            self.categoriesTableView.performBatchUpdates {
                let insertedIndexPaths = newValue.insertedIndexes.map { IndexPath(item: $0, section: 0) }
                let deletedIndexPaths = newValue.deletedIndexes.map { IndexPath(item: $0, section: 0) }
                self.categoriesTableView.insertRows(at: insertedIndexPaths, with: .automatic)
                self.categoriesTableView.deleteRows(at: deletedIndexPaths, with: .fade)
            }
        }
    }

    private func setTableViewVisibleState(isToBeHidden: Bool) {
        if isToBeHidden {
            noDataImageView.isHidden = false
            noDataLabel.isHidden = false
            categoriesTableView.isHidden = true
        } else {
            noDataImageView.isHidden = true
            noDataLabel.isHidden = true
            categoriesTableView.isHidden = false
        }
    }

    private func showAlertWhenDeleting(for indexPath: IndexPath) {
        let controller = UIAlertController(
            title: "Эта категория точно не нужна?",
            message: nil,
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(
            title: "Удалить",
            style: .destructive
        ) { [weak self] _ in
            self?.viewModel?.deleteCategoryFromStore(at: indexPath.row)
            self?.categoriesTableView.reloadData()
            self?.viewModel?.checkDataPresence()
        }
        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel
        )
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }

    private func setupSubViews() {
        view.backgroundColor = .appWhite
        
        view.addSubview(titleLabel)
        view.addSubview(noDataImageView)
        view.addSubview(noDataLabel)
        view.addSubview(categoriesTableView)
        view.addSubview(addButton)

        let constrains = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            noDataImageView.heightAnchor.constraint(equalToConstant: 80),
            noDataImageView.widthAnchor.constraint(equalTo: noDataImageView.heightAnchor),
            noDataImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.topAnchor.constraint(equalTo: noDataImageView.bottomAnchor, constant: 8),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -24)
        ]
        NSLayoutConstraint.activate(constrains)

        viewModel?.setPreviouslySelectedCategory(
            with: delegate?.previousSelectedCategory ?? ""
        )
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
}

extension TrackerCategoryScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfCategories() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel?.configureCell(
            forTableView: tableView,
            atIndexPath: indexPath
        ) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

extension TrackerCategoryScreenController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateCategory(
            withCategory: viewModel?.getSelectedCategory(forIndexPath: indexPath) ?? ""
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
                    guard let viewModel = self?.viewModel else { return }
                    viewModel.editCategory(at: indexPath.row)
                    self?.present(
                        CategoryCreationScreenController(
                            delegate: viewModel
                        ), animated: true
                    )
                },
                UIAction(title: "Удалить", attributes: .destructive) { _ in
                    self?.showAlertWhenDeleting(for: indexPath)
                }
            ])
        })
    }
}


