//
//  CategorySelectionViewController.swift
//  Api
//
//  Created by Adithya on 29/09/24.
//

import UIKit

class CategorySelectionViewController: UIViewController {

    var categoryArr = [Category]()
    
    private let collectionView: UICollectionView = {
        // Step 1: Define the layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 100) // Set the item size (adjust as needed)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        
        
        // Step 2: Initialize the UICollectionView with the layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Step 3: Register the custom cell
        collectionView.register(CatergoryCollectionViewCell.self, forCellWithReuseIdentifier: CatergoryCollectionViewCell.identifier)
        
        // Step 4: Additional customization (optional)
        collectionView.backgroundColor = .white // Set background color if needed
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        let conversationData1 = Category(title: "Tech", image: (UIImage (named: "category1") ?? UIImage (named: "noPreview"))!)
        let conversationData2 = Category(title: "Tech", image: (UIImage (named: "category2") ?? UIImage (named: "noPreview"))!)
        let conversationData3 = Category(title: "Tech", image: (UIImage (named: "category3") ?? UIImage (named: "noPreview"))!)


        categoryArr.append(conversationData1)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData1)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData3)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData2)
        categoryArr.append(conversationData2)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 20, y: 0, width: view.frame.width - 40, height: view.frame.height)
    }
}


extension CategorySelectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = categoryArr[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatergoryCollectionViewCell.identifier, for: indexPath) as! CatergoryCollectionViewCell
        
        cell.config(with: model)
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//         // Step 3: Calculate the available width for 2 items per row
//         let padding: CGFloat = 10 // Total space between items
//         let collectionViewWidth = collectionView.frame.width
//         let availableWidth = collectionViewWidth - padding * 3 // 2 items, 2 paddings (left, right) and one between them
//         let itemWidth = availableWidth / 2 // Divide by 2 for two items per row
//         return CGSize(width: itemWidth, height: itemWidth) // Use the same height as width to make the cells square
//     
// }

    
}
