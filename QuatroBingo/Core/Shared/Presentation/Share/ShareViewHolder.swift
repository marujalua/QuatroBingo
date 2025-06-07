//
//  ShareViewHolder.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 07/06/25.
//

import SwiftUI
import ComposableArchitecture

struct ShareViewHolder<Content: View>: View {
    @Bindable var store: StoreOf<ShareFeature>
    var content: (StoreOf<ShareFeature>) -> Content

    var body: some View {
        content(store)
            .sheet(item: $store.shareCode.sending(\.shareIsVisibible), id: \.self) { code in
                ActivityView(text: code)
            }
    }
}


struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
