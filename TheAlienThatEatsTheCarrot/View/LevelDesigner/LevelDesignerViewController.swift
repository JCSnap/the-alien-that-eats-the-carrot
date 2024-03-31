//
//  LevelDesignerViewController.swift
//  TheAlienThatEatsTheCarrot
//
//  Created by zhing on 16/3/24.
//

import UIKit

class LevelDesignerViewController: UIViewController {

    @IBOutlet private var terrainsButton: UIButton!
    @IBOutlet private var enemiesButton: UIButton!
    @IBOutlet private var powerupsButton: UIButton!
    @IBOutlet private var collectiblesButton: UIButton!

    @IBOutlet private var terrainsContainerView: UIView!
    @IBOutlet private var enemiesContainerView: UIView!
    @IBOutlet private var powerupsContainerView: UIView!
    @IBOutlet private var collectiblesContainerView: UIView!
    private var componentSelected: ObjectType = .block(.normal)

    @IBOutlet private var boardAreaView: UIView!
    private var imageViews: [ObjectIdentifier: RectangularImageView] = [:]
    var levelDesigner: LevelDesigner! // controller

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContainerViews()
        setUpGestures()
    }

    private func setUpContainerViews() {
        hideAllContainers()
        showContainerView(terrainsContainerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // initialise level desinger based on boardAreaView
        let frame = boardAreaView.frame
        let origin = CGPoint(x: 0, y: 0)
        let size = CGSize(width: frame.maxX - frame.minX, height: frame.maxY - frame.minY)
        let area = CGRect(origin: origin, size: size)
        if levelDesigner == nil {
            self.levelDesigner = LevelDesigner(area: area, view: self)
        }

        print("area bottom: \(frame.minY), top: \(frame.maxY), left: \(frame.minX), right: \(frame.maxX). rect area = \(area)")
    }

    // MARK: - set up tab bars
    /// Set up container view's view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TerrainsViewSegue" {
            if let terrainsViewController = segue.destination as? TerrainsViewController {
                terrainsViewController.delegate = self
            }
        }
        if segue.identifier == "EnemiesViewSegue" {
            if let enemiesViewController = segue.destination as? EnemiesViewController {
                enemiesViewController.delegate = self
            }
        }
        if segue.identifier == "PowerupsViewSegue" {
            if let powerupsViewController = segue.destination as? PowerupsViewController {
                powerupsViewController.delegate = self
            }
        }
        if segue.identifier == "CollectiblesViewSegue" {
            if let collectivlesViewController = segue.destination as? CollectiblesViewController {
                collectivlesViewController.delegate = self
            }
        }
        if segue.identifier == "SaveLevelSegue",
           let destination = segue.destination as? SaveLevelViewController {
            destination.delegate = self
        }
//        if segue.identifier == "LoadLevelSegue",
//           let destination = segue.destination as? LoadLevelViewController {
//            destination.delegate = self
//        }
//        if segue.identifier == "TestGameSegue",
//           let gameViewController = segue.destination as? GameViewController {
//            gameViewController.level = levelDesigner.level
//        }
    }

    private func hideAllContainers() {
        terrainsContainerView.isHidden = true
        enemiesContainerView.isHidden = true
        powerupsContainerView.isHidden = true
        collectiblesContainerView.isHidden = true
    }

    private func showContainerView(_ containerView: UIView) {
       hideAllContainers()
       containerView.isHidden = false
    }

    @IBAction private func terrainsButtonTapped(_ sender: UIButton) {
       showContainerView(terrainsContainerView)
    }

    @IBAction private func enemiesButtonTapped(_ sender: UIButton) {
       showContainerView(enemiesContainerView)
    }

    @IBAction private func powerupsButtonTapped(_ sender: UIButton) {
       showContainerView(powerupsContainerView)
    }

    @IBAction private func collectiblesButtonTapped(_ sender: UIButton) {
       showContainerView(collectiblesContainerView)
    }

    // MARK: - user interactions
    private func setUpGestures() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBoardTap(_:)))
        boardAreaView.addGestureRecognizer(singleTapGesture)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleBoardLongPress(_:)))
        boardAreaView.addGestureRecognizer(longPressGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBoardPan(_:)))
        boardAreaView.addGestureRecognizer(panGesture)
    }

    /// handle tap action in the board area
    @objc func handleBoardTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: boardAreaView)
        levelDesigner.handleTap(at: tapLocation, objectType: componentSelected)
    }

    /// handle long press action in the board area
    @objc func handleBoardLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: boardAreaView)
            print("long press at \(location)")
            levelDesigner.handleLongPress(at: location)
        }
    }

    /// handle pan action in the board area
    @objc func handleBoardPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("pan began")
            let touchPoint = gesture.location(in: boardAreaView)
            levelDesigner.handlePanStart(at: touchPoint)
        case .changed:
            print("pan change")
            let touchPoint = gesture.location(in: boardAreaView)
            levelDesigner.handlePanChange(at: touchPoint)
        default:
            print("pan end")
            levelDesigner.handlePanEnd()
        }
    }

    // MARK: - image handling
    func addImage(id: ObjectIdentifier, objectType: ObjectType, center: CGPoint, width: CGFloat, height: CGFloat) {
        print("image added at \(center) for \(id)")
        let imageView = RectangularImageView(objectType: objectType, center: center, width: width, height: height)
        imageViews[id] = imageView
        boardAreaView.addSubview(imageView.imageView)
    }

    func removeImage(id: ObjectIdentifier) {
        print("image removed for \(id)")
        guard let removedImageView = imageViews.removeValue(forKey: id) else {
            return
        }
        removedImageView.imageView.removeFromSuperview()
        removedImageView.imageView = nil
    }
    
    

    // MARK: - other feature buttons
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func reset() {
        for imageView in imageViews.values {
            imageView.imageView.removeFromSuperview()
            imageView.imageView = nil
        }
        imageViews.removeAll()
    }
    
}

extension LevelDesignerViewController: ComponentSelectDelegate {
    func buttonTapped(type: ObjectType) {
        componentSelected = type
        print("Type selecteed: \(type)")
    }
}

extension LevelDesignerViewController: SaveLevelViewControllerDelegate {
    func saveLevel(levelName: String, overwrite: Bool) throws {
        try levelDesigner.saveLevel(levelName: levelName, overwrite: overwrite)
    }
}
