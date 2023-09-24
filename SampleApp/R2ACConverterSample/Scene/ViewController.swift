import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = R.image.foo_bar_1()
        imageView.image = R.image.foo_bar_1()!

        view.backgroundColor = R.color.blue()
        view.backgroundColor = R.color.blue()!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let images = [
            R.image.foo_bar_1(),
            R.image.foo_bar_1_2(),
            R.image.foo_bar_2(),
            R.image.foo_bar_baz(),
            R.image.fooBarBaz(),
        ]

        imageView.image = images.shuffled().first!

        let colors = [
            R.color.blue(),
            R.color.blue1(),
            R.color.blue_1_2(),
            R.color.blue1_2(),
        ]

        view.backgroundColor = colors.shuffled().first!
    }
}
