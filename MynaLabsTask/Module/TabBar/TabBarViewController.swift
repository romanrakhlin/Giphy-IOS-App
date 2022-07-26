//
//  TabBarViewController.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        viewControllers = TabBar.allCases.map {$0.viewController}
        addCustomTabBarView()
        hideTabBarBorder()
        self.selectedIndex = 0
        self.delegate = self
        self.tabBar.tintColor = .red
    }
    
    let customTabBarView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBarView.frame = tabBar.frame
    }
    
    func addCustomTabBarView() {
        customTabBarView.frame = tabBar.frame
        view.addSubview(customTabBarView)
        view.bringSubviewToFront(self.tabBar)
    }
    
    func hideTabBarBorder() {
        let tabBar = self.tabBar
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true
        tabBar.layer.masksToBounds = false
    }
}

enum TabBar: String, CaseIterable {
    
    case home
    
    var viewController: UINavigationController {
        var viewController = UINavigationController()
        switch self {
        case .home:
            viewController = UINavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel()))
        }
        
        viewController.tabBarItem = tabBarItem
        viewController.tabBarItem.imageInsets.top = 5
        return viewController
    }
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return .init(title: nil, image: UIImage(named: TabBar.home.rawValue), selectedImage: UIImage(named: TabBar.home.rawValue))
        }
    }
}
