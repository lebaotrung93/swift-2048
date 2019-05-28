//
//  RetryViewController.swift
//  swift-2048
//
//  Created by Luck on 2/27/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//
import UIKit
import GameKit




class RetryViewController: UIViewController {
    var model : RetryViewModel!
    var onRetry:(()->())?
    var onHideAd:(()->())?
    var onShowAd:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        model.loadScore()
        saveScore()
        IronSource.setRewardedVideoDelegate(self)
    }
    
    
    
    func saveScore() {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: "2048.luck.best.player")
        bestScoreInt.value = Int64(model.score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    @IBAction func playAgainClicked(_ sender: Any) {
        IronSource.showRewardedVideo(with: self, placement: "DefaultRewardedVideo")
        
        
    }
    
    @IBAction func ShareCliccked(_ sender: Any) {
        model.onShareClick?()
    }
    
    func captureImage() -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage

    }
    
    
    
    func bindData() {
        
        model.onRetryClick = { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.onRetry?()
            })
        }
        
        model.onShareClick = { [weak self] in
            self?.onHideAd?()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15, execute: {
                guard let wSelf = self else { return }
                let text = "My score is : \(wSelf.model.score). I challenge you to play better than me. Visit ... to play"
                
                // set up activity view controller
                let textToShare = [ text, wSelf.captureImage() ] as [Any]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self?.view
                activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.mail, UIActivityType.message, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo, UIActivityType.postToWeibo, UIActivityType.postToTwitter,
                                                                 UIActivityType.saveToCameraRoll]
                
                // present the view controller
                self?.present(activityViewController, animated: true, completion: {
                    self?.onShowAd?()
                })
            })
        }
        
    }

}

class RetryViewModel {
    var score : Int
    var onScoreChange:((String)->())?
    var onShareClick:(()->())?
    var onRetryClick:(()->())?
    
    init(score : Int) {
        self.score = score
    }
    
    func loadScore() {
    }
    
}


extension RetryViewController : ISRewardedVideoDelegate {
    func rewardedVideoHasChangedAvailability(_ available: Bool) {
        
    }
    
    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {
        
    }
    
    func rewardedVideoDidFailToShowWithError(_ error: Error!) {
        model.onRetryClick?()
    }
    
    func rewardedVideoDidOpen() {
        
    }
    
    func rewardedVideoDidClose() {
        model.onRetryClick?()
    }
    
    func rewardedVideoDidStart() {
        
    }
    
    func rewardedVideoDidEnd() {
        model.onRetryClick?()
    }
    
    func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {
        
    }
    
    
}
