//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Дмитрий Никишов on 12.07.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testLaunchScreen() throws {
        let vc = LaunchScreenController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

    func testOnboardingScreen() throws {
        let vc = OnboardingPageController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

    func testTrackersScreen() throws {
        let vc = TrackersScreenController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

    func testTrackerSelectionScreen() throws {
        let vc = TrackerSelectionScreenController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

    func testHabitCreationScreen() throws {
        let vc = HabitCreationScreenController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

    func testTrackerCategoryScreen() throws {
        let vc = TrackerCategoryScreenController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

    func testCategoryCreationScreen() throws {
        let vc = CategoryCreationScreenController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

    func testScheduleConfigurationScreen() throws {
        let vc = ScheduleConfigurationScreenController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

    func testStatisticsScreen() throws {
        let vc = StatisticsScreenController()
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .light))
        ])
        assertSnapshots(matching: vc, as: [
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }

}
