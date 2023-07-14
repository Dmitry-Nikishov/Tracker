//
//  ScheduleConfigurationScreenViewModel.swift
//  Tracker
//
//  Created by Дмитрий Никишов on 26.06.2023.
//

import UIKit

final class ScheduleConfigurationScreenViewModel {
    private let days: [String] = WeekDay.allCases.map {$0.rawValue.localized}
    private var selectedDays: [String] = []
    private var alreadySelectedDays: [String] = []
    private var currentSelectedStatuses: [Bool] {
        var selectedStatuses: [Bool] = []
        days.forEach { day in
            let isAlreadySelected = alreadySelectedDays.contains(day)
            selectedStatuses.append(isAlreadySelected)
        }
        return selectedStatuses
    }
    
    func getNumberOfDays() -> Int {
        return days.count
    }

    func getSelectedDays() -> [String] {
        return selectedDays
    }

    func setupCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DaySelectionCell.self),
            for: indexPath) as? DaySelectionCell {
            cell.backgroundColor = .appGray.withAlphaComponent(0.3)
            cell.selectionStyle = .none
            cell.dayLabel.text = days[indexPath.row]
            
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 15,
                bottom: 0,
                right: 15
            )
            if indexPath.row == days.count - 1 {
                cell.separatorInset = UIEdgeInsets(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    right: tableView.bounds.width
                )
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else if indexPath.row == 0 {
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
            
            let uiSwitch = UISwitch(frame: .zero)
            uiSwitch.onTintColor = .appBlue
            uiSwitch.tag = indexPath.row
            uiSwitch.addTarget(
                self,
                action: #selector(switchChanged(_:)),
                for: .valueChanged
            )
            
            if currentSelectedStatuses[indexPath.row] {
                uiSwitch.isOn = true
                selectedDays.append(days[indexPath.row])
            }
            cell.accessoryView = uiSwitch
            
            return cell
        }
        return UITableViewCell()
    }

    @objc private func switchChanged(_ sender: UISwitch) {
        let item = days[sender.tag]
        if sender.isOn {
            selectedDays.append(item)
        } else {
            selectedDays.removeAll(where: {$0 == item})
        }
    }
    
    func setAlreadySelectedDays(with data: [String]) {
        alreadySelectedDays = data
    }
}

