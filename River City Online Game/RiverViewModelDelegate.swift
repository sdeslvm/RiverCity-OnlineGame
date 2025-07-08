import WebKit
import SwiftUI

protocol RiverViewModelDelegate: AnyObject {
    func riverViewModel(_ model: RiverViewModel, didUpdateState state: RiverState)
}

final class RiverViewModel: ObservableObject {
    @Published private(set) var riverStatus: RiverState = .idle
    let url: URL
    private var webView: WKWebView?
    private(set) weak var delegate: RiverViewModelDelegate?
    private var progressObservation: NSKeyValueObservation?

    init(url: URL) {
        self.url = url
    }

    func bind(delegate: RiverViewModelDelegate) {
        self.delegate = delegate
    }

    func attachWebView(_ webView: WKWebView) {
        self.webView = webView
        webView.navigationDelegate = RiverWebDelegate(owner: self)
        observeProgress(for: webView)
        reload()
    }

    private func observeProgress(for webView: WKWebView) {
        progressObservation?.invalidate()
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            guard let self else { return }
            let prog = webView.estimatedProgress
            self.setState(prog < 1.0 ? .loading(prog) : .completed)
        }
    }

    func reload() {
        guard let webView else { return }
        setState(.loading(0))
        let req = URLRequest(url: url, timeoutInterval: 15)
        webView.load(req)
    }

    func setConnection(isOnline: Bool) {
        if isOnline {
            if riverStatus == .offline {
                reload()
            }
        } else {
            setState(.offline)
        }
    }

    func setState(_ state: RiverState) {
        DispatchQueue.main.async {
            self.riverStatus = state
            self.delegate?.riverViewModel(self, didUpdateState: state)
        }
    }

    private class RiverWebDelegate: NSObject, WKNavigationDelegate {
        weak var owner: RiverViewModel?

        init(owner: RiverViewModel) {
            self.owner = owner
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            owner?.setState(.loading(0.0))
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            owner?.setState(.completed)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            owner?.setState(.failed(error))
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            owner?.setState(.failed(error))
        }

        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {}

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {}
    }
}
