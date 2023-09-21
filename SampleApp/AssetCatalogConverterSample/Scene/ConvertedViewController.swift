import UIKit

final class ConvertedViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(resource: .fooBar1)
        imageView.image = UIImage(resource: .fooBar2)

        view.backgroundColor = UIColor(resource: .blue)
        view.backgroundColor = UIColor(resource: .blue)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let images = [
            UIImage(resource: .fooBar1),
            UIImage(resource: .fooBar12),
            UIImage(resource: .fooBar2),
            UIImage(resource: .fooBarBaz),
            UIImage(resource: .fooBarBaz),
        ]

        imageView.image = images.shuffled().first!

        let colors = [
            UIColor(resource: .blue),
            UIColor(resource: .blue1),
            UIColor(resource: .blue12),
            UIColor(resource: .blue12)
        ]

        view.backgroundColor = colors.shuffled().first!
    }

    @IBAction func didBackToRswiftWorldButtonTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
