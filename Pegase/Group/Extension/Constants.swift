import Cocoa
import Defaults


extension Defaults.Keys {
	static let recentlyPickedColors = Key<[NSColor]>("recentlyPickedColors", default: [])

	// Settings
	static let showInMenuBar = Key<Bool>("showInMenuBar", default: false)
	static let hideMenuBarIcon = Key<Bool>("hideMenuBarIcon", default: false)
	static let showColorSamplerOnOpen = Key<Bool>("showColorSamplerOnOpen", default: false)
	static let stayOnTop = Key<Bool>("stayOnTop", default: true)
	static let uppercaseHexColor = Key<Bool>("uppercaseHexColor", default: false)
	static let hashPrefixInHexColor = Key<Bool>("hashPrefixInHexColor", default: false)
	static let legacyColorSyntax = Key<Bool>("legacyColorSyntax", default: false)
	static let largerText = Key<Bool>("largerText", default: false)
	static let copyColorAfterPicking = Key<Bool>("copyColorAfterPicking", default: false)

}


