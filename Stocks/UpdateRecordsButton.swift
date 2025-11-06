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
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .disabled(isLoading || isDisabled)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var loading1 = false
        @State private var loading2 = false
        
        var body: some View {
            VStack(spacing: 20) {
                UpdateRecordsButton(
                    isLoading: $loading1,
                    isUpToDate: false,
                    isDisabled: false,
                    action: dummyAction
                )
                
                UpdateRecordsButton(
                    isLoading: $loading2,
                    isUpToDate: true,
                    isDisabled: false,
                    action: dummyAction
                )
            }
            .padding()
        }
        
        func dummyAction() async {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }
    PreviewWrapper()
}
