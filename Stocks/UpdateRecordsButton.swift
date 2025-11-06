import SwiftUI
import Foundation

struct UpdateRecordsButton: View {
    @Binding var isLoading: Bool
    let isUpToDate: Bool
    let isDisabled: Bool
    let action: () async -> Void
    
    var body: some View {
        Button {
            guard !isLoading else { return }
            Task {
                await MainActor.run {
                    isLoading = true
                }
                await action()
                await MainActor.run {
                    isLoading = false
                }
            }
        } label: {
            if isLoading {
                HStack {
                    ProgressView()
                    Text("Updating…")
                }
            } else {
                Text(isUpToDate ? "Up to date" : "Update records")
            }
        }
        .disabled(isLoading || isDisabled)
    }
}
