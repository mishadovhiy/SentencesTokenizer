//
//  LoadingCell.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

class LoadingTableView: UITableView {
    
    private var activityIndicator:UIActivityIndicatorView? {
        return self.subviews.first(where: {$0 is UIActivityIndicatorView}) as? UIActivityIndicatorView
    }
    var refresh:UIRefreshControl? {
        return self.subviews.first(where: {$0 is UIRefreshControl}) as? UIRefreshControl
    }
    
    var refreshBackgroundColor:UIColor?
    private var _refreshAction:(()->())?
    
    private var viewMoved = false
    private var reloadCalled = false

    override func removeFromSuperview() {
        super.removeFromSuperview()
        if viewMoved {
            refreshAction = nil
            activityIndicator?.removeFromSuperview()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if !viewMoved {
            viewMoved = true
            addActivityView()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        if !reloadCalled {
            reloadCalled = true
        } else {
            endAllAnimations()
        }
    }
    
    private func endAllAnimations() {
        if viewMoved {
            refresh?.endRefreshing()
            activityIndicator?.stopAnimating()
        }
    }
    
    override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        super.reloadSections(sections, with: animation)
        endAllAnimations()
    }
    
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.reloadRows(at: indexPaths, with: animation)
        endAllAnimations()
    }
    
    var refreshAction:(()->())? {
        get {
            return _refreshAction
        }
        set {
            _refreshAction = newValue
            if refresh == nil && newValue != nil {
                addRefreshControll()
                startAnimating()
            } else if newValue == nil {
                refresh?.removeFromSuperview()
            }
        }
    }
    
    /**
     - to animate UIRefreshControll
     - UIRefreshControll located on top of the UITableView
     */
    func startRefreshing(completion:(()->())? = nil) {
        refresh?.beginRefreshing()
        completion?()
    }
    
    /**
     - to animate UIActivityIndicatorView
     - UIActivityIndicatorView located in the middle of the UITableView
     */
    func startAnimating(completion:(()->())? = nil) {
        activityIndicator?.startAnimating()
        completion?()
    }
    
    @objc private func refreshed(_ sender:UIRefreshControl) {
        if let refreshAction = refreshAction {
            sender.beginRefreshing()
            refreshAction()
        } else {
            sender.endRefreshing()
        }
    }
}


fileprivate extension LoadingTableView {
    func addActivityView() {
        if activityIndicator != nil {
            return
        }
        let activityIndicator:UIActivityIndicatorView = .init(style: .medium)
        activityIndicator.layer.name = "activityIndicator"
        activityIndicator.tintColor = K.Colors.title
        activityIndicator.color = K.Colors.title
        addSubview(activityIndicator)
        activityIndicator.addConstraints([.centerX:0, .centerY:0])
        activityIndicator.startAnimating()
    }
    
    func addRefreshControll() {
        if refresh != nil {
            return
        }
        let refresh = UIRefreshControl()
        refresh.layer.name = "UIRefreshControl"
        refresh.addTarget(self, action: #selector(self.refreshed(_:)), for: .valueChanged)
        addSubview(refresh)
        refresh.tintColor = K.Colors.title
        refresh.backgroundColor = refreshBackgroundColor ?? .clear
    }
}
