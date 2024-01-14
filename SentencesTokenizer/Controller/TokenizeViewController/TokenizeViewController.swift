//
//  ViewController.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 13.01.2024.
//

import UIKit

class TokenizeViewController: BaseViewController {
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewPlaceholderLabel: UILabel!
    @IBOutlet private weak var tableView:LoadingTableView!
    
    var viewModel:TokenizeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func reloadData(force:Bool = true) {
        super.reloadData(force: force)
        if force {
            tableView.reloadData()
        } else {
            vibrate()
            tableView.reloadSections([0,1], with: .automatic)
        }
        textViewPlaceholderLabel.layer.caTransaction(0.3)
        textViewPlaceholderLabel.alpha = viewModel.tokenizedTableData.count == 0 ? 1 : 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        endEditing()
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
    
    
    func copyPressed(_ string:String, cell:UITableViewCell?) {
        vibrate()
        UIPasteboard.general.string = string
        reloadData(force: false)
        endEditing()
        
        animateCopy(cell ?? copiedTableStack(), removeAll: cell == nil)
    }
}

fileprivate extension TokenizeViewController {
    
    func setupUI() {
        viewModel = .init(reloadData: reloadData, endEditing: endEditing, copyPressed: copyPressed(_:cell:))
        title = viewModel.viewTitle
        tableView.delegate = self
        tableView.dataSource = self
        textViewPlaceholderLabel.text = viewModel.placeHolder
        textView.delegate = self
        textView.layer.cornerRadius = Styles.viewCornerRadius
        textViewPlaceholderLabel.alpha = Styles.lightColorOpacity
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        Task {
            viewModel.tokenizer.ignoreDotte = !DB.data.settings.separateAllDottes
        }
    }
    
    
    func copiedTableStack() -> UIView {
        var i = -1
        var res:[UIView] = []
        let mainView:UIView = .init()
        self.view.addSubview(mainView)
        mainView.addConstraints([.left:0, .right:0, .height:view.frame.height / 2, .bottom:0])
        self.tableView.visibleCells.forEach({
            i += 1
            if $0 is RegularTableCell {
                let new = $0.contentView.copy(toView: mainView, frame: .init(origin: .init(x: 0, y: $0.contentView.frame.minY + (CGFloat(i) * 40)), size: .init(width: view.frame.width, height: 40)))
                res.append(new)
            }
            
        })
        return mainView
    }
    
    func animateCopy(_ view:UIView?, removeAll:Bool) {
        guard let copy = removeAll ? view : view?.copy(toView: self.view, frame: view?.frame) else {
            return
        }
        copy.isUserInteractionEnabled = false
        copy.alpha = 0
        copy.backgroundColor = .clear
        copy.subviews.forEach({
            $0.backgroundColor = .clear
        })
        copy.layer.shadowColor = UIColor.black.cgColor
        copy.layer.shadowOpacity = 0.2
        copy.layer.zoom(value: 1.5)
        UIView.animate(withDuration: 0.25, animations: {
            copy.alpha = 0.7
            copy.layer.zoom(value: 1)
        }) { _ in
            if removeAll {
                self.vibrate()
            }
            let value:CGFloat = [100, 90, 400, 200, 300, 80, 140, 190, 90].randomElement() ?? 0
            let duration:TimeInterval = [2, 3.5, 2.35, 2.9, 3.4].randomElement() ?? 3
            UIView.animate(withDuration: duration, animations: {
                copy.layer.move(.top, value: value * -1)
            })
            UIView.animate(withDuration: duration * 1.5, animations: {
                copy.alpha = 0
            }, completion:{ _ in
                copy.removeFromSuperview()
               // self.vibrate()
            })
            
            
        }
    }
}

extension TokenizeViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.enteredValue = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        reloadData(force: true)
    }
}
