//
//  OrderView.swift
//  iDine
//
//  Created by Paul Hudson on 08/02/2021.
//

import SwiftUI

struct OrderView: View {
    @Environment(Order.self) var order

    var body: some View {
        NavigationStack {
            List {
                Section {
                    // A customer can add the same menu item more than once.
                    ForEach(order.items.indices, id: \.self) { index in
                        let item = order.items[index]
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }

                Section {
                    NavigationLink("Place Order") {
                        CheckoutView()
                    }
                }
                .disabled(order.items.isEmpty)

                Section {
                    if let message = order.storageError {
                        Text(message)
                            .foregroundStyle(.red)
                    } else {
                        Text("Your order is saved on this device.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Order")
            .listStyle(.insetGrouped)
            .toolbar {
                EditButton()
            }
        }
    }

    func deleteItems(at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
    }
}

#Preview {
  OrderView()
      .environment(Order())
}
