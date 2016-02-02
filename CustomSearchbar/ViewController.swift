//
//  ViewController.swift
//  CustomSearchbar
//
//  Created by Howard on 1/24/16.
//  Copyright © 2016 Howard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //searchButton 与屏幕边缘的边距.
    struct SearchButtonEdge {
        static let leftEdge: CGFloat = 10.0
        static let rightEdge: CGFloat = 10.0
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: DesignableLabel!

    @IBOutlet weak var navigationBarBackgroundView: UIImageView!
    @IBOutlet weak var searchBackgroundView: DesignableImageView!
    
    @IBOutlet weak var clouseButton: DesignableButton!
    @IBOutlet weak var searchButton: DesignableButton!
    
    @IBOutlet var accessoryView: UIView!
    
    var searchTextField:DesignableTextField = DesignableTextField()
    
    var headerView = UIImageView()
    
    let filterHelper = FilterHelper()
    
    var hasSearch = false
    
    var searchBarApperance = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBackgroundView.userInteractionEnabled = true
        navigationBarBackgroundView.userInteractionEnabled = true
    
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        searchTextField.delegate = self
        setupTextField()
        setupTableViewHeaderView()
        
    }
    

    func setupTextField() {
   
        searchTextField.frame = CGRectMake(
            SearchButtonEdge.leftEdge + searchButton.frame.width,
            22,
            view.frame.width - (SearchButtonEdge.leftEdge + searchButton.frame.width + clouseButton.frame.width + SearchButtonEdge.rightEdge),
            40)
        
        searchTextField.frame.origin.x = searchButton.frame.width + SearchButtonEdge.leftEdge
        searchTextField.borderStyle = .None
        searchTextField.textColor = UIColor.whiteColor()
        searchTextField.tintColor = UIColor.whiteColor()
        searchTextField.font = UIFont(name: "Avenir Next", size: 18)
        searchBackgroundView.addSubview(searchTextField)
      
    }
    
    func setupTableViewHeaderView() {
        
        let backgroudView = UIView()
        backgroudView.frame = CGRectMake(0, 0, view.frame.width, 30 )
        
        headerView = UIImageView(image: UIImage(named: "barcode-1"))
        headerView.frame.size = CGSizeMake(20, 13)
        headerView.center = CGPoint(x: view.frame.width/2.0 + 20, y: 10)
        
        backgroudView.addSubview(headerView)
        
        
        tableView.tableHeaderView = backgroudView
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        if searchTextField.isFirstResponder() && searchBarApperance {
            //解决如果在键盘界面翻转屏幕后,searchButton 的位置没变到最右边的 BUG
            searchBarAnimateIn()
        }

    }
    
    func searchBarAnimateIn() {
        //键盘弹出
        searchTextField.becomeFirstResponder()
        searchTextField.hidden = false
        //改变状态
        searchBarApperance = true
        
        //title 消失,同时在左边界外准备随时回来.
        titleLabel.hidden = true
//        print("titleFrame.x = \(titleLabel.frame.origin.x)")
        titleLabel.frame.origin.x = navigationBarBackgroundView.frame.origin.x - titleLabel.frame.width
        
        searchBackgroundView.animation = "slideLeft"
        searchBackgroundView.duration = 1.0
//        searchBackgroundView.force = 2.2
        
        //searchBackgroudView现在是在最后边,宽度为1或者0 ,看不到.并且是 hidden 状态.
        //设置 searchBV 的 frame 为 Custom 的 NavigationBar 的 frame
        searchBackgroundView.hidden = false
        let mainFrame = navigationBarBackgroundView.frame
        searchBackgroundView.frame = mainFrame
        searchBackgroundView.frame.origin.x = 0
        //将自定义的 textField 添加到 searchBV 上
        if searchBackgroundView.subviews.isEmpty {
            print("*** add textField in searchBackgroudView ***")
//            setupTextField()
        }
        
        //动起来
        searchBackgroundView.animate()
        
        
        searchButton.animation = "slideLeft"
        searchButton.duration = 1.0
        //x 坐标在最左边,留 10 边距.
        searchButton.frame.origin.x = SearchButtonEdge.leftEdge
        //动起来
        searchButton.animateNext {
            
            if self.searchButton.frame.origin.x == SearchButtonEdge.leftEdge {
                self.clouseButton.frame.origin.x = self.view.frame.width - self.clouseButton.frame.width - SearchButtonEdge.rightEdge
                self.clouseButton.hidden = false
                self.clouseButton.animation = "morph"
                self.clouseButton.duration = 1.3
                self.clouseButton.animate()
            }
         
        }
        
    }
    
    func searchBarAnimateOut() {
        clouseButton.hidden = true
        clouseButton.frame.origin.x = view.frame.width
        
        //键盘消失
        searchTextField.resignFirstResponder()
        searchTextField.hidden = true
//        searchTextField.removeFromSuperview()
        searchBarApperance = false
        
        titleLabel.animation = "slideRight"
        titleLabel.duration = 1.0
        //居中
        titleLabel.frame.origin.x = view.frame.width/2.0 - titleLabel.frame.width/2.0
        titleLabel.hidden = false
        
        //动起来
        titleLabel.animate()
        
        searchBackgroundView.animation = "fadeOut"
        searchBackgroundView.duration = 2.0

        searchBackgroundView.animate()
//            self.searchBackgroundView.frame.origin.x = self.navigationBarBackgroundView.frame.width

        
//        searchBackgroundView.frame = CGRectMake(view.frame.width, 0, view.frame.width + 30, 64)
        
        searchButton.animation = "slideRight"
        searchButton.duration = 1.0
        searchButton.frame.origin.x = view.frame.width - searchButton.frame.width - SearchButtonEdge.rightEdge
//        searchButton.x = navigationBarBackgroundView.frame.width - searchButton.frame.width - SearchButtonEdge.rightEdge
        searchButton.animateNext {
               // 如果searchButton 在还没完全进入的时候如果触发消失,确保 clouseButton 不会同时出现在右边
//               self.clouseButton.hidden = true
        }
}

    @IBAction func searchButtonTouch(sender: AnyObject) {
        
        if !searchBarApperance {
            searchBarAnimateIn()
        } else {
            searchBarAnimateOut()
        }
            
    }
        
        
        
        
    @IBAction func clouseButtonTouch(sender: AnyObject) {
        searchBarAnimateOut()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        let yOffset = scrollView.contentOffset.y
        if yOffset < 0 {
//            print("\(yOffset)")
            let totalOffset = abs(yOffset)
            let f = totalOffset / 6
            
            if f < 9 {
                headerView.frame = CGRectMake(view.frame.width / 2.0 - (20 + f) / 2, 5 , 20 + f, 13 + f / 1.5)
            }
            
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
       
 
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let yOffset = scrollView.contentOffset.y
        print("Offset = \(yOffset)")
        if yOffset < -40{
            if !searchBarApperance && !searchTextField.isFirstResponder(){
                searchBarAnimateIn()
            } else {
                searchBarAnimateOut()
            }
            
        }
    }
}




extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "历史纪录"
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(filterHelper.filterWordsArray.count)")
        return filterHelper.filterWordsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        
        

        
        cell?.textLabel?.text = filterHelper.filterWordsArray[indexPath.row]
//        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 16)
        
        return cell
    }
    
    
    
}

extension ViewController: UITextFieldDelegate {
 
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        guard let _ = textField.inputAccessoryView  else {
            textField.inputAccessoryView = accessoryView
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        
//    }
//    m
//    func textFieldShouldClear(textField: UITextField) -> Bool {
//        
//    }
//    
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        
//    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        hasSearch = true
        
        if textField.text!  == "" {
            filterHelper.filterContontFromTextField(string)
        } else {
            
            let currentText = textField.text! as NSString
            
           let oldString =  currentText.stringByReplacingCharactersInRange(range, withString: string)
            
            let newString: String = oldString as String
            
            print("\(newString)")
            
            filterHelper.filterContontFromTextField(newString)
        }
        
        
        
        
        
        tableView.reloadData()
        
        return true
    }
}

