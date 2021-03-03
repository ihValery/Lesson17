import UIKit

class PostsTableViewController: UITableViewController {

    var user: User!
    var posts: [Post] = []
    
    override func viewWillAppear(_ animated: Bool) {
        getPosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showComments",
            let postId = sender as? Int,
            let commentsVC = segue.destination as? CommentsTableViewController {
            commentsVC.postId = postId
        }
    }
    
    private func getPosts() {
        
        guard let userId = user.id else { return }
        
        let pathUrl = "https://jsonplaceholder.typicode.com/posts?userId=\(userId)"

        guard let url = URL(string: pathUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                self.posts = try JSONDecoder().decode([Post].self, from: data)
            } catch let error {
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = posts[indexPath.row].title
        cell.detailTextLabel?.text = posts[indexPath.row].body
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        switch indexPath.row.isMultiple(of: 2) {
            case false:
                cell.contentView.backgroundColor = .systemGray6
            default:
                cell.contentView.backgroundColor = .white
        }
        return cell
    }
    
    // MARK: - Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = posts[indexPath.row].id
        performSegue(withIdentifier: "showComments", sender: postId)
    }
}
