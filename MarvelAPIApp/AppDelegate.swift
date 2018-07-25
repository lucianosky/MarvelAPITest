//
//  AppDelegate.swift
//  MarvelAPIApp
//
//  Created by Luciano Sclovsky on 25/06/2018.
//

import UIKit

// @UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let characterListViewController = storyboard.instantiateViewController(withIdentifier: "characterListViewController") as! CharacterListViewController
        let characterViewModel = CharacterViewModel()
        characterViewModel.networkService = NetworkService.shared
        characterListViewController.characterViewModel = characterViewModel
        self.window?.rootViewController = characterListViewController
        self.window?.makeKeyAndVisible()
        return true
    }

}

