//
//  MoreViewController.swift
//  Potatso
//
//  Created by LEI on 1/23/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

import UIKit
import Eureka
import Appirater
import ICSMainFramework
import MessageUI
import SafariServices
import PotatsoLibrary

enum FeedBackType: String, CustomStringConvertible {
    case Email = "Email"
    case Forum = "Forum"
    case None = ""
    
    var description: String {
        return rawValue.localized()
    }
}



class SettingsViewController: FormViewController, MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate {
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "More".localized()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        generateForm()
    }

    func generateForm() {
        form.delegate = nil
        form.removeAll()
        form +++ generateManualSection()
        form +++ generateSyncSection()
        form +++ generateRateSection()
        form +++ generateAboutSection()
        form.delegate = self
        tableView?.reloadData()
    }

    func generateManualSection() -> Section {
        let section = Section()
        section
            <<< ActionRow {
                $0.title = "User Manual".localized()
            }.onCellSelection({ [unowned self] (cell, row) in
                self.showUserManual()
            })
            /*
            <<< ActionRow {
                $0.title = "Feedback".localized()
            }.onCellSelection({ (cell, row) in
                FeedbackManager.shared.showFeedback()
            })
            */
        return section
    }

    func generateSyncSection() -> Section {
        let section = Section()
        section
            <<< ActionRow() {
                $0.title = "Import From URL".localized()
            }.onCellSelection({ [unowned self] (cell, row) -> () in
                let importer = Importer(vc: self)
                importer.importConfigFromUrl()
            })
            <<< ActionRow() {
                $0.title = "Import From QRCode".localized()
            }.onCellSelection({ [unowned self] (cell, row) -> () in
                let importer = Importer(vc: self)
                importer.importConfigFromQRCode()
            })
        return section
    }

    func generateRateSection() -> Section {
        let section = Section()
        section
            <<< ActionRow() {
                $0.title = "Feedback".localized()
            }.onCellSelection({ (cell, row) -> () in
                Appirater.rateApp()
            })
            <<< ActionRow() {
                $0.title = "Share with friends".localized()
            }.onCellSelection({ [unowned self] (cell, row) -> () in
                self.shareWithFriends()
            })
        return section
    }

    func generateAboutSection() -> Section {
        let section = Section()
        section
            <<< LabelRow() {
                $0.title = "Logs".localized()
                }.cellSetup({ (cell, row) -> () in
                    cell.accessoryType = .DisclosureIndicator
                    cell.selectionStyle = .Default
                }).onCellSelection({ [unowned self](cell, row) -> () in
                    cell.setSelected(false, animated: true)
                    self.navigationController?.pushViewController(LogDetailViewController(), animated: true)
                    })
            /*
            <<< ActionRow() {
                $0.title = "Follow on Twitter".localized()
                $0.value = "@PotatsoApp"
            }.onCellSelection({ [unowned self] (cell, row) -> () in
                self.followTwitter()
            })
            <<< ActionRow() {
                $0.title = "Follow on Weibo".localized()
                $0.value = "@Potatso"
            }.onCellSelection({ [unowned self] (cell, row) -> () in
                self.followWeibo()
             })
             */
            <<< ActionRow() {
                $0.title = "Join Telegram Group".localized()
                $0.value = "@Mume"
            }.onCellSelection({ [unowned self] (cell, row) -> () in
                self.joinTelegramGroup()
            })
            <<< LabelRow() {
                $0.title = "Version".localized()
                $0.value = AppEnv.fullVersion
            }
        return section
    }

    func showUserManual() {
        let url = "http://vpn.liruqi.info/ios/"
        let vc = BaseSafariViewController(URL: NSURL(string: url)!, entersReaderIfAvailable: false)
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }

    func followTwitter() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/intent/user?screen_name=potatsoapp")!)
    }

    func followWeibo() {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://weibo.com/potatso")!)
    }

    func joinTelegramGroup() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://telegram.me/mumevpn")!)
    }

    func shareWithFriends() {
        var shareItems: [AnyObject] = []
        shareItems.append("Mume VPN: https://itunes.apple.com/us/app/id1144787928")
        shareItems.append(UIImage(named: "AppIcon60x60")!)
        let shareVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.presentViewController(shareVC, animated: true, completion: nil)
    }

    @objc func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}