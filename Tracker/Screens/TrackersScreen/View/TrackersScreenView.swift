//
//  TrackersScreenView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 08.06.2023.
//

import UIKit

protocol TrackersScreenViewDelegate: AnyObject {
    func discardSearch()
}

final class TrackersScreenView: UIView {
    weak var delegate: TrackersScreenViewDelegate?
    
    lazy var dummyImage = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "dizzy")
        return view
    }()
    
    lazy var dummyLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .appBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.text = "Что будем отслеживать?"
        return label
    }()
    
    lazy var stackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 14
        return view
    }()
    
    lazy var searchTextField = {
        let view = UISearchTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Поиск"
        view.backgroundColor = .appLightGray.withAlphaComponent(0.12)
        view.textColor = .appBlack
        view.attributedPlaceholder = NSAttributedString(
            string: view.placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.appGray
            ]
        )
//        if let leftView = view.leftView as? UIImageView {
//            leftView.tintColor = UIColor.appGray
//            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
//        }
        view.clearButtonMode = .never
        return view
    }()
    
    lazy var discardButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("Отменить", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addTarget(
            nil,
            action: #selector(discardButtonTapped),
            for: .touchUpInside
        )

        view.setTitleColor(.appBlue, for: .normal)
        view.isHidden = true
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(
            TrackerCollectionCell.self,
            forCellWithReuseIdentifier: String(
                describing: TrackerCollectionCell.self
            )
        )
        view.register(
            TrackerScreenHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: TrackerScreenHeaderView.self)
        )
        view.allowsMultipleSelection = false
        view.contentInset = UIEdgeInsets(
            top: 24,
            left: 0,
            bottom: 80,
            right: 0
        )
        view.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return view
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .appBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.appWhite, for: .normal)
        button.setTitle("Фильтры", for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    private func setupSubViews() {
        translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(discardButton)

        self.addSubview(dummyImage)
        self.addSubview(dummyLabel)
        self.addSubview(stackView)
        self.addSubview(collectionView)
        self.addSubview(filterButton)
        
        let constraints = [
            dummyImage.heightAnchor.constraint(equalToConstant: 80),
            dummyImage.widthAnchor.constraint(equalTo: dummyImage.heightAnchor),
            dummyImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            dummyImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            dummyLabel.topAnchor.constraint(equalTo: dummyImage.bottomAnchor, constant: 8),
            dummyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -17)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init? not implemented here")
    }
        
    @objc private func discardButtonTapped() {
        delegate?.discardSearch()
    }
}
