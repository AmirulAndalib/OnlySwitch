//
//  EvolutionGalleryItemReducer.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2023/10/2.
//

import ComposableArchitecture
import Foundation

struct EvolutionGalleryItemReducer: Reducer {
    struct State: Equatable, Identifiable {
        let id: UUID
        var item: EvolutionGalleryItem

        init(item: EvolutionGalleryItem) {
            self.item = item
            self.id = item.evolution.id
        }
    }

    enum Action: Equatable {
        static func == (lhs: EvolutionGalleryItemReducer.Action, rhs: EvolutionGalleryItemReducer.Action) -> Bool {
            switch (lhs, rhs) {
                case (.finishInstall(_), finishInstall(_)):
                    return false
                default:
                    return lhs == rhs
            }
        }
        
        case checkInstallation
        case install
        case finishInstall(TaskResult<Void>)
        case delegate(Delegate)
        enum Delegate: Equatable {
            case installed
        }
    }

    @Dependency(\.evolutionGalleryService) var galleryService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .checkInstallation:
                    state.item.installed = galleryService.checkInstallation(state.id)
                    return .none

                case .install:
                    return .run { [state = state] send in
                        await send(
                            .finishInstall(
                                TaskResult {
                                    try await galleryService.addGallery(state.item.evolution)
                                }
                            )
                        )
                    }

                case .finishInstall(.success(_)):
                    return .merge(
                        .send(.checkInstallation),
                        .send(.delegate(.installed))
                    )

                case .finishInstall(.failure(_)):
                    return .none

                case .delegate:
                    return .none
            }
        }
    }
}
