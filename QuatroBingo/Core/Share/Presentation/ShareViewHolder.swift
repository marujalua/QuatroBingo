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
            .sheet(item: $store.shareCode.sending(\.shareIsVisibible)) { data in
                ActivityView(data: data)
            }
    }
}


struct ActivityView: UIViewControllerRepresentable {
    let data: ShareFeature.State.ShareData

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems:[data.message, data.url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
