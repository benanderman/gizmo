//
//  EmojiAnimator.swift
//  Gizmo
//
//  Created by Ben Anderman on 8/31/17.
//  Copyright © 2017 Jello Labs, Inc. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

protocol EmojiAnimator {
  var view: UIView! { get }
}

extension EmojiAnimator {
  func makeScene() -> SKScene {
    let size = CGSize(width: view.frame.width, height: view.frame.height)
    let scene = SKScene(size: size)
    scene.backgroundColor = .clear
    return scene
  }
  
  func addEmoji(_ emoji: Character, to scene: SKScene) -> SKLabelNode {
    let node = SKLabelNode()
    node.renderEmoji(emoji)
    node.position.y = floor(scene.size.height / 2)
    node.position.x = floor(scene.size.width / 2)
    scene.addChild(node)
    return node
  }
}

extension SKLabelNode {
  func renderEmoji(_ emoji: Character) {
    fontSize = 50
    text = String(emoji)
    
    // This enables us to move the label using its center point
    verticalAlignmentMode = .center
    horizontalAlignmentMode = .center
  }
}
