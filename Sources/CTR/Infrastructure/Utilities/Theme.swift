/*
 * Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit

class Fonts {
    // Using default textStyles from Apple typography guidelines:
    // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/
    // Table with point in sizes can be found on the link.

    var largeTitle: UIFont {
        font(textStyle: .largeTitle, textSize: 34, isBold: true) // Size 34 points
    }

    var title1: UIFont {
        font(textStyle: .title1, textSize: 28, isBold: true) // Size 28 points
    }

	var title1Montserrat: UIFont {
		font(textStyle: .title1, textSize: 28, isBold: true, customFont: "Montserrat-Bold") // Size 28 points
	}

    var title2: UIFont {
        font(textStyle: .title2, textSize: 22, isBold: true) // Size 22 points
    }

    var title3: UIFont {
        font(textStyle: .title3, textSize: 20, isBold: true) // Size 20 points
    }

	var title3Montserrat: UIFont {
		font(textStyle: .title3, textSize: 20, isBold: true, customFont: "Montserrat-Bold") // Size 20 points
	}

	var title3Medium: UIFont {
		font(textStyle: .title3, textSize: 20, isMedium: true) // Size 20 points
	}

    var headline: UIFont {
        font(textStyle: .headline, textSize: 17) // Size 17 points
    }

	var headlineBold: UIFont {
		font(textStyle: .headline, textSize: 17, isBold: true) // Size 17 points
	}

    var body: UIFont {
        font(textStyle: .body, textSize: 17) // Size 17 points
    }

	var bodyMontserrat: UIFont {
		font(textStyle: .body, textSize: 17, customFont: "Montserrat-Bold") // Size 17 points
	}
    
    var bodyMontserratSemiBold: UIFont {
        font(textStyle: .body, textSize: 17, customFont: "Montserrat-SemiBold") // Size 17 points
    }

	var bodyMontserratFixed: UIFont {

		if let font = UIFont(name: "Montserrat-Bold", size: 17) {
			return font
		}
		return .systemFont(ofSize: 17)
	}

    var bodyBold: UIFont {
        font(textStyle: .body, textSize: 17, isBold: true) // Size 17 points
    }

	var bodyBoldFixed: UIFont {
		return .boldSystemFont(ofSize: 17)
	}

	var bodySemiBold: UIFont {
		font(textStyle: .body, textSize: 17, isSemiBold: true) // Size 17 points
	}

	var bodyMedium: UIFont {
		font(textStyle: .body, textSize: 17, isMedium: true) // Size 17 points
	}

    var callout: UIFont {
        font(textStyle: .callout, textSize: 16) // Size 16 points
    }

	var calloutSemiBold: UIFont {
		font(textStyle: .callout, textSize: 16, isSemiBold: true) // Size 16 points
	}
    
    var calloutBold: UIFont {
        font(textStyle: .callout, textSize: 16, customFont: "Montserrat-Bold") // Size 16 points
    }

    var subhead: UIFont {
        font(textStyle: .subheadline, textSize: 15) // Size 15 points
    }

	var subheadMontserrat: UIFont {
		font(textStyle: .subheadline, textSize: 15, customFont: "Montserrat-SemiBold") // Size 15 points
	}

    var subheadBold: UIFont {
        font(textStyle: .subheadline, textSize: 15, isBold: true) // Size 15 points
    }
    
    var subheadBoldMontserrat: UIFont {
        font(textStyle: .subheadline, textSize: 15, customFont: "Montserrat-Bold") // Size 15 points
    }

	var subheadMedium: UIFont {
		font(textStyle: .subheadline, textSize: 15, isMedium: true) // Size 15 points
	}

    var footnote: UIFont {
        font(textStyle: .footnote, textSize: 13) // Size 13 points
    }

	var footnoteMontserrat: UIFont {
		font(textStyle: .footnote, textSize: 13, customFont: "Montserrat-SemiBold") // Size 13 points
	}
    
    var footnoteMontserratBold: UIFont {
        font(textStyle: .footnote, textSize: 13, customFont: "Montserrat-Bold") // Size 13 points
    }

    var caption1: UIFont {
        font(textStyle: .caption1, textSize: 12, isBold: true) // size 12 points
    }
    
    var caption1Montserrat: UIFont {
        font(textStyle: .caption1, textSize: 12, customFont: "Montserrat-Bold") // size 12 points
    }

	var caption1SemiBold: UIFont {
        font(textStyle: .caption1, textSize: 12, isSemiBold: true) // size 12 points
	}
    
    var smallCaptionSemibold: UIFont {
        font(textStyle: .caption1, textSize: 11, customFont: "Montserrat-SemiBold") // size 12 points
    }

    // MARK: - Private

	private func font(
        textStyle: UIFont.TextStyle,
		textSize: CGFloat,
		isBold: Bool = false,
		isSemiBold: Bool = false,
		isMedium: Bool = false,
		customFont: String? = nil) -> UIFont {

		if let customFontName = customFont, let font = UIFont(name: customFontName, size: textSize) {
			return UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
        } else {
            return UIFont.preferredFont(forTextStyle: textStyle)
        }
        var fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)

        if isBold, let boldFontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold) {
            fontDescriptor = boldFontDescriptor
        }

		if isSemiBold {
			let semiBoldDescriptor = fontDescriptor.addingAttributes(
				[.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]]
			)
			fontDescriptor = semiBoldDescriptor
		}

		if isMedium {
			let mediumDescriptor = fontDescriptor.addingAttributes(
				[.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]]
			)
			fontDescriptor = mediumDescriptor
		}

		return UIFont(descriptor: fontDescriptor, size: fontDescriptor.pointSize)
    }
}

final class Colors {

	var dark: UIColor { return color(for: "DarkColor") }

	var primary: UIColor { return color(for: "PrimaryColor") }

	var secondary: UIColor { return color(for: "SecondaryColor") }

	var iosBlue: UIColor { return color(for: "IosBlue") }

    var tertiary: UIColor { return color(for: "TertiaryColor") }

	var gray: UIColor { return color(for: "DotGray") }
    
    var separatorGray: UIColor { return color(for: "SeparatorGrey") }
    
    var iconBackground: UIColor { return color(for: "IconBackground") }

	var disabledIcon: UIColor { return color(for: "DisabledIcon") }

	var viewControllerBackground: UIColor { return color(for: "ViewControllerBackgroundColor") }

	var appointment: UIColor { return color(for: "AppointmentColor") }

	var create: UIColor { return color(for: "CreateColor") }

	var shadow: UIColor { return color(for: "ShadowColor") }

	var lightBackground: UIColor { return color(for: "LightBackgroundColor") }

	var line: UIColor { return color(for: "LineColor") }

	var utilityError: UIColor { return color(for: "UtilityError") }

	var denied: UIColor { return color(for: "DeniedColor") }

	var access: UIColor { return color(for: "AccessColor") }

	var grey1: UIColor { return color(for: "Grey1") }

	var grey2: UIColor { return color(for: "Grey2") }

	var grey3: UIColor { return color(for: "Grey3") }

	var grey4: UIColor { return color(for: "Grey4") }

	var grey5: UIColor { return color(for: "Grey5") }

	var greenGrey: UIColor { return color(for: "GreenGrey") }

	var europa: UIColor { return color(for: "Europa") }

	var bannerBackgroundColor: UIColor { return color(for: "BannerBackgroundColor") }

	var highlightBackgroundColor: UIColor { return color(for: "HighlightBackgroundColor") }
    
    var inactiveCountry: UIColor { return color(for: "InactiveCountry") }

    // MARK: - Private

    private func color(for name: String) -> UIColor {
		
        let bundle = Bundle(for: Colors.self)
        if let color = UIColor(named: name, in: bundle, compatibleWith: nil) {
            return color
        }
        return .clear
    }
}

/// - Tag: Theme
struct Theme {

    static let fonts = Fonts()
    static let colors = Colors()
}
