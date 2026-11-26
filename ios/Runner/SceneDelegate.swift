import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  private var privacyBlurView: UIVisualEffectView?

  override func sceneWillResignActive(_ scene: UIScene) {
    super.sceneWillResignActive(scene)
    attachPrivacyShield(for: scene)
  }

  override func sceneDidEnterBackground(_ scene: UIScene) {
    super.sceneDidEnterBackground(scene)
    attachPrivacyShield(for: scene)
  }

  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    removePrivacyShield()
  }

  private func attachPrivacyShield(for scene: UIScene) {
    guard privacyBlurView == nil,
          let windowScene = scene as? UIWindowScene,
          let window = windowScene.windows.first else {
      return
    }
    let blur = UIVisualEffectView(
      effect: UIBlurEffect(style: .systemUltraThinMaterial)
    )
    blur.frame = window.bounds
    blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    blur.tag = 99420
    window.addSubview(blur)
    privacyBlurView = blur
  }

  private func removePrivacyShield() {
    privacyBlurView?.removeFromSuperview()
    privacyBlurView = nil
  }
}
