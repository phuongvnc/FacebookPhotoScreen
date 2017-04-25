//
//  PhotoDetailViewController.swift
//  Wellmeshi
//
//  Created by PhuongVNC on 11/11/16.
//  Copyright © 2016 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var photoImageView: UIImageView!
    @IBOutlet fileprivate weak var bgView: UIView!
    @IBOutlet fileprivate weak var closeButton: UIButton!
    @IBOutlet fileprivate weak var likeButton: UIButton!
    @IBOutlet fileprivate weak var commentButton: UIButton!
    @IBOutlet fileprivate weak var actionView: UIView!

    var image: UIImage?
    var panImageView: UIImageView!

    var isAction: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5, animations: {
                self.closeButton.isHidden = self.isAction
                self.likeButton.isHidden = self.isAction
                self.commentButton.isHidden = self.isAction
                self.actionView.isHidden = self.isAction
            })

        }
    }

    private var startPoint: CGPoint!
    private var center: CGPoint!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpUI()
        initPanImageView()
    }

    func setUpUI() {
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 6
        scrollView.delegate = self
        scrollView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(actionPanImageView(pan:))))
    }

    func initPanImageView() {
        panImageView = UIImageView(image: self.image)
        guard let image = image else {
            return
        }

        let width =   view.bounds.width
        let height = (image.size.height * width) / image.size.width
        panImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        panImageView.contentMode = UIViewContentMode.scaleAspectFill
        panImageView.tag = 100 //Add tag for image view. When controller dismissed then controller transition will get image view by tag and show animation
        panImageView.clipsToBounds = true
    }

     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        center = view.center
    }

    func setUpData() {
        photoImageView.image = image
    }

    func actionPanImageView(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            isAction = true
            startPoint = pan.location(in: self.view)
            scrollView.zoomScale = 1
            scrollView.isHidden = true
            panImageView.center = view.center
            view.addSubview(panImageView)
            break
        case .changed:
            let updatePoint = pan.location(in: view)
            let dy = abs(startPoint.y - updatePoint.y)
            let dx = abs(startPoint.x - updatePoint.x)
            var scale = updatePoint.y > startPoint.y ? startPoint.y/updatePoint.y : updatePoint.y/startPoint.y
            scale = scale > 0.6 ? scale : 0.6
            let y = updatePoint.y > startPoint.y ? center.y + dy : center.y - dy
            let x = updatePoint.x > startPoint.x ? center.x + dx : center.x - dx
            panImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            panImageView.center = CGPoint(x: x, y: y)
            bgView.alpha = scale
            break
        case .ended:
            let updatePoint = pan.location(in: self.view)
            let distanceY = updatePoint.y > startPoint.y ? updatePoint.y - startPoint.y : startPoint.y - updatePoint.y
            if distanceY > 70 {
                bgView.alpha = 0
                panImageView.contentMode = .scaleAspectFill
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.panImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.panImageView.center = self.center
                }, completion: { (completed) in
                     self.scrollView.isHidden = false
                     self.panImageView.removeFromSuperview()
                     self.isAction = false
                })
                bgView.alpha = 1
            }
            break
        default:
            break
        }
    }

    @IBAction func close(sender: UIButton) {
        if panImageView.superview == nil{
            panImageView.center = view.center
            view.addSubview(panImageView)
            scrollView.isHidden = true
            bgView.alpha = 0
        }
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UIScrollViewDelegate
extension PhotoDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        closeButton.isHidden = true
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        closeButton.isHidden = !(scale == 1)
    }
}
