/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

/// the various about menu options
enum AboutMenuIdentifier: String {

	case accessibility

	case privacyStatement

	case terms
    
    case contact
}

///// Struct for information to display the different test providers
struct AboutMenuOption {

	/// The identifier
	let identifier: AboutMenuIdentifier

	/// The name
	let name: String
}

class AboutViewModel: Logging {

	/// Coordination Delegate
	weak private var coordinator: OpenUrlProtocol?

	private var flavor: AppFlavor

	// MARK: - Bindable

	@Bindable private(set) var title: String
	@Bindable private(set) var message: String
	@Bindable private(set) var version: String
	@Bindable private(set) var listHeader: String
	@Bindable private(set) var menu: [AboutMenuOption] = []

	// MARK: - Initializer

	/// Initializer
	/// - Parameters:
	///   - coordinator: the coordinator delegate
	///   - versionSupplier: the version supplier
	///   - flavor: the app flavor
	init(
		coordinator: OpenUrlProtocol,
		versionSupplier: AppVersionSupplierProtocol,
		flavor: AppFlavor) {

		self.coordinator = coordinator
		self.flavor = flavor

		self.title = .verifierAboutTitle
		self.message = .verifierAboutText
		self.listHeader = .verifierAboutReadMore

		let versionString: String = .verifierLaunchVersion
		version = String(
			format: versionString,
			versionSupplier.getCurrentVersion(),
			versionSupplier.getCurrentBuild()
		)

		setupMenuVerifier()
	}

	private func setupMenuVerifier() {

		menu = [
            AboutMenuOption(identifier: .terms, name: .verifierMenuPrivacy),
            AboutMenuOption(identifier: .accessibility, name: .verifierMenuAccessibility),
            AboutMenuOption(identifier: .privacyStatement, name: "privacy_policy".localized()),
            AboutMenuOption(identifier: .contact, name: .verifierMenuSupport)
		]
	}

	func menuOptionSelected(_ identifier: AboutMenuIdentifier) {

		switch identifier {
			case .privacyStatement:
				openUrlString(.holderUrlPrivacy)
			case .terms:
				openUrlString(.verifierUrlPrivacy)
			case .accessibility:
                openUrlString(.verifierUrlAccessibility)
            case .contact:
                openUrlString(.verifierUrlSupport)
        }
	}

	private func openUrlString(_ urlString: String) {

		if let url = URL(string: urlString) {
			coordinator?.openUrl(url, inApp: true)
		}
	}
}
