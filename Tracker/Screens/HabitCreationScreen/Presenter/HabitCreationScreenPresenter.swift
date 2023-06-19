//
//  HabitCreationScreenPresenter.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 14.06.2023.
//

import UIKit

final class HabitCreationScreenPresenter {
    private weak var controller: HabitCreationScreenController?
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors: [UIColor] = [
        .clr0, .clr1, .clr2, .clr3, .clr4, .clr5,
        .clr6, .clr7, .clr8, .clr9, .clr10, .clr11,
        .clr12, .clr13, .clr14, .clr15, .clr16, .clr17
    ]

    private var selectedCategory: String = ""
    private var selectedDaysRaw: [String] = []
    private var selectedDays: [String] = []
    private var selectedEmoji: String = ""
    private var selectedColor: UIColor?
    private var selectedSchedule: [WeekDay] = []

    init(controller: HabitCreationScreenController? = nil) {
        self.controller = controller
        if controller?.isNonRegularEvent ?? false {
            let currentWeekDay = WeekDay.getWeekDay(for: Date())
            if let dayKey = WeekDay.getShortWeekDay(for: currentWeekDay.rawValue) {
                selectedDays.append(dayKey)
            }
        }
    }

    func getNumberOfItems(forCollectionView collectionView: UICollectionView) -> Int {
        collectionView.tag == 1 ? emojis.count : colors.count
    }

    func getItemSize(forCollectionView collectionView: UICollectionView) -> CGSize {
        return CGSize(width: 52, height: 52)
    }

    func getLineSpacing(forCollectionView collectionView: UICollectionView) -> CGFloat {
        0
    }

    func getItemSpacing(forCollectionView collectionView: UICollectionView) -> CGFloat {
        (UIScreen.main.bounds.width / 86)
    }

    func setupCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = (tableView.dequeueReusableCell(
                withIdentifier: String(describing: CategoryCellView.self),
                for: indexPath
            ) as? CategoryCellView) ?? UITableViewCell()
            
            if controller?.isNonRegularEvent ?? false {
                cell.separatorInset = UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: tableView.bounds.width
                )
            } else {
                cell.separatorInset = UIEdgeInsets(
                    top: 0,
                    left: 15,
                    bottom: 0,
                    right: 15
                )
            }
        } else {
            cell = (tableView.dequeueReusableCell(
                withIdentifier: String(
                    describing: ScheduleCellView.self
                ),
                for: indexPath
            ) as? ScheduleCellView) ?? UITableViewCell()
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: tableView.bounds.width
            )
        }
        cell.tintColor = .appGray
        cell.backgroundColor = .clear
        let systemImage = UIImage(systemName: "chevron.right")
        let imageView  = UIImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: (systemImage?.size.width) ?? 0,
                height: (systemImage?.size.height) ?? 0)
        )
        imageView.image = systemImage
        cell.accessoryView = imageView
        return cell
    }

    func setupCell(
        collectionView: UICollectionView,
        indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(
                    describing: EmojiCellView.self
                ),
                for: indexPath) as? EmojiCellView {
                cell.emojiIconLabel.text = emojis[indexPath.row]
                return cell
            }
        } else if collectionView.tag == 2 {
            if let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(
                    describing: ColorCellView.self
                ),
                for: indexPath) as? ColorCellView {
                cell.colorView.backgroundColor = colors[indexPath.row]
                cell.frameView.layer.borderColor = colors[indexPath.row].withAlphaComponent(0.3).cgColor
                return cell
            }
        }
        return UICollectionViewCell()
    }

    func setSelectedEmoji(emoji: String) {
        selectedEmoji = emoji
    }

    func setSelectedColor(color: UIColor?) {
        selectedColor = color
    }

    func canHabitBeCreated() -> Bool {
        guard !(controller?.screenView.trackerTitleTextField.text ?? "").isEmpty,
              !selectedCategory.isEmpty,
              !selectedDays.isEmpty,
              !selectedEmoji.isEmpty,
              selectedColor != nil else {
            return false
        }
        return true
    }

    func createNewTracker() -> TrackerCategory {
        let isSingleDate = controller?.isNonRegularEvent ?? false
        
        let schedule = isSingleDate ? [WeekDay.getWeekDay(for: Date())] : selectedSchedule
        
        return TrackerCategory(
            title: selectedCategory,
            trackers: [
                        Tracker(id: UUID(),
                                name: controller?.screenView.trackerTitleTextField.text ?? "",
                                emoji: selectedEmoji,
                                color: selectedColor ?? UIColor(),
                                schedule: schedule)
                    ]
        )
    }
}

extension HabitCreationScreenPresenter: ScheduleConfigurationDelegate {
    var alreadySelectedSchedule: [String] {
        selectedDaysRaw
    }

    func updateSchedule(withDays days: [String]) {
        selectedDays = []
        selectedDaysRaw = days
        guard let cell = controller?.screenView.optionsTableView.cellForRow(
            at: IndexPath(row: 1, section: 0)
        ) as? ScheduleCellView else {
            return
        }
        
        days.forEach { item in
            if let scheduleItem = WeekDay(rawValue: item) {
                selectedSchedule.append(scheduleItem)
            }

            if let shortDay = WeekDay.getShortWeekDay(for: item) {
                selectedDays.append(shortDay)
            }
        }
        
        if days.count == 7 {
            cell.infoLabel.text = "Каждый день"
        } else {
            cell.infoLabel.text = String(selectedDays.joined(separator: ", "))
        }
        
        cell.infoLabel.isHidden = false
        controller?.unlockCreateButtonIfPossible()
    }
}

extension HabitCreationScreenPresenter: TrackerCategoryConfigurationDelegate {
    var previousSelectedCategory: String {
        selectedCategory
    }

    func updateCategory(withCategory category: String) {
        selectedCategory = category
        guard let cell = controller?.screenView.optionsTableView.cellForRow(
            at: IndexPath(row: 0, section: 0)
        ) as? CategoryCellView else {
            return
        }
        cell.infoLabel.text = selectedCategory
        cell.infoLabel.isHidden = false
        controller?.unlockCreateButtonIfPossible()
    }
}
