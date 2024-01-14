//
//  UITableView_TokenizeViewController.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

extension TokenizeViewController:UITableViewDelegate, UITableViewDataSource {
    private var tableData:[TableData] {
        return viewModel.tableData
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = tableData[indexPath.section].tableData[indexPath.row]
        var cell:UITableViewCell!
        if let _ = rowData.switchCell {
            cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath)
            let cellResult = cell as! SwitchCell

            cellResult.set(rowData)
            if tableData[indexPath.section].cornerSection {
                cellResult.setCornered(indexPath: indexPath, dataCount: tableData[indexPath.section].tableData.count, for: cellResult.corneredBackgroundView)
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "RegularTableCell", for: indexPath)
            let cellResult = cell as! RegularTableCell
            cellResult.set(rowData)
        }
        let separetor = tableData[indexPath.section].needSeparetor ? 8 : (tableView.frame.width / 2)
        cell.separatorInset = .init(top: 0, left: separetor, bottom: 0, right: separetor)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableData[indexPath.section].tableData[indexPath.row].didSelect?(self.tableView(tableView, cellForRowAt: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: footer + header
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableData[section].needFooter {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableData[section].needFooter ? 20 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableData[section].title != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegularTableCell") as? RegularTableCell
            cell?.set(text: tableData[section].title, image: tableData[section].sectionImage, isSection:true, button: tableData[section].additionalButton)
            cell?.additionalButton.layer.name = "\(section)"
            cell?.additionalButton.addTarget(self, action: #selector(sectionAdditionalPressed(_:)), for: .touchUpInside)
            cell?.contentView.backgroundColor = view.backgroundColor
            if tableData[section].sectionPressed != nil {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionTapped(_:)))
                gesture.name = "\(section)"
                cell?.contentView.addGestureRecognizer(gesture)
            }
            return cell?.contentView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableData[section].title == "" ? 0 : UITableView.automaticDimension
    }
    
    //MARK: Additional
    @objc private func sectionTapped(_ sender:UITapGestureRecognizer) {
        guard let section = sender.name,
              let int = Int(section) else {
            return
        }
        tableData[int].sectionPressed?()
    }
    
    @objc private func sectionAdditionalPressed(_ sender: UIButton) {
        guard let str = sender.layer.name,
              let section = Int(str)
        else {
            return
        }
        tableData[section].additionalButton?.pressed()
    }
}
