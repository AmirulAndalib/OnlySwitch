//
//  EvolutionGalleryReducer.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2023/10/2.
//

import ComposableArchitecture
import Foundation

struct EvolutionGalleryReducer: Reducer {
    struct State: Equatable {
        var galleryList: IdentifiedArrayOf<EvolutionGalleryItemReducer.State> = []
    }

    enum Action: Equatable {
        case refresh
        case loadList(TaskResult<[EvolutionGalleryItem]>)
        case itemAction(id:UUID, action: EvolutionGalleryItemReducer.Action)
        case delegate(Delegate)
        enum Delegate: Equatable {
            case installed
        }
    }

    @Dependency(\.evolutionGalleryService) var galleryService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .refresh:
                    return .run { send in
                        return await send(
                            .loadList(
                                TaskResult {
                                    try await galleryService.fetchGalleryList()
                                }
                            )
                        )
                    }

                case let .loadList(.success(items)):
                    state.galleryList =
                    IdentifiedArray(
                        uniqueElements: items.compactMap { item in
                            var tempItem = item
                            tempItem.installed = galleryService.checkInstallation(item.evolution.id)
                            return EvolutionGalleryItemReducer.State(item: tempItem)
                        }
                    )
                    return .none

                case .loadList(.failure(_)):
                    return .none

                case let .itemAction(_ , .delegate(action)):
                    switch action {
                        case .installed:
                            return .send(.delegate(.installed))
                    }

                case .itemAction:
                    return .none

                case .delegate:
                    return .none
            }
        }
        .forEach(\.galleryList, action: /Action.itemAction) {
            EvolutionGalleryItemReducer()
        }
    }
}
