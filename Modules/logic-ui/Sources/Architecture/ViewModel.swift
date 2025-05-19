/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
@_exported import SwiftUI
@_exported import Combine
@_exported import Copyable

import SwiftCBOR

public protocol ViewState {}

@MainActor
open class ViewModel<Router: RouterHost, UiState: ViewState>: ObservableObject {

  public lazy var cancellables = Set<AnyCancellable>()

  @Published public private(set) var viewState: UiState

  public let router: Router

  public init(router: Router, initialState: UiState) {
    self.router = router
    self.viewState = initialState
  }

  public func setState(_ reducer: (UiState) -> UiState) {
    self.viewState = reducer(viewState)
  }
}

func generateOverriddenQrPayload() -> String {
    let fixedUUID = "00000001-0002-0003-0004-000000000005"
    let cbor = CBOR.map([
        CBOR.unsignedInt(0): CBOR.map([
            CBOR.unsignedInt(1): CBOR.utf8String(fixedUUID)
        ])
    ])
    do {
        let encoded: [UInt8] = try CBOR.encode(cbor)
        let base64 = Data(encoded).base64EncodedString()
        return "mdoc:\(base64)"
    } catch {
        return "❌ encode failed: \(error)"
    }
}
