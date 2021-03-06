//
//  Reactive.swift
//  TestSicredi
//
//  Created by George Gomes on 17/05/20.
//  Copyright © 2020 George Gomes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import MapKit

extension Reactive where Base : UIButton {
   public var valid : Binder<Bool> {
        return Binder(self.base) { button, valid in
            button.isEnabled = valid
            button.setTitleColor(valid ? .white : .black, for: .normal)
        }
    }
}

extension Reactive where Base : UIImageView {
    var loadImage: Binder<String?> {
        return Binder(self.base) {imageView, link in
            imageView.sd_setImage(with: URL(string: link ?? StringHelper.imageNotFound), placeholderImage: #imageLiteral(resourceName: "placeholder")) { (_, err, _, _) in
                guard (err != nil) else { return }
                imageView.image = #imageLiteral(resourceName: "noImage")
            }
        }
    }
}

extension Reactive where Base : UITextView {
    var inputText: Binder<String?> {
        return Binder(self.base) {textView, text in
            textView.text = text
        }
    }
}

extension Reactive where Base : UpdatableViewController {
    var eventLoadingState : Binder<NetworkingState<[Event]>> {
        return Binder(self.base) { vc, state in
           switch state {
            case .loading:
                vc.showLoading()
            case .success:
                vc.removeLoading()
            case .fail(let error):
                vc.removeLoading()
                let err = NetworkingError(error: error)
                vc.alertSimpleMessage(message: err.errorDescription, action: nil)
            case .default:
                break
            }
        }
    }
    
    var checkinLoadingState : Binder<NetworkingState<Data>> {
        return Binder(self.base) { vc, state in
           switch state {
            case .loading:
                vc.showLoading()
            case .success:
                vc.removeLoading()
                vc.alertSimpleWarning(title: "Sucesso", message: "Checkin efetuado com sucesso") { (_) in
                    vc.navigationController?.popViewController(animated: true)
                }
            case .fail(let error):
                vc.removeLoading()
                let err = NetworkingError(error: error)
                vc.alertSimpleMessage(message: err.errorDescription, action: nil)
            case .default:
                break
            }
        }
    }
}

extension Reactive where Base: MKMapView {
    var coordinates: Binder<(Double, Double)> {
        return Binder(self.base) { map, coordinate in
            let initialLocation = CLLocation(latitude: coordinate.0, longitude: coordinate.1)
            let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.0, longitude: coordinate.1)
            map.addAnnotation(annotation)
            map.setRegion(coordinateRegion, animated: true)
        }
    }
}

class UpdatableViewController: UIViewController {
       private var loadView : UIView?
}

extension UpdatableViewController {

    func showLoading() {
        let wallView = UIView.init(frame: self.view.bounds)
        wallView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        indicator.startAnimating()
        indicator.center = wallView.center

        DispatchQueue.main.async {
            wallView.addSubview(indicator)
            self.view.addSubview(wallView)
        }

        loadView = wallView
    }

    func removeLoading() {
        DispatchQueue.main.async {
            self.loadView?.removeFromSuperview()
            self.loadView = nil
        }
    }
}

