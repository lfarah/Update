//
//  ShareViewController.swift
//  ShareNewFeed
//
//  Created by Lucas Farah on 2/13/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import UIKit
import SwiftUI

class ShareViewController: UIViewController {
    private var url: NSURL?
    var shareFeedViewController: UIHostingController<ShareNewFeedView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareFeedViewController = UIHostingController(rootView: ShareNewFeedView())
        shareFeedViewController.view.translatesAutoresizingMaskIntoConstraints = false
        shareFeedViewController.view.frame = self.view.bounds
        shareFeedViewController.rootView.shouldDismiss = {
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        }
        
        self.view.addSubview(shareFeedViewController.view)
        self.addChild(shareFeedViewController)
        getURL()
    }
    
    private func getURL() {
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments!.first!
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let feeds = results["Feeds"] as? [String] {
                        self.shareFeedViewController.rootView.feeds = feeds

                    }
                }
            })
        } else {
            print("error")
        }
    }

}
