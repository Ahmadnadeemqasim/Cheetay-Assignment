//
//  MoviesSearchVC.swift
//  Assignment
//
//  Created by Devin Ellis  on 1/13/23.
//


import UIKit
import SDWebImage
import Alamofire
import CoreData

class MoviesSearchVC: UIViewController {
  

    let AF = Alamofire.SessionManager()
    let ms = MovieService()
    var request = SearchMovieByNameApiRequest()
    let screenSize: CGRect = UIScreen.main.bounds
    var movieList: MoviesApiResponse?
    var mdUtility: MovieCoreDataUtility?
    
    

    @IBOutlet weak var sbMovieList: UISearchBar!{
        didSet{
            sbMovieList.delegate = self
        }
    }
    @IBOutlet weak var cvMovieList: UICollectionView!{
        didSet{
            cvMovieList.delegate = self
            cvMovieList.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvMovieList.register(UINib.init(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MOVIECELL")
    }
    fileprivate func getmoviesList() {
        
        PaceProgressHUD.addProgressHUDToTop()
        ms.getSearchedMoviesList(request: request){
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
extension MoviesSearchVC : MovieDelegate {
    func btnFavouritClicked(sender: UIButton) {
        
        let favoriteMovie =  movieList?.results[sender.tag]
        if let md = mdUtility {
            md.saveFavoriteMovie(movieObj: favoriteMovie)
        }
    }
}
extension MoviesSearchVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let size = ((collectionView.frame.width - 20) / 2)
       return CGSize(width: size, height: size*2)
   }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20 // Keep whatever fits for you
      }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension MoviesSearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvMovieList.dequeueReusableCell(withReuseIdentifier: "MOVIECELL", for: indexPath) as! MovieCell
    
        let obj = movieList?.results[indexPath.row]
        let imagePath = C.BaseURL.imagPathURL + (obj?.posterPath)!
        let imageURL = URL(string: imagePath)
        
        cell.delegate = self
        cell.btnFavourite.tag = indexPath.row
        cell.lblName.text = obj?.title
        cell.lblDate.text = obj?.releaseDate
        cell.imgPoster.sd_setImage(with: imageURL)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedMovie = movieList?.results[indexPath.row]
        self.moveToNextVC(movieDetail: clickedMovie!)
    }
    func moveToNextVC(movieDetail:MovieDetail){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MOVIEDETAIL")  as! MovieDetailVC
        
        vc.modalPresentationStyle = .fullScreen
        vc.mvDetail = movieDetail
        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MoviesSearchVC : UISearchTextFieldDelegate, UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        request.movieName =  searchBar.text
        self.getmoviesList()
    }
}
