//
//  ItemDetail.swift
//  iDine
//
//  Created by Paul Hudson on 08/02/2021.
//

import SwiftUI

struct ItemDetail: View {
    @Environment(Order.self) var order
    let item: MenuItem

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(item.mainImage)
                    .resizable()
                    .scaledToFit()

                Text("Photo: \(item.photoCredit)")
                    .padding(4)
                    .background(Color.black)
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(x: -5, y: -5)
            }

            Text(item.description)
                .padding()

            Button("Order This") {
                order.add(item: item)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
  NavigationStack {
      ItemDetail(item: MenuItem.example)
          .environment(Order())
  }
}
