//
//  UIView.swift
//  YandexMapTask
//
//  Created by Jakhongir Nematov on 28/01/21.
//

import UIKit

extension UIView {
    class func fromNib() -> Self {
        return fromNib(nibName: nil)
    }

    class func fromNib(nibName: String?) -> Self {
        func fromNibHelper<T>(nibName: String?) -> T where T: UIView {
            let bundle = Bundle(for: T.self)
            let name = nibName ?? String(describing: T.self)
            return bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T ?? T()
        }
        return fromNibHelper(nibName: nibName)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
    
    func rotateAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
          UIView.animate(withDuration: 0.2,
                         delay: 0,
                         options: .curveLinear,
                         animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi).scaledBy(x: 1.2, y: 1.2)
          }) { [weak self] (_) in
            self?.transform = CGAffineTransform.init(rotationAngle: CGFloat.zero).scaledBy(x: 1.0, y: 1.0)
            self?.isUserInteractionEnabled = true
            completionBlock()
        }
      }
}

extension UIView: ReusableView { }
