//
//  EventViewModel.swift
//  TestSicredi
//
//  Created by George Gomes on 17/05/20.
//  Copyright © 2020 George Gomes. All rights reserved.
//
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//class EventViewModel {
//    
//    // MARK: - Variables
//    private var event: Event!
//    
//    // MARK: - Intputs/Outputs
//    struct Output {
//        let title: Driver<String?>
//        let date: Driver<String?>
//        let imageLink: Driver<String?>
//    }
//    
//    // MARK: - Life Cycle
//    init(event: Event) {
//        self.event = event
//    }
//    
//    // MARK: - Functions
//    func transform() -> EventViewModel.Output {
//        let title = Observable<String?>.create { (observer) -> Disposable in
//            observer.onNext(self.event.title)
//            return Disposables.create()
//        }
//        .asDriver(onErrorJustReturn: "Nome indisponível")
//        
//        let date = Observable<String?>.create { (observer) -> Disposable in
//            observer.onNext(self.event.date?.toFormatedString())
//            return Disposables.create()
//        }
//        .asDriver(onErrorJustReturn: "Data indisponível")
//        
//        let imageLink = Observable<String?>.create { (observer) -> Disposable in
//            observer.onNext(self.event.image)
//            return Disposables.create()
//        }
//        .asDriver(onErrorJustReturn: StringHelper.imageNotFound)
//        
//        let output = Output(title: title, date: date, imageLink: imageLink)
//        return output
//    }
//}
//

