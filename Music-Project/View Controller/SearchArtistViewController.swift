//
//  SearchArtistViewController.swift
//  Music-Project
//
//  Created by Ata Doruk on 13.01.2021.
//

import UIKit

class SearchArtistViewController: UIViewController {
    
    @IBOutlet weak var artistSearchBar: UISearchBar!
    @IBOutlet weak var artistsTableView: UITableView!
    
    let viewModel = ArtistSearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistSearchBar.delegate = self
        artistsTableView.delegate = self
        artistsTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueIdentifiers.artistDetail, let artist = sender as? ArtistSearch, let artistAlbumsVC = segue.destination as? ArtistAlbumsViewController else { return }
        
        artistAlbumsVC.artist = artist
    }

}

// MARK: - UISearchBarDelegate

extension SearchArtistViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let artistName = searchBar.text?.lowercased() ?? ""
        
        if artistName.isEmpty { return }
        
        viewModel.searchArtists(withName: artistName) { [unowned self] (_) in
            DispatchQueue.main.async {
                self.artistsTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchArtistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let artist = viewModel.artists[indexPath.row]
        performSegue(withIdentifier: SegueIdentifiers.artistDetail, sender: artist)
    }
}

// MARK: - UITableViewDataSource

extension SearchArtistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artistCell = tableView.dequeueReusableCell(withIdentifier: "ArtistSearchCell", for: indexPath)
        
        let artist = viewModel.artists[indexPath.row]
        
        artistCell.textLabel?.text = artist.name
        artistCell.textLabel?.font = .boldSystemFont(ofSize: 17)
        if let genre = artist.genre {
            artistCell.detailTextLabel?.text = genre
            artistCell.detailTextLabel?.font = .systemFont(ofSize: 14)
        } else {
            artistCell.detailTextLabel?.isHidden = true
        }
        
        return artistCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}
