import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make sure you have view controllers set up for your tab bar
        let firstViewController = ViewController()
        let secondViewController = NewsDetailsViewController()

        firstViewController.tabBarItem = UITabBarItem(title: "First", image: UIImage(named: "first_icon"), selectedImage: UIImage(named: "first_icon_selected"))
        secondViewController.tabBarItem = UITabBarItem(title: "Second", image: UIImage(named: "second_icon"), selectedImage: UIImage(named: "second_icon_selected"))

        self.viewControllers = [firstViewController, secondViewController]
    }
}
