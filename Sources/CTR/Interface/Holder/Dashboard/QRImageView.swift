/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

class QRImageView: BaseView {

	/// The display constants
	private struct ViewTraits {

		// Dimensions
		static let cornerRadius: CGFloat = 15
		static let shadowRadius: CGFloat = 8
		static let shadowOpacity: Float = 0.3

		// Margins
		static let margin: CGFloat = 24.0
		static let labelSidemargin: CGFloat = UIDevice.current.isSmallScreen ? 10.0 : 20.0
		static let imageSidemargin: CGFloat = UIDevice.current.isSmallScreen ? 20.0 : 40.0
	}

	/// The image view for the QR image
	private let imageView: UIImageView = {

		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	/// The title label
	private let titleLabel: Label = {

		return Label(title3: nil, montserrat: true)
	}()

	/// The message label
	private let messageLabel: Label = {

		return Label(subheadMedium: nil).multiline()
	}()

	/// Setup all the views
	override func setupViews() {

		super.setupViews()

		// Fixed white background, no inverted QR in dark mode
		backgroundColor = .white

		titleLabel.textAlignment = .center
		messageLabel.textAlignment = .center
		layer.cornerRadius = ViewTraits.cornerRadius
		createShadow()
	}

	/// Create the shadow around the view
	func createShadow() {

		// Shadow
		layer.shadowColor = Theme.colors.shadow.cgColor
		layer.shadowOpacity = ViewTraits.shadowOpacity
		layer.shadowOffset = .zero
		layer.shadowRadius = ViewTraits.shadowRadius
		// Cache Shadow
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
	}

	/// Setup the hierarchy
	override func setupViewHierarchy() {
		super.setupViewHierarchy()

		addSubview(titleLabel)
		addSubview(imageView)
		addSubview(messageLabel)
	}
	/// Setup the constraints
	override func setupViewConstraints() {

		super.setupViewConstraints()

		NSLayoutConstraint.activate([

			// Title
			titleLabel.topAnchor.constraint(
				equalTo: topAnchor,
				constant: ViewTraits.margin
			),
			titleLabel.leadingAnchor.constraint(
				equalTo: leadingAnchor,
				constant: ViewTraits.labelSidemargin
			),
			titleLabel.trailingAnchor.constraint(
				equalTo: trailingAnchor,
				constant: -ViewTraits.labelSidemargin
			),
			titleLabel.bottomAnchor.constraint(
				equalTo: imageView.topAnchor,
				constant: -ViewTraits.margin
			),

			// QR View
			imageView.leadingAnchor.constraint(
				equalTo: leadingAnchor,
				constant: ViewTraits.imageSidemargin
			),
			imageView.trailingAnchor.constraint(
				equalTo: trailingAnchor,
				constant: -ViewTraits.imageSidemargin
			),
			imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
			imageView.bottomAnchor.constraint(
				equalTo: messageLabel.topAnchor,
				constant: -ViewTraits.margin
			),

			// Message
			messageLabel.leadingAnchor.constraint(
				equalTo: leadingAnchor,
				constant: ViewTraits.labelSidemargin
			),
			messageLabel.bottomAnchor.constraint(
				equalTo: bottomAnchor,
				constant: -ViewTraits.margin
			),
			messageLabel.trailingAnchor.constraint(
				equalTo: trailingAnchor,
				constant: -ViewTraits.labelSidemargin
			)
		])
	}

	// MARK: Public Access

	/// The  title
	var title: String? {
		didSet {
			titleLabel.text = title
		}
	}

	/// The  message
	var message: String? {
		didSet {
			messageLabel.attributedText = .makeFromHtml(
				text: message,
				font: Theme.fonts.subhead,
				textColor: Theme.colors.dark,
				textAlignment: .center
			)
		}
	}

	/// The qr  image
	var qrImage: UIImage? {
		didSet {
			imageView.image = qrImage
		}
	}

	/// Hide the QR Image
	var hideQRImage: Bool = false {
		didSet {
			imageView.isHidden = hideQRImage
		}
	}
}
