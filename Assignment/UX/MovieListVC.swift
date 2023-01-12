//
//  MovieListVC.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/5/23.
//


import UIKit
import SDWebImage
import Alamofire

class MovieListVC: UIViewController {

    let AF = Alamofire.SessionManager()
    let ms = MovieService()
    let screenSize: CGRect = UIScreen.main.bounds
    var movieList: MoviesApiResponse?
    @IBOutlet weak var sbMovieList: UISearchBar!
    @IBOutlet weak var cvMovieList: UICollectionView!{
        didSet{
            cvMovieList.delegate = self
            cvMovieList.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvMovieList.register(UINib.init(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MOVIECELL")
        getPopularMovies()
    }
    fileprivate func getPopularMovies() {
        
//        let s = "https://api.themoviedb.org/3/movie/popular?api_key=e5ea3092880f4f3c25fbc537e9b37dc1"
//
//        AF.request(s).responseJSON { response in
//            debugPrint(response)
//        }
        
        PaceProgressHUD.addProgressHUDToTop()
        ms.getPopularMoviesList(){
            [weak self] (response) in
            PaceProgressHUD.hideProgressHUDFromTop()
            switch response {
            case .success(let movieResponse):
                if movieResponse != nil {
                    guard let self = self else{
                        return
                    }
                    self.movieList = movieResponse
                    self.cvMovieList.reloadData()
                }
                else{
                    fatalError("No Data Found")
                }
                break
            case .failure(let failureResponse):
                fatalError(failureResponse.localizedDescription)
                break
            }
        }
      }

}
extension MovieListVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let size = ((collectionView.frame.width - 20) / 2)
       print("cell width : \(size)")
       return CGSize(width: size, height: size)
   }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20 // Keep whatever fits for you
      }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension MovieListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 //movieList?.results?.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvMovieList.dequeueReusableCell(withReuseIdentifier: "MOVIECELL", for: indexPath) as! MovieCell
        
//        let obj = movieList?.results[indexPath.row]
//        cell.lblName.text = obj?.title
//        cell.lblDate.text = obj?.releaseDate
//        let imagePath = C.BaseURL.imagPathURL + (obj?.posterPath)!
//        let imageURL = URL(string: imagePath)
//        cell.imgPoster.sd_setImage(with: imageURL)
        
        
        return cell
    }
    
}
