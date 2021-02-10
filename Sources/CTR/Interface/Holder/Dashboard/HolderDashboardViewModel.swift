/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

enum CardIdentifier {
	case appointment
	case create
}

struct CardInfo {

	let identifier: CardIdentifier
	let title: String
	let message: String
	let actionTitle: String
	let image: UIImage?
}

class HolderDashboardViewModel: Logging {

	var loggingCategory: String = "HolderDashboardViewModel"

	/// Coordination Delegate
	weak var coordinator: HolderCoordinatorDelegate?
	weak var cryptoManager: CryptoManagerProtocol?

	@Bindable private(set) var title: String
	@Bindable private(set) var message: String
	@Bindable private(set) var qrMessage: String?
	@Bindable private(set) var appointmentCard: CardInfo
	@Bindable private(set) var createCard: CardInfo

	/// Initializer
	/// - Parameters:
	///   - coordinator: the coordinator delegate

	init(coordinator: HolderCoordinatorDelegate, cryptoManager: CryptoManagerProtocol) {

		self.coordinator = coordinator
		self.cryptoManager = cryptoManager
		self.title = .holderDashboardTitle
		self.message = .holderDashboardIntro
		self.qrMessage = nil
		self.appointmentCard = CardInfo(
			identifier: .appointment,
			title: .holderDashboardAppointmentTitle,
			message: .holderDashboardAppointmentMessage,
			actionTitle: .holderDashboardAppointmentAction,
			image: .appointment
		)
		self.createCard = CardInfo(
			identifier: .create,
			title: .holderDashboardCreateTitle,
			message: .holderDashboardCreateMessage,
			actionTitle: .holderDashboardCreatetAction,
			image: .create
		)
		generateQRMessage()
	}

	func cardClicked(_ identifier: CardIdentifier) {

		if identifier == CardIdentifier.appointment {
			coordinator?.navigateToAppointment()
		} else if identifier == CardIdentifier.create {
			coordinator?.navigateToChooseProvider()
		}
	}

	private func generateQRMessage() {

//		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//
			if let message = self.cryptoManager?.generateQRmessage() {
				self.qrMessage = message
			}
//		}

//		DispatchQueue.global(qos: .background).async {
//
//			if let message = self.cryptoManager?.generateQRmessage() {
//
//				self.logDebug("message: \(message)")
//			}
//		}
	}
}
