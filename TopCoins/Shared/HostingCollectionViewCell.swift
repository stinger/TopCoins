//
//  HostingCollectionViewCell.swift
//  TopCoins
//
//  Created by Ilian Konchev on 22.02.25.
//

import SwiftUI
import UIKit

class HostingCollectionViewCell<Content: View>: UICollectionViewCell {
    private var hostingController: UIHostingController<Content>?

    func configure(with view: Content, parentViewController: UIViewController) {
        // Remove existing hosting controller if present
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()

        // Create new hosting controller
        let hostingController = UIHostingController(rootView: view)
        self.hostingController = hostingController

        // Attach to parent VC
        parentViewController.addChild(hostingController)
        contentView.addSubview(hostingController.view)

        // Ensure it resizes correctly
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])

        hostingController.didMove(toParent: parentViewController)
    }
}
