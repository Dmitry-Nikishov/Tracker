//
//  HabitCreationScreenView.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 14.06.2023.
//

import UIKit

protocol HabitCreationScreenViewDelegate: AnyObject {
    func createNewTracker()
    func cancelNewTrackerCreation()
}

final class HabitCreationScreenView: UIView {
    weak var delegate: HabitCreationScreenViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Новая привычка"
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: 820
        )
        view.isPagingEnabled = false
        view.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    
    lazy var trackerTitleTextField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Введите название трекера"
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .appGray.withAlphaComponent(0.3)
        view.clearButtonMode = .whileEditing
        view.leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 15,
                height: view.frame.height
            )
        )
        view.leftViewMode = .always
        return view
    }()
    
    lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        view.textColor = .appRed
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Ограничение кол-ва символов : 38"
        view.isHidden = true
        return view
    }()

    lazy var optionsTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .appGray.withAlphaComponent(0.3)

        view.register(
            CategoryCellView.self,
            forCellReuseIdentifier: String(describing: CategoryCellView.self)
        )
        view.register(
            ScheduleCellView.self,
            forCellReuseIdentifier: String(describing: ScheduleCellView.self)
        )
        return view
    }()
    
    private lazy var emojiTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Emoji"
        return view
    }()
    
    lazy var emojiCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(
            EmojiCellView.self,
            forCellWithReuseIdentifier: String(
                describing: EmojiCellView.self
            )
        )
        view.allowsMultipleSelection = false
        view.tag = 1
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var colorTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        view.textColor = .appBlack
        view.textAlignment = .center
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7
        view.text = "Цвет"
        return view
    }()
    
    lazy var colorCollectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsMultipleSelection = false
        view.tag = 2
        view.backgroundColor = .clear
        view.register(
            ColorCellView.self,
            forCellWithReuseIdentifier: String(
                describing: ColorCellView.self
            )
        )
        return view
    }()
    
    private lazy var tapsView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appWhite
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appRed, for: .normal)
        view.setTitle("Отменить", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appRedLight.cgColor
        view.addTarget(
            nil,
            action: #selector(cancelButtonClicked),
            for: .touchUpInside
        )
        
        return view
    }()
    
    lazy var createButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appGray
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.setTitleColor(.appWhite, for: .normal)
        view.setTitle("Создать", for: .normal)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.isEnabled = false
        view.addTarget(
            nil,
            action: #selector(createButtonClicked),
            for: .touchUpInside
        )
        return view
    }()

    private func setupSubViews() {
        addSubview(titleLabel)
        
        stackView.addArrangedSubview(trackerTitleTextField)
        stackView.addArrangedSubview(errorLabel)
        
        scrollView.addSubview(stackView)
        scrollView.addSubview(optionsTableView)
        scrollView.addSubview(emojiTitleLabel)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorTitleLabel)
        scrollView.addSubview(colorCollectionView)
        
        tapsView.addArrangedSubview(cancelButton)
        tapsView.addArrangedSubview(createButton)
        
        scrollView.addSubview(tapsView)
        addSubview(scrollView)
        
        let constraints = [
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            trackerTitleTextField.heightAnchor.constraint(equalToConstant: 75),
            optionsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            optionsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            optionsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            emojiTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            emojiTitleLabel.topAnchor.constraint(
                equalTo: optionsTableView.bottomAnchor,
                constant: 32
            ),
            emojiCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emojiCollectionView.topAnchor.constraint(
                equalTo: emojiTitleLabel.bottomAnchor,
                constant: 32
            ),
            emojiCollectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 156),
            colorTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            colorTitleLabel.topAnchor.constraint(
                equalTo: emojiCollectionView.bottomAnchor,
                constant: 32
            ),
            colorCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            colorCollectionView.topAnchor.constraint(
                equalTo: colorTitleLabel.bottomAnchor,
                constant: 32
            ),
            colorCollectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 156),
            tapsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tapsView.topAnchor.constraint(
                equalTo: colorCollectionView.bottomAnchor,
                constant: 30
            ),
            tapsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tapsView.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelButtonClicked() {
        delegate?.cancelNewTrackerCreation()
    }

    @objc private func createButtonClicked() {
        delegate?.createNewTracker()
    }
}


