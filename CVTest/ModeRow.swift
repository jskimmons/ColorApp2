//
//  ModeRow.swift
//  CVTest
//
//  Created by Joseph Skimmons on 8/24/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

import UIKit

class ModeRow: UICollectionViewCell {
}

extension ModeRow : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "modeCell", for: indexPath as IndexPath) as! UICollectionViewCell
        return cell
    }
}

extension ModeRow : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let hardCodedPadding:CGFloat = 5
        let itemWidth = collectionView.bounds.width  - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
