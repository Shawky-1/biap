//
//  Walkthrough.swift
//  Biap
//
//  Created by Bassant on 11/03/2023.
//

import UIKit

class Walkthrough: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    
    var slides: [WalkthroughSlide] = []
    var currentPage = 0{
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == slides.count-1{
                nextBtn.setTitle("Get Started", for: .normal)
            }else{
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "WalkthroughCell", bundle: nil), forCellWithReuseIdentifier: "WalkthroughCell")
        
        slides = [WalkthroughSlide(title: "Purchase Online", description: "Discover various types of products and shop your favorite brands", image: UIImage(named: "slide1")!),
                  WalkthroughSlide(title: "Add to cart", description: "Add your desired products to cart and place your order", image: UIImage(named: "slide2")!),
                  WalkthroughSlide(title: "Quick Delivery", description: "Have everything delivered to your doorstep instantly", image: UIImage(named: "slide3")!)]
    }


    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if currentPage == slides.count-1{
            UserDefaults.standard.set(true, forKey: "WalkthroughCompleted")
            let login = LoginVC(nibName: "LoginVC", bundle: nil)
            self.navigationController?.pushViewController(login, animated: true)
            
        }else{
            collectionView.isPagingEnabled = false
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
        }
    }
    
    
    @IBAction func skip(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "WalkthroughCompleted")
        let login = LoginVC(nibName: "LoginVC", bundle: nil)
        self.navigationController?.pushViewController(login, animated: true)
    }
    
}


extension Walkthrough: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkthroughCell", for: indexPath) as! WalkthroughCell
        cell.setup(slide: slides[indexPath.row])
        
        return cell
    }
}

extension Walkthrough:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}
