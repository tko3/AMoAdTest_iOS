//
//  MasterViewController.swift
//  AMoAdTest
//
//  Created by 髙尾 昭義 on 2018/12/06.
//  Copyright © 2018 髙尾 昭義. All rights reserved.
//

import UIKit
import AMoAd

class MasterViewController: UITableViewController {

  var objects: [String] = [
    "バナー",
    "インタースティシャル",
    "インフィードAfiO",
    "インタースティシャルAfiO",
    "WebView(URL指定)",
    "WebView(SID指定)"
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath.row) {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath)
      cell.textLabel!.text = objects[indexPath.row]
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "InterstitialCell", for: indexPath)
      cell.textLabel!.text = objects[indexPath.row]
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "InfeedAfiOCell", for: indexPath)
      cell.textLabel!.text = objects[indexPath.row]
      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "InterstitialAfiOCell", for: indexPath)
      cell.textLabel!.text = objects[indexPath.row]
      return cell
    case 4:
      let cell = tableView.dequeueReusableCell(withIdentifier: "WebViewUrlCell", for: indexPath)
      cell.textLabel!.text = objects[indexPath.row]
      return cell
    case 5:
      let cell = tableView.dequeueReusableCell(withIdentifier: "WebViewSidCell", for: indexPath)
      cell.textLabel!.text = objects[indexPath.row]
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath)
      return cell
    }
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return false
  }
}

