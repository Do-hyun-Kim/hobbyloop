//
//  HPCalendarViewReactor.swift
//  HPCommonUI
//
//  Created by Kim dohyun on 2023/08/20.
//

import Foundation

import ReactorKit
import RxSwift


public final class HPCalendarViewReactor: Reactor {
    
    //MARK: Property
    public var initialState: State
    public var calendarConfigureProxy: HPCalendarDelgateProxy & HPCalendarBubbleDelegateProxy & HPCalendarInterface
    
    
    //MARK: Action
    public enum Action {
        case changeCalendarStyle(CalendarStyle)
        case didTapNextDateButton
        case didTapPreviousDateButton
    }
    
    //MARK: Mutation
    public enum Mutation {
        case setCalendarItems([CalendarSectionItem])
        case updateCalendarStyle(CalendarStyle)
        case setUpdateMonthItem(String)
        case setBubbleCalendarDay(Int)
    }
    
    //MARK: State
    public struct State {
        var itemCount: Int
        var month: String
        var nowDay: Int
        var style: CalendarStyle
        @Pulse var section: [CalendarSection]
    }
    
    
    public init(calendarConfigureProxy: HPCalendarDelgateProxy & HPCalendarBubbleDelegateProxy & HPCalendarInterface) {
        self.calendarConfigureProxy = calendarConfigureProxy
        self.initialState = State(
            itemCount: 0,
            month: "",
            nowDay: 1,
            style: .default,
            section: [
                .calendar([])
            ]
        )
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
            
        case .didTapNextDateButton:
            return .concat(
                calendarConfigureProxy.updateNextDateCalendar(),
                calendarConfigureProxy.updateNextMonthCalendar()
            )
        case .didTapPreviousDateButton:
            
            return .concat(
                calendarConfigureProxy.updatePreviousDateCalendar(),
                calendarConfigureProxy.updateNextMonthCalendar()
            )
            
        case let .changeCalendarStyle(style):
            switch style {
            case .bubble:
                return .concat([
                    calendarConfigureProxy.configureBubbleCalendar(),
                    calendarConfigureProxy.configureBubbleCalendarDay()
                ])
            case .default:
                return .concat([
                    calendarConfigureProxy.configureCalendar(),
                    calendarConfigureProxy.updateNextMonthCalendar()
                ])
            }
        }
        
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        
        switch mutation {
            
        case let .setCalendarItems(items):
            let calendarSectionIndex = self.getIndex(section: .calendar([]))
            newState.section[calendarSectionIndex] = .calendar(items)
            newState.itemCount = items.count
        case let .setUpdateMonthItem(nextMonth):
            newState.month = nextMonth
        case let .updateCalendarStyle(style):
            newState.style = style
        case let .setBubbleCalendarDay(nowDay):
            newState.nowDay = nowDay
        }
        
        return newState
    }
    
}



private extension HPCalendarViewReactor {
    
    func getIndex(section: CalendarSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.section.count where self.currentState.section[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
        
    }
    
}

