//
//  SplitTripleView.swift
//  DuoTest
//
//  Created by 김다예 on 10/13/26.
//

import SwiftUI

struct TripleSplitDemo: View {
    @Environment(\.dismiss) private var dismiss
    @State private var playlistID: Playlist.ID? = Playlist.samples.first?.id
    @State private var danceID: Dance.ID?

    private var selectedPlaylist: Playlist? {
        Playlist.samples.first { $0.id == playlistID }
    }

    private var selectedDance: Dance? {
        selectedPlaylist?.dances.first { $0.id == danceID }
    }

    var body: some View {
        NavigationSplitView {
            
            // sidebar 칼럼
            
            List(Playlist.samples, selection: $playlistID) { playlist in
                Label(playlist.name, systemImage: "music.note.list")
            }
            .navigationTitle("플레이리스트")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기", systemImage: "xmark") { dismiss() }
                }
            }
        } content: {
            
            // content 칼럼
            
            if let playlist = selectedPlaylist {
                List(playlist.dances, selection: $danceID) { dance in
                    Text(dance.title)
                }
                .navigationTitle(playlist.name)
            } else {
                ContentUnavailableView("플레이리스트를 선택하세요", systemImage: "music.note.list")
            }
        } detail: {
            
            // detail 칼럼
            
            if let dance = selectedDance {
                SizeReadout(label: "triple-detail")
                    .navigationTitle(dance.title)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("공유", systemImage: "square.and.arrow.up") {}
                        }
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button("연습", systemImage: "figure.dance") {}
                            Button("저장", systemImage: "square.and.arrow.down") {}
                        }
                    }
            } else {
                ContentUnavailableView("안무를 선택하세요", systemImage: "figure.dance")
            }
        }
        // 플레이리스트가 바뀌면 이전 안무 선택은 무효
        .onChange(of: playlistID) {
            danceID = nil
        }
    }
}

struct Playlist: Identifiable, Hashable {
    let id: String
    let name: String
    let dances: [Dance]

    static let samples: [Playlist] = [
        Playlist(id: "p1", name: "입문", dances: [
            Dance(id: "d1", title: "안무 A"),
            Dance(id: "d2", title: "안무 B"),
        ]),
        Playlist(id: "p2", name: "챌린지", dances: [
            Dance(id: "d3", title: "안무 C"),
            Dance(id: "d4", title: "안무 D"),
            Dance(id: "d5", title: "안무 E"),
        ]),
    ]
}

struct Dance: Identifiable, Hashable {
    let id: String
    let title: String
}
