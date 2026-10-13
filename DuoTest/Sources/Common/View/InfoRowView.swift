//
//  InfoRow.swift
//  DuoTest
//
//  Created by 김다예 on 10/13/26.
//

import SwiftUI

struct InfoRow: Identifiable {
    let key: String
    let value: String
    var id: String { key }
    
    init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
}

struct InfoRows: View {
    let rows: [InfoRow]

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
            ForEach(rows) { row in
                GridRow {
                    Text(row.key).foregroundStyle(.secondary)
                    Text(row.value).monospacedDigit()
                }
            }
        }
        .font(.footnote)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.secondary.opacity(0.12),
            in: .rect(cornerRadius: 12)
        )
    }
}
