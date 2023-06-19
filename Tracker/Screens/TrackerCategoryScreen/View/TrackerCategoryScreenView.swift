//
//  TrackerCategoryScreenView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 16.06.2023.
//

import UIKit

protocol TrackerCategoryScreenViewDelegate: AnyObject {
    func createNewCategory()
}

final class TrackerCategoryScreenView: UIView {
    weak var delegate: TrackerCategoryScreenViewDelegate?

    lazy var titleLabel: UILabel = {
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
    
    lazy var noDataImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "dizzy")
        return view
    }()
    
    lazy var noDataLabel: UILabel = {
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
    
    lazy var categoriesTableView: UITableView = {
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

    lazy var addButton: UIButton = {
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
    
    private func setupSubViews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(noDataImageView)
        addSubview(noDataLabel)
        addSubview(categoriesTableView)
        addSubview(addButton)
        
        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            noDataImageView.heightAnchor.constraint(equalToConstant: 80),
            noDataImageView.widthAnchor.constraint(equalTo: noDataImageView.heightAnchor),
            noDataImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noDataImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            noDataLabel.topAnchor.constraint(equalTo: noDataImageView.bottomAnchor, constant: 8),
            noDataLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoriesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoriesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -24)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented for TrackerCategoryScreenView")
    }
    
    @objc private func addButtonClicked() {
        delegate?.createNewCategory()
    }
}

