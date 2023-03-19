//
//  FeatureViewController.swift
//  Research-App
//
//  Created by Levi Harris on 2/25/23.
//

import UIKit
import SwiftUI
import FirebaseAuthUI
import FirebaseCore
import FirebaseFirestore

class FeatureViewController: UIViewController {
    
    // TODO: Batch profile loading.
        // On inital load
    
    // Scroll profile description.
    @IBOutlet weak var profileDescriptionScrollView: UIScrollView!
    
    // Height of profile description scroll view.
    @IBOutlet weak var profileDescriptionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftImageArea: UIView!
    @IBOutlet weak var draggableArea: UIView!
    @IBOutlet weak var rightImageArea: UIView!
    
    // Show more button.
    @IBOutlet weak var showMoreButton: UIButton!
    
    // Hide description.
    @IBOutlet weak var hideDescriptionButton: UIButton!
    
    // Container.
    @IBOutlet weak var contentView: UIView!
    
    // Profiles.
    @IBOutlet weak var topProfile: UIView!
    @IBOutlet weak var bottomProfile: UIView!
    
    // Bio scroll view.
    @IBOutlet weak var bioScrollView: UIScrollView!
    
    // Bio is / is not visible.
    private var scrollViewHeightVisable: NSLayoutConstraint? = nil
    private var scrollViewHeightInvisible: NSLayoutConstraint? = nil
    
    // Var to enable/disable dragging animations of top profile view..
    private var isDragging: Bool = false
    
    // Profile swiping disabled on description display.
    private var swipingIsEnabled: Bool = true
    
    // All profiles viewed in a session.
    private var seenProfiles: [String] = []
    
    // Images assoicated w/ a profile.
    private var topProfilesImages: [UIImage] = []
    
    // Profile animation constants.
    var profileBounds: CGRect? = nil
    
    var startingX: CGFloat = 0.0
    var startingY: CGFloat = 0.0

    var relativeX: CGFloat = 0
    var relativeY: CGFloat = 0
    
    var maxHeight: CGFloat = 0.0
    var minHeight: CGFloat = 0.0
    
    var maxWidth: CGFloat = 0.0
    var minWidth: CGFloat = 0.0
    
    var deltaX: CGFloat = 0.0
    var deltaY: CGFloat = 0.0
    
