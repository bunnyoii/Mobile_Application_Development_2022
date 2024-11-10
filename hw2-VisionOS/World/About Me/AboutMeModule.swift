/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The module detail content that's specific to the about me module.
*/

import SwiftUI

/// The module detail content that's specific to the about me module.
struct AboutMeModule: View {
    var body: some View {
        Image("Picture")
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    AboutMeModule()
        .padding()
}
