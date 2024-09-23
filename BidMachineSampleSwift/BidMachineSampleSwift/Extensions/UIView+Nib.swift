//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit

extension UIView {
    static func instantiateFromNib(owner: Any?) -> Self? {
        let nibClass = Self.self

        let nib = UINib(
            nibName: String(describing: nibClass),
            bundle: Bundle(for: nibClass)
        )
        return nib.instantiate(
            withOwner: owner,
            options: nil
        ).first as? Self
    }
}
