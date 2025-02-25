//
//  HomeViewReactor.swift
//  Hobbyloop
//
//  Created by 김진우 on 2023/05/25.
//

import Foundation

import HPExtensions
import ReactorKit
import RxSwift
import HPDomain

enum HomeViewStream: HPStreamType {
    enum Event {
        case reloadHomeViewSection(isSelected: Bool)
    }
    
}

public final class HomeViewReactor: Reactor {
    
    //MARK: Property
    public var initialState: State
    private var homeRepository: HomeViewRepo
    
    //MARK: Action
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setEmptyClassItem
        case reloadClassItem
        case setLatestReservationItem(LatestReservation)
    }
    
    //MARK: State
    public struct State {
        var isLoading: Bool
        var reservationItem: LatestReservation?
        @Pulse var section: [HomeSection]
    }
    
    public init(homeRepository: HomeViewRepo) {
        self.homeRepository = homeRepository
        self.initialState = State(
            isLoading: false,
            reservationItem: nil,
            section: [
                .userInfoClass([
                    .userInfoClassItem
                ]),
                
                .calendarClass([]),
                
                .ticketClass([
                    .ticketClassItem
                ]),
                
                .schedulClass([
                    .schedulClassItem
                ]),
                .explanationClass([
                    .explanationClassItem
                ]),
                .benefitsClass([
                    .benefitsClassItem
                ]),
                .exerciseClass([
                    .exerciseClassItem
                ])
            ]
        )
    }
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let reloadHomeSection = HomeViewStream.event.flatMap { [weak self] event in
            self?.reqeustHomeViewSection(from: event) ?? .empty()
            
        }
        
        return Observable.of(mutation, reloadHomeSection).merge()
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(
                startLoading,
                .just(.setEmptyClassItem),
                self.homeRepository.fetchLatestReservationInfo(),
                endLoading
            )
            
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .setLatestReservationItem(item):
            newState.reservationItem = item
            
        case .setEmptyClassItem:
            let userIndex = self.getIndex(section: .userInfoClass([]))
            let ticketIndex = self.getIndex(section: .ticketClass([]))
            let calendarIndex = self.getIndex(section: .calendarClass([]))
            let scheduleIndex = self.getIndex(section: .schedulClass([]))
            let explanationIndex = self.getIndex(section: .explanationClass([]))
            let exerciseIndex = self.getIndex(section: .exerciseClass([]))
            let benefitsIndex = self.getIndex(section: .benefitsClass([]))
            
            //TODO: Server API 구현시 데이터 Response 값으로 Cell Configure
            newState.section[userIndex] = .userInfoClass([HomeSectionItem.userInfoClassItem])
            newState.section[calendarIndex] = .calendarClass([])
            newState.section[ticketIndex] = .ticketClass([HomeSectionItem.ticketClassItem])
            newState.section[scheduleIndex] = .schedulClass([HomeSectionItem.schedulClassItem])
            newState.section[explanationIndex] = .explanationClass([HomeSectionItem.explanationClassItem])
            newState.section[exerciseIndex] = .exerciseClass([
                HomeSectionItem.exerciseClassItem,
                HomeSectionItem.exerciseClassItem,
                HomeSectionItem.exerciseClassItem,
                HomeSectionItem.exerciseClassItem,
                HomeSectionItem.exerciseClassItem
                
            ])
            newState.section[benefitsIndex] = .benefitsClass([
                HomeSectionItem.benefitsClassItem,
                HomeSectionItem.benefitsClassItem,
                HomeSectionItem.benefitsClassItem,
                HomeSectionItem.benefitsClassItem,
                HomeSectionItem.benefitsClassItem
            ])
            
        case .reloadClassItem:
            let userIndex = self.getIndex(section: .userInfoClass([]))
            let ticketIndex = self.getIndex(section: .ticketClass([]))
            let calendarIndex = self.getIndex(section: .calendarClass([]))
            let scheduleIndex = self.getIndex(section: .schedulClass([]))
            let explanationIndex = self.getIndex(section: .explanationClass([]))
            let exerciseIndex = self.getIndex(section: .exerciseClass([]))
            let benefitsIndex = self.getIndex(section: .benefitsClass([]))
            
            newState.section[userIndex] = .userInfoClass([HomeSectionItem.userInfoClassItem])
            newState.section[calendarIndex] = .calendarClass([HomeSectionItem.calendarClassItem])
            newState.section[ticketIndex] = .ticketClass([HomeSectionItem.ticketClassItem])
            newState.section[scheduleIndex] = .schedulClass([HomeSectionItem.schedulClassItem])
            newState.section[explanationIndex] = .explanationClass([HomeSectionItem.explanationClassItem])
            newState.section[exerciseIndex] = .exerciseClass([
                HomeSectionItem.exerciseClassItem,
                HomeSectionItem.exerciseClassItem,
                HomeSectionItem.exerciseClassItem,
                HomeSectionItem.exerciseClassItem,
                HomeSectionItem.exerciseClassItem
                
            ])
            newState.section[benefitsIndex] = .benefitsClass([
                HomeSectionItem.benefitsClassItem,
                HomeSectionItem.benefitsClassItem,
                HomeSectionItem.benefitsClassItem,
                HomeSectionItem.benefitsClassItem,
                HomeSectionItem.benefitsClassItem
            ])
        }
        
        return newState
    }
    
}



private extension HomeViewReactor {
    
    func getIndex(section: HomeSection) -> Int {
        
        var index: Int = 0
        
        for i in 0 ..< self.currentState.section.count where self.currentState.section[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
        
    }
    
    func reqeustHomeViewSection(from event: HomeViewStream.Event) -> Observable<Mutation> {
        switch event {
        case let .reloadHomeViewSection(isSelected):
            if isSelected {
                return .just(.reloadClassItem)
            } else {
                return .just(.setEmptyClassItem)
            }
        }
        
    }
    
}





