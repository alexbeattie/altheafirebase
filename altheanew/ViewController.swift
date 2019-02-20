//
//  ViewController.swift
//  altheanew
//
//  Created by Alex Beattie on 2/19/19.
//  Copyright © 2019 Alex Beattie. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"

    private var documents: [DocumentSnapshot] = []
    public var tasks: [Task]?
    private var listener : ListenerRegistration!
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("Tasks").limit(to: 50)
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
//    let homeCollectionView:UICollectionView = {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//        return collectionView
//
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.query = baseQuery()

        print(listener)
        self.listener =  query?.addSnapshotListener { (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let results = snapshot.documents.map { (document) -> Task in
                if let task = Task(dictionary: document.data(), id: document.documentID) {
                    return task
                } else {
                    fatalError("Unable to initialize type \(Task.self) with dictionary \(document.data())")
                }
            }
            
            self.tasks = results
            self.documents = snapshot.documents

            self.collectionView?.reloadData()
            self.collectionView?.backgroundColor = UIColor.white
            self.collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: self.cellId)
            self.collectionView?.dataSource = self
            self.collectionView?.delegate = self
            self.collectionView?.contentInset = UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0)
            self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0)
        }
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let height = (view.frame.width - 16 - 16) * 9 / 16
            return CGSize(width: view.frame.width, height: height + 16 + 88)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        
        cell.task = tasks?[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = tasks?.count {
            return count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.listener.remove()
    }
}
class HomeCell: UICollectionViewCell {
    var task: Task? {
        didSet {
            
            if let listingId = task?.name {
                print(listingId)
                nameLabel.text = listingId
//                task?.name = listingId
            }
            setupThumbNailImage()
            if let theAddress = task?.id {
                print(theAddress)
                costLabel.text = theAddress
                //                task?.name = listingId
            }
            if let theAddress = task?.done {
                print(task?.done)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best New Apps"
        //        label.text?.uppercased()
        label.font = UIFont(name: "Avenir Heavy", size: 17)
        label.sizeToFit()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let costLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bedRoom: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let bathRoom: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let squareFeet: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = UIImage(named:"pic")
        //        iv.backgroundColor = UIColor.black
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    
    
    func setupThumbNailImage() {
        
        
//        if let thumbnailImageUrl = listing?.StandardFields.Photos[0].Uri1024 {
//            imageView.loadImageUsingUrlString(urlString: (thumbnailImageUrl))
//        }
        
    }
    func setupViews() {
        //        backgroundColor = UIColor.clear
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(costLabel)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]-14-|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0]-20-|", views: nameLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: costLabel)
        addConstraintsWithFormat(format: "V:[v0]-4-|", views: costLabel)
        
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        
        
    }
}






let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString: String?
    func loadImageUsingUrlString(urlString: String) {
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data:data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                
            }
            
        }).resume()
    }
}

class GradientView: UIView {
    lazy private var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor(white: 0.0, alpha: 0.75).cgColor]
        layer.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
    }
}

