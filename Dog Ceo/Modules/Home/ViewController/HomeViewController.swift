//
//  HomeViewController.swift
//  Dog Ceo
//
//  Created by Samuel on 05-02-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var dogsCollectionView: UICollectionView!
    @IBOutlet weak var dogsCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    var refresher:UIRefreshControl!
    
    public static var sectionWidth : CGFloat?
    
    var breedArray = Array<Breed>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIApplication.shared.statusBarOrientation.isPortrait {
            HomeViewController.sectionWidth = (UIScreen.main.bounds.width / 3) - 6
        }else{
            HomeViewController.sectionWidth = (UIScreen.main.bounds.height / 3) - 6
        }
        
        subDogsCollectionCells()
        
        self.refresher = UIRefreshControl()
        self.dogsCollectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.clear
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.dogsCollectionView!.addSubview(refresher)
        
        
        self.title = "Mobdev"
        
        self.loadData()
        
    }
    
    func subDogsCollectionCells(){
        
        dogsCollectionView.register(UINib(nibName: "DogsCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "DogsCollectionViewCell")
        dogsCollectionViewFlowLayout.itemSize = CGSize(width: HomeViewController.sectionWidth! , height: HomeViewController.sectionWidth! )
        dogsCollectionViewFlowLayout.minimumLineSpacing = 16
        dogsCollectionViewFlowLayout.minimumInteritemSpacing = 0
        
        dogsCollectionView.delegate = self
        dogsCollectionView.dataSource = self
        
    }
    
    @objc func loadData(){
        
        self.view.showBlurLoader()
        
        let handler: (([Breed]?) -> Void) = { (breeds) in
            
            self.refresher.endRefreshing()
            self.view.removeBluerLoader()
            
            if breeds != nil {
                self.breedArray = breeds!
                self.dogsCollectionView.reloadData()
            }else{
                let alertController = UIAlertController(title: nil, message: "Error de conexión", preferredStyle: .alert)
                
                // Create OK button
                let reloadAction = UIAlertAction(title: "Recargar", style: .default) { (action:UIAlertAction!) in
                    self.loadData()
                }
                alertController.addAction(reloadAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
            
        }
        
        DogsApiManager().getBreeds(handler)
        
    }

}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let breedViewController = BreedViewController()
        
        breedViewController.breed = breedArray[indexPath.row]
        
        self.navigationController?.pushViewController(breedViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogsCollectionViewCell", for: indexPath) as! DogsCollectionViewCell
        
        cell.dogNameLabel.text = breedArray[indexPath.row].name!
        
        
        cell.dogImageView.image = nil
        
        let activityIndicator = UIActivityIndicatorView()
        cell.dogImageView.layer.masksToBounds = true
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.gray
        
        DispatchQueue.main.async {
            activityIndicator.frame = cell.dogImageView.bounds
            cell.dogImageView.addSubview(activityIndicator)
            cell.dogImageView.layer.cornerRadius = cell.dogImageView.frame.size.height / 2
        }
        
        let handler: ((UIImage?,String) -> Void) = { (image,identifier) in
            DispatchQueue.main.async {
                if(image != nil){
                    if(identifier == cell.dogNameLabel.text){
                        cell.dogImageView.image = image
                    }
                }
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
        
        DogsApiManager().getRandomBreedImage(breedArray[indexPath.row].name!, completionHandler: handler)
        
        return cell
    }
    
}
