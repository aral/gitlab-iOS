//
//  IssueTableViewCell.swift
//  gitlab-iOS
//
//  Created by Xplorld on 2016/3/20.
//  Copyright © 2016年 dyweb. All rights reserved.
//

import UIKit
import TagListView

class IssueTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tagsView: TagListView!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 5.0
        avatarImageView.clipsToBounds = true
    }
}

class IssueTableViewCellViewModel : TableViewCellViewModel {
    
    let issue:Issue
    init(issue:Issue) {
        self.issue = issue
    }
    
    @objc let cellIdentifier =  "IssueCell"
    
    @objc func configureCell(cell:UITableViewCell) {
        let theCell = cell as! IssueTableViewCell
        theCell.titleLabel.text = issue.title
        theCell.IDLabel.text = "#\(issue.iid)"
        theCell.assigneeLabel.text = issue.assignee?.name
        UIImage.imageFromURL(URL: issue.assignee?.avatar_url) {
            theCell.avatarImageView.image = $0
        }
        
        theCell.tagsView.removeAllTags()
        for (label,color) in LabelTinter.tintLabels([issue.state.rawValue] + issue.labels) {
            theCell.tagsView.addTag(label).tagBackgroundColor = color
        }
        theCell.layoutIfNeeded()
        theCell.titleLabel.preferredMaxLayoutWidth = theCell.titleLabel.frame.width
    }
    
    @objc func didSelectCell(indexPath:NSIndexPath,controller:RYTableViewController) {
        controller.performSegueWithIdentifier("DetailToIssueSegue", sender: self.issue) {segue,sender in
            let vc = segue.destinationViewController as! IssueTableViewController
            vc.issue = sender as! Issue
        }
    }
    
    @objc var resetAfterSelect = true
}