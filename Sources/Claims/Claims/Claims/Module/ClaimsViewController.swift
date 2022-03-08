//
//  HomeViewController.swift
//  FolksamApp
//
//  Created by Johan Torell on 2021-01-28.
//

import FolksamCommon
import SwiftUI
import UIKit

public class ClaimsViewController: UIViewController {
    private var claimsData: [Claim]!
    private var apiService: ClaimsServiceProtocol!
    private var tableViewController: ClaimsTableViewController!

    override public func viewDidLoad() {
        super.viewDidLoad()
        fetchClaims(completion: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddClaimModal))
    }

    public static func make(apiService: ClaimsServiceProtocol) -> UINavigationController {
        let storyboard = UIStoryboard(name: "ClaimsTab", bundle: Bundle.module)
        let (navigationController, viewController) = UIStoryboard.instantiateNavigationController(
            from: storyboard,
            childOfType: self
        )
        viewController.apiService = apiService
        if #available(iOS 13.0, *) {
            navigationController.tabBarItem = UITabBarItem(title: "Skador", image: UIImage(systemName: "cross.case.fill"), selectedImage: UIImage(systemName: "cross.case.fill"))
        } else {
            navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        }

        return navigationController
    }

    override public func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let tableViewController = segue.destination as? ClaimsTableViewController {
            self.tableViewController = tableViewController
            tableViewController.delegate = self
        }
    }

    private func fetchClaims(completion: (() -> Void)? = nil) {
        apiService.getClaims { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .failure(error):
                print(error)
            case let .success(claims):
                self.updateUI(data: claims)
            }
            completion?()
        }
    }

    private func updateUI(data: [Claim]) {
        tableViewController.setData(newData: data)
    }

    @objc private func openAddClaimModal() {
        if #available(iOS 14.0, *) {
            let vc = UIHostingController(rootView: AddClaimView())
            // vc.delegate = self
            navigationController?.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - TableViewDelegate

extension ClaimsViewController: ClaimsTableViewDelegate {
    func refreshData(completion: @escaping () -> Void) {
        fetchClaims(completion: completion)
    }
}
