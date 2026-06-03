import SwiftUI
import UIKit

struct TabBarIconShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background {
            TabBarShadowAnchorView()
                .allowsHitTesting(false)
        }
    }
}

private struct TabBarShadowAnchorView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        context.coordinator.observeRefresh()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        applyShadow(from: uiView)
    }

    private func applyShadow(from view: UIView) {
        DispatchQueue.main.async {
            guard let tabBar = view.locateTabBar() else { return }
            TabBarShadowRenderer.apply(to: tabBar)
        }
    }

    final class Coordinator {
        private var observer: NSObjectProtocol?

        func observeRefresh() {
            guard observer == nil else { return }
            observer = NotificationCenter.default.addObserver(
                forName: TabBarIconShadowRefresher.notification,
                object: nil,
                queue: .main
            ) { _ in
                guard let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap(\.windows)
                    .first(where: \.isKeyWindow) else { return }
                guard let tabBar = window.locateTabBarInHierarchy() else { return }
                TabBarShadowRenderer.apply(to: tabBar)
            }
        }

        deinit {
            if let observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
}

private extension UIWindow {
    func locateTabBarInHierarchy() -> UITabBar? {
        subviews.compactMap { findTabBar(in: $0) }.first
    }

    private func findTabBar(in view: UIView) -> UITabBar? {
        if let tabBar = view as? UITabBar { return tabBar }
        for subview in view.subviews {
            if let tabBar = findTabBar(in: subview) { return tabBar }
        }
        return nil
    }
}

private enum TabBarShadowRenderer {
    static func apply(to tabBar: UITabBar) {
        tabBar.subviews.forEach { container in
            container.subviews.forEach { subview in
                if let imageView = subview as? UIImageView {
                    imageView.layer.shadowColor = UIColor.black.cgColor
                    imageView.layer.shadowOpacity = 0.95
                    imageView.layer.shadowRadius = 4
                    imageView.layer.shadowOffset = CGSize(width: 0, height: 1)
                    imageView.layer.masksToBounds = false
                }
                if let label = subview as? UILabel {
                    label.layer.shadowColor = UIColor.black.cgColor
                    label.layer.shadowOpacity = 0.95
                    label.layer.shadowRadius = 4
                    label.layer.shadowOffset = CGSize(width: 0, height: 1)
                    label.layer.masksToBounds = false
                }
            }
        }
    }
}

private extension UIView {
    func locateTabBar() -> UITabBar? {
        var current: UIView? = self
        while let view = current {
            if let tabBar = view as? UITabBar { return tabBar }
            if let tabBar = view.superview as? UITabBar { return tabBar }
            current = view.superview
        }
        return nil
    }
}

extension View {
    func tabBarIconShadow() -> some View {
        modifier(TabBarIconShadowModifier())
    }
}
