//
//  PhotosViewController.swift
//  Photorama
//
//  Created by CSUFTitan on 4/20/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    
    //To make a request, PhotosViewController will call the appropriate methods on PhotoStore. To do this, PhotosViewController needs a reference to an instance of PhotoStore.

    //At the top of PhotosViewController.swift, add a property to hang on to an instance of PhotoStore.
    var store: PhotoStore!//The store is a dependency of the PhotosViewController. You will use property injection to give the PhotosViewController its store dependency, just as you did with the view controllers in Homepwner.
    
    let photoDataSource = PhotoDataSource()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        
        collectionView.delegate = self
        
        updateDataSource()


        store.fetchInterestingPhotos {
            (photosResult) -> Void in

            self.updateDataSource()
            

        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        let photo = photoDataSource.photos[indexPath.row]

        // Download the image data, which could take some time
        store.fetchImage(for: photo) { (result) -> Void in

            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most
            // recent index path

            // (Note: You will have an error on the next line; you will fix it soon)
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)

            // When the request finishes, only update the cell if it's still visible
            if let cell = self.collectionView.cellForItem(at: photoIndexPath)
                                                         as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath =
                    collectionView.indexPathsForSelectedItems?.first {

                let photo = photoDataSource.photos[selectedIndexPath.row]

                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    private func updateDataSource() {
        store.fetchAllPhotos {
            (photosResult) in

            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
}