    var screenWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.15, delay: 0.0, animations: {
            self.initializeVariables()
        })
        
        loadProfileBatch()
    }
    
    // Load a new batch of profiles from database.
    private func loadProfileBatch(){
        
        let currentUser = Auth.auth().currentUser
        if (currentUser == nil) {return} // Error.
        let email = currentUser!.email!
        var currentUserProfile: (Any)? = nil
        
        // Create a reference to user-profile.
        let db = Firestore.firestore()
        let ref = db.collection("users").document("user-profiles")
        
        // Get current user profile.
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                currentUserProfile = document.data()![email]
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Initalize vars and constants.
    private func initializeVariables() {
        
        // Initalize bio height constraints.
        scrollViewHeightVisable = profileDescriptionHeightConstraint
        scrollViewHeightInvisible = profileDescriptionHeightConstraint.constraintWithMultiplier(0.0)
        
        // Set bio to a default height of "invisible".
        profileDescriptionScrollView.removeConstraint(profileDescriptionHeightConstraint!)
        profileDescriptionScrollView.addConstraint(scrollViewHeightInvisible!)
        view.layoutIfNeeded()
        
        // Initalize a var equal to default bounds of the visible profile.
        profileBounds = topProfile.bounds
        
        // Interaction w/ bottom profile disabled by default.
        bottomProfile.isUserInteractionEnabled = false
        
        topProfile.layer.cornerRadius = 30
        bottomProfile.layer.cornerRadius = 30
        
        // Set max height and width of visible profile view.
        maxHeight = topProfile.frame.origin.y + 30
        minHeight = topProfile.frame.origin.y - 20
        
        maxWidth = topProfile.frame.midX + 100.00
        minWidth = topProfile.frame.midX - 100.00
        
        // Set starting coords for animating profile view on user touch-drag.
        startingX = topProfile.frame.origin.x
        startingY = topProfile.frame.origin.y
        
        // Initalize a var equal to total screen width.
        screenWidth = view.bounds.width
        
        // Set a thin border around buser bios/
        profileDescriptionScrollView.layer.borderWidth = 1
        profileDescriptionScrollView.layer.borderColor = UIColor.darkGray.cgColor
        
        // Hide bio button is invisble and disabled by default.
        hideDescriptionButton.alpha = 0.0
        hideDescriptionButton.isUserInteractionEnabled = false
        
        // Load new profiles from batch of profiles.
        loadNewProfileView()
    }
    
    // MARK: Loads a new profile from profile batch.
    private func loadNewProfileView() -> UIView {
        var profile: UIView = topProfile
        return profile
    }
    
    // MARK: Swap top and bottom profiles, load a new profile.
    func swapProfiles () {
        return
    }
    
    // Set origin of the visible profile view.
    func setOrigin(x: CGFloat, y: CGFloat) {
        topProfile.frame.origin.x = x
        topProfile.frame.origin.y = y
    }
    
    // Return profile to center of screen.
    func returnToCenter() {
        
        let distanceX: CGFloat = CGFloat(startingX) - topProfile.frame.origin.x
        let distanceY: CGFloat = CGFloat(startingY) - topProfile.frame.origin.y
        
        UIView.animate(withDuration: 0.15, delay: 0.0, animations: {
            self.topProfile.frame.origin.x = CGFloat(self.startingX)
            self.topProfile.frame.origin.y = CGFloat(self.startingY)
        })
    }
    
    // MARK: Make profile description visible with animation.
    @IBAction func showMorePressed(_ sender: Any) {
        swipingIsEnabled = false
        profileDescriptionScrollView.removeConstraint(scrollViewHeightInvisible!)
        profileDescriptionScrollView.addConstraint(scrollViewHeightVisable!)
        UIView.animate(withDuration: 0.15, delay: 0.0, animations: {
            self.view.layoutIfNeeded()
            self.showMoreButton.alpha = 0.0
            self.showMoreButton.isUserInteractionEnabled = false
            self.hideDescriptionButton.alpha = 1.0
            self.hideDescriptionButton.isUserInteractionEnabled = true
        })
    }

    // Hide profile description.
    @IBAction func hideDescriptionPressed(_ sender: Any) {
        print("pressed")
        swipingIsEnabled = true
        profileDescriptionScrollView.removeConstraint(scrollViewHeightVisable!)
        profileDescriptionScrollView.addConstraint(scrollViewHeightInvisible!)
        UIView.animate(withDuration: 0.15, delay: 0.0, animations: {
            self.view.layoutIfNeeded()
            self.showMoreButton.alpha = 1.0
            self.showMoreButton.isUserInteractionEnabled = true
            self.hideDescriptionButton.alpha = 0.0
            self.hideDescriptionButton.isUserInteractionEnabled = false
        })
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

// TODO: Redo Navigatiomn
extension FeatureViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !(swipingIsEnabled) {return}
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: view)
        let absoluteLocation = touch.location(in: view)
        
        // Set relative coords.
        relativeX = absoluteLocation.x
        relativeY = absoluteLocation.y
        
        print(location)
        
        if (topProfile.bounds.contains(location)) {
            if (leftImageArea.bounds.contains(location)){
                print("Display previous image.")
            }
            else if (rightImageArea.bounds.contains(location)) {
                print("Display next image.")
            }
            else{
                print("Dragging.")
                isDragging = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !(swipingIsEnabled) {return}
        
        // Prev coords.
        let prevX = topProfile.frame.origin.x
        let prevY = topProfile.frame.origin.y
        
        guard isDragging, let touch = touches.first else {
            return
        }
        
        // Location.
        let location = touch.location(in: view)
        
        // Set new X.
        topProfile.frame.origin.x += location.x - CGFloat(relativeX)
        
        let candidateHeight: CGFloat = topProfile.frame.origin.y + location.y - relativeY
        
        // Set new Y.
        if (candidateHeight > maxHeight) {
            topProfile.frame.origin.y = maxHeight
        }
        else if (candidateHeight < minHeight) {
            topProfile.frame.origin.y = minHeight
        }
        else {
            topProfile.frame.origin.y = candidateHeight
        }
        
        // New coords.
        let newX = topProfile.frame.origin.x
        let newY = topProfile.frame.origin.y
        
        // Set deltas.
        deltaX = newX - prevX
        deltaY = newY - prevY
        
        // Set relative coords.
        relativeX = location.x
        relativeY = location.y
        
        let distance = abs(view.frame.midX - topProfile.frame.midX) // Calculate distance from origin.
        let ratio = distance / (screenWidth / 2) // % moved towards a horizontal edge.
        
        // topProfile.alpha = 1 - ( CGFloat(ratio) * (1 / 2)  )
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !(swipingIsEnabled) {return}
        
        // TODO: Single Tap Gesture Recognizer
            // Change picture.
            // If a touch begins and ends on the same coordinate, it is considered a tap.
        
        // TODO: Double Tap Gesture Recognizer
            // Like animation and prompt.
            // On touch begins,
        
        // Calculate velocity of swipe.
        let velocityX: CGFloat = deltaX
        let velocityY: CGFloat = deltaY
        let directionIndependentVelocity: CGFloat = hypot(velocityX, velocityY)
        
        let distanceToMaxEdge = self.topProfile.bounds.maxX
        let distanceToMinEdge = self.maxWidth - self.topProfile.bounds.minX
        
        // print(directionIndependentVelocity)

        // MARK: Dismiss
        if (topProfile.frame.midX < minWidth || topProfile.frame.midX > maxWidth) {
            
            if (directionIndependentVelocity > 2.5) {
                // print("Swipe out")
                
                // Swipe out left / right
                if (velocityX < 0) {
                    // Swipe right
                    UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                        self.topProfile.frame.origin.x -= distanceToMaxEdge
                    }, completion: {(finished: Bool) in
                        self.swapProfiles()
                        self.topProfile.frame.origin.x = self.startingX
                        self.topProfile.frame.origin.y = self.startingY
                    })
                }
                else {
                    UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                        self.topProfile.frame.origin.x += distanceToMinEdge
                    }, completion: {(finished: Bool) in
                        self.swapProfiles()
                        self.topProfile.frame.origin.x = self.startingX
                        self.topProfile.frame.origin.y = self.startingY
                    })
                }
            }
            else {
                returnToCenter()
            }
        }
        else {
            returnToCenter()
        }
    }
}
    
