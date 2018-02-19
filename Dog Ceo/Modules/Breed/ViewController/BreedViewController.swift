//
//  BreedViewController.swift
//  Dog Ceo
//
//  Created by Samuel on 06-02-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class BreedViewController: UIViewController {

    @IBOutlet weak var subBreedCollectionView: UICollectionView!
    @IBOutlet weak var subBreedCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var subBreedHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var galleryCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var pageIndicatorLabel: UILabel!
    
    var breed : Breed?
    var subBreed : Breed?
    
    var subBreedArray = Array<Breed>()
    var galleryImagesNameArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subBreedCollectionCells()
        self.setGalleryCollectionCells()
        
        if(subBreed == nil){
            self.loadSubBreeds()
            self.title = (breed?.name)!
        }else{
            self.title = (subBreed?.name)!
        }
        self.loadGallery()
        
    }
    
    func loadSubBreeds(){
        
        let handler: (([Breed]?) -> Void) = { (breeds) in
            
            if breeds != nil {
                self.subBreedArray = breeds!
                self.subBreedCollectionView.reloadData()
            }else{
                let alertController = UIAlertController(title: nil, message: "Error de conexión", preferredStyle: .alert)
                
                // Create OK button
                let reloadAction = UIAlertAction(title: "Recargar", style: .default) { (action:UIAlertAction!) in
                    self.loadSubBreeds()
                }
                alertController.addAction(reloadAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
            
        }
        
        DogsApiManager().getSubBreeds((breed?.name)!,completionHandler: handler)
    }
    
    func loadGallery(){
        
        self.view.showBlurLoader()
        
        let handler: (([String]?) -> Void) = { (images) in
            
            self.view.removeBluerLoader()
            
            if images != nil {
                self.galleryImagesNameArray = images!
                self.pageIndicatorLabel.text = "1 / \((images?.count)! + 1)"
                self.galleryCollectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.galleryCollectionView.flashScrollIndicators()
                })
            }else{
                let alertController = UIAlertController(title: nil, message: "Error de conexión", preferredStyle: .alert)
                
                // Create OK button
                let reloadAction = UIAlertAction(title: "Recargar", style: .default) { (action:UIAlertAction!) in
                    self.loadGallery()
                }
                alertController.addAction(reloadAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
            
        }
        
        if(subBreed != nil){
            DogsApiManager().getImagesSubBreeds((breed?.name)!,subBreedName: (subBreed?.name)!,completionHandler: handler)
        }else{
            DogsApiManager().getImagesBreeds((breed?.name)!,completionHandler: handler)
        }
        
    }
    
    func subBreedCollectionCells(){
        
        subBreedCollectionView.register(UINib(nibName: "DogsCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "DogsCollectionViewCell")
        subBreedCollectionViewFlowLayout.itemSize = CGSize(width: HomeViewController.sectionWidth! , height: HomeViewController.sectionWidth! )
        
        subBreedCollectionView.delegate = self
        subBreedCollectionView.dataSource = self
        
    }
    
    func setGalleryCollectionCells(){
        self.galleryCollectionView.isPagingEnabled = true
        
        galleryCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
    }
    
    
    override public func viewDidLayoutSubviews() {
        self.galleryCollectionViewFlowLayout.minimumInteritemSpacing = 10
        self.galleryCollectionViewFlowLayout.minimumLineSpacing = 0
        self.galleryCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.galleryCollectionViewFlowLayout.itemSize = CGSize(width: galleryCollectionView.frame.size.width, height: galleryCollectionView.frame.size.height)
        self.galleryCollectionViewFlowLayout.scrollDirection = .horizontal
        
//        debugPrint(galleryCollectionView.frame.size)
        
        self.subBreedCollectionViewFlowLayout.minimumInteritemSpacing = 8
        self.subBreedCollectionViewFlowLayout.minimumLineSpacing = 8
        self.subBreedCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        self.subBreedCollectionViewFlowLayout.scrollDirection = .horizontal
        
        self.updateViewConstraints()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let currentPage = self.galleryCollectionView.contentOffset.x / self.galleryCollectionView.frame.size.width
        
        self.galleryCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.galleryCollectionView.setContentOffset(CGPoint(x:  currentPage * self.galleryCollectionView.bounds.size.width , y: 0), animated: false)
            let currentPage = self.galleryCollectionView.contentOffset.x / self.galleryCollectionView.frame.size.width
            
            self.pageIndicatorLabel.text = "\(Int(currentPage + 1)) / \(self.galleryImagesNameArray.count + 1)"
        }
    }

}


extension BreedViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == subBreedCollectionView){
            let breedViewController = BreedViewController()
            
            breedViewController.breed = self.breed
            breedViewController.subBreed = subBreedArray[indexPath.row]
            
            self.navigationController?.pushViewController(breedViewController, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == subBreedCollectionView){
            if subBreedArray.count == 0{
                subBreedHeightConstraint.constant = 0
            }else{
                subBreedHeightConstraint.constant = HomeViewController.sectionWidth! + 20
            }
            return subBreedArray.count
        }
        
        return galleryImagesNameArray.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = self.galleryCollectionView.contentOffset.x / self.galleryCollectionView.frame.size.width
        
        self.pageIndicatorLabel.text = "\(Int(currentPage + 1)) / \(galleryImagesNameArray.count + 1)"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == galleryCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
            
            cell.dogImageView.image = nil
            cell.dogBackgroundImage.image = nil
            
            cell.dogImageEndpoint = galleryImagesNameArray[indexPath.row]
            
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = galleryCollectionView.bounds
            cell.dogImageView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            activityIndicator.color = UIColor.gray
            
            let handler: ((UIImage?,String) -> Void) = { (image,identifier) in
                DispatchQueue.main.async {
                    if(image != nil){
                        if(identifier == cell.dogImageEndpoint){
                            cell.dogImageView.image = image
                            cell.dogBackgroundImage.image = image
                        }
                    }
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
            }
            
            DogsApiManager().retrieveImage(endpoint: galleryImagesNameArray[indexPath.row], identifier: galleryImagesNameArray[indexPath.row], completionHandler: handler)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogsCollectionViewCell", for: indexPath) as! DogsCollectionViewCell
        
        cell.dogNameLabel.text = subBreedArray[indexPath.row].name!
        
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

        DogsApiManager().getRandomSubBreedImage(subBreedArray[indexPath.row].name!, breed: (breed?.name)!, completionHandler: handler)
        
        return cell
    }
    
}
