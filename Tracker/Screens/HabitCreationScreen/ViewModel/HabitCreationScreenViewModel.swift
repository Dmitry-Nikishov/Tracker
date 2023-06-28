//
//  HabitCreationScreenViewModel.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 27.06.2023.
//

import UIKit

final class HabitCreationScreenViewModel {
    @Observable
    private(set) var shouldCreateButtonBeUnlocked: Bool = false

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
    private var trackerName: String = ""
    private var isNonRegularEvent: Bool = false
    private var selectedCell: UITableViewCell?

    convenience init(isNonRegularEvent: Bool) {
        self.init()
        self.isNonRegularEvent = isNonRegularEvent
        if isNonRegularEvent {
            let currentWeekDay = WeekDay.getWeekDay(for: Date())
            if let dayKey = WeekDay.getShortWeekDay(for: currentWeekDay.rawValue) {
                selectedDays.append(dayKey)
            }
        }
    }
    
    func didEnter(_ text: String?) {
        trackerName = text ?? ""
    }

    func updateCurrentlySelectedCell(to cell: UITableViewCell?) {
        selectedCell = cell
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

    func setSelectedEmoji(emoji: String) {
        selectedEmoji = emoji
    }

    func setSelectedColor(color: UIColor?) {
        selectedColor = color
    }

    func createNewTracker() -> TrackerCategory {
        let schedule = isNonRegularEvent ?
        [WeekDay.getWeekDay(for: Date())] :
        selectedSchedule
        
        return TrackerCategory(
            title: selectedCategory,
            trackers: [
                        Tracker(id: UUID(),
                                name: trackerName,
                                emoji: selectedEmoji,
                                color: selectedColor ?? UIColor(),
                                schedule: schedule)
                    ]
        )
    }
    
    func canHabitBeCreated() -> Bool {
        guard !trackerName.isEmpty,
              !selectedCategory.isEmpty,
              !selectedDays.isEmpty,
              !selectedEmoji.isEmpty,
              selectedColor != nil else {
            return false
        }
        return true
    }

    func setupCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = (tableView.dequeueReusableCell(
                withIdentifier: String(describing: CategoryCellView.self),
                for: indexPath
            ) as? CategoryCellView) ?? UITableViewCell()

            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: isNonRegularEvent ? 0 : 15,
                bottom: 0,
                right: isNonRegularEvent ? tableView.bounds.width : 15
            )
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
}

extension HabitCreationScreenViewModel: TrackerCategoryConfigurationDelegate {
    var previousSelectedCategory: String {
        selectedCategory
    }

    func updateCategory(withCategory category: String) {
        selectedCategory = category
        guard let cell = selectedCell as? CategoryCellView else {
            return
        }
        cell.infoLabel.text = selectedCategory
        cell.infoLabel.isHidden = false
        shouldCreateButtonBeUnlocked = canHabitBeCreated()
    }
}

extension HabitCreationScreenViewModel: ScheduleConfigurationDelegate {
    var alreadySelectedSchedule: [String] {
        selectedDaysRaw
    }

    func updateSchedule(withDays days: [String]) {
        selectedDays = []
        selectedSchedule = []
        selectedDaysRaw = days
        guard let cell = selectedCell as? ScheduleCellView else {
            return
        }

        days.forEach { item in
            if let shortDay = WeekDay.getShortWeekDay(for: item) {
                selectedDays.append(shortDay)
            }
            if let scheduleItem = WeekDay(rawValue: item) {
                selectedSchedule.append(scheduleItem)
            }
        }
        
        if days.count == 7 {
            cell.infoLabel.text = "Каждый день"
        } else {
            cell.infoLabel.text = String(selectedDays.joined(separator: ", "))
        }
        cell.infoLabel.isHidden = false
        shouldCreateButtonBeUnlocked = canHabitBeCreated()
    }
}

