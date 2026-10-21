# Dedicated enrichment data for the 6 gap domains:
# Domain 13: WebKit, WKWebView & Hybrid Native-Web Architecture (topics 1-4)
# Domain 14: Multimedia, AVFoundation, Core Animation & 120Hz Jank (topics 1-4)
# Domain 20: Privacy Manifests (PrivacyInfo.xcprivacy), APIs & ATT (topics 1-4)
# Domain 24: App Extensions (WidgetKit, Share) & Multi-Target Setup (topics 1-4)
# Domain 28: Xcode Build System, .xcconfig & Compiler Optimization (topics 1-4)
# Domain 29: App Flavoring, Multi-Environment Matrix & CI Secrets (topics 1-4)
# Domain 30: App Size Optimization, App Thinning, Slicing & ODR (topics 1-4)

ENRICHED_GAP_TOPICS = {
    # =========================================================================
    # DOMAIN 13: WebKit, WKWebView & Hybrid Native-Web Architecture
    # =========================================================================
    (13, 1): {
        "quick": "WKWebView runs in a multi-process architecture separate from the host app: the WebContent process executes HTML/JS/CSS, and the Networking process handles network requests. If the WebContent process exceeds memory limits, it crashes without terminating the host app.",
        "why": "Understanding out-of-process WebKit execution is critical for preventing blank white screens, handling webProcessDidTerminate crash recovery, and managing cross-process IPC memory budgets.",
        "model": "+---------------------------------------------------+\n| Host App Process (Single Address Space)            |\n|   └── WKWebView Container (View Controller)       |\n|         │ (Mach Message IPC / XPC)                |\n|         ├── WebContent Process (Com.apple.WebKit)  |\n|         │     └── JavaScriptCore V8 / DOM Tree    |\n|         └── Networking Process (URLSession / TLS) |\n+---------------------------------------------------+",
        "minCode": "let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())\nwebView.navigationDelegate = self",
        "prodCode": """import WebKit

public final class ResilientWebViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    private var reloadAttempts = 0
    private let maxCrashRecoveryAttempts = 3

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        view.addSubview(webView)
    }

    // Process termination recovery (Out-of-Memory / JetSam termination)
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        guard reloadAttempts < maxCrashRecoveryAttempts else {
            displayWebFailurePlaceholder()
            return
        }
        reloadAttempts += 1
        webView.reload()
    }

    private func displayWebFailurePlaceholder() {
        // Render native fallback UI when web process repeatedly terminates
    }
}""",
        "hood": "WKWebView communicates with the WebContent and Networking daemons via XPC and Mach ports. When the system faces memory pressure, the iOS Jetsam daemon terminates com.apple.WebKit.WebContent first. WKNavigationDelegate.webViewWebContentProcessDidTerminate is called, leaving a white canvas unless explicitly reloaded.",
        "prodEx": "Checkout funnels, hybrid web apps, customer support chat portals, and legal terms viewers in tier-1 banking/e-commerce apps.",
        "perf": "Out-of-process isolation prevents JavaScript memory leaks and infinite loops from freezing the 120Hz host app UI.",
        "mem": "WebContent process memory does not count directly against host app Dirty Memory, but triggers termination if excessive.",
        "maint": "High resilience; requires implementing navigation lifecycle and crash recovery delegate methods.",
        "test": "Verifiable by calling private kill or memory stress script in WebContent process to trigger termination delegate.",
        "comp": "Requires handling asynchronous cross-process state and cookie synchronization.",
        "bad": "class WebVC: UIViewController, WKNavigationDelegate {\n    // Empty delegate! When memory exceeds threshold, user is left staring at a blank white screen forever!\n}",
        "good": "func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {\n    // Log telemetry to MetricKit & reload cleanly\n    webView.reload()\n}",
        "exp": "Failing to implement webViewWebContentProcessDidTerminate results in permanent blank white screens whenever WebKit runs out of RAM.",
        "trap": "Assuming WKWebView is part of your app's memory address space; pointers cannot be passed directly across the boundary.",
        "jq": "Why does WKWebView run out-of-process in iOS?", "ja": "For security sandboxing and app stability; a malicious script or crash in WebKit will not compromise host app memory or crash the host application.",
        "sq": "How do you detect and recover from a WKWebView process crash caused by high memory pressure?", "sa": "Implement webViewWebContentProcessDidTerminate(_:) on WKNavigationDelegate. When called, inspect retry count, re-initialize state if necessary, and call webView.reload() or render a native fallback error view.",
        "pq": "How does XPC Mach messaging between host app and WebContent impact high-frequency JavaScript bridge events?", "pa": "Each message across the process boundary requires Mach message serialization and context switches. Firing high-frequency scroll or animation events across the bridge causes IPC saturation and UI jank. Batched throttling or shared memory rings are required.",
        "task": "Implement an exponential backoff crash recovery handler for WKWebView process termination.",
        "hint": "Track attempts and dispatch reload with increasing delay.",
        "sol": "func webViewWebContentProcessDidTerminate(_ webView: WKWebView) { guard retries < 3 else { return }; retries += 1; DispatchQueue.main.asyncAfter(deadline: .now() + Double(retries)) { webView.reload() } }"
    },
    (13, 2): {
        "quick": "WKScriptMessageHandler establishes a secure, asynchronous bi-directional communication bridge between JavaScript and native Swift. WKUserContentController receives JSON payloads via window.webkit.messageHandlers.<name>.postMessage(payload).",
        "why": "Passing data insecurely or creating strong retain cycles between WKUserContentController and UIViewController leads to massive memory leaks.",
        "model": "+---------------------------------------------------+\n| JavaScript in WKWebView                           |\n| window.webkit.messageHandlers.bridge.postMessage()|\n|                      │ IPC                        |\n|                      ▼                            |\n| WKUserContentController                           |\n|       └── WeakScriptMessageDelegateProxy          |\n|                 └── Native Bridge Handler (Swift) |\n+---------------------------------------------------+",
        "minCode": "contentController.add(self, name: \"nativeHandler\")\n// window.webkit.messageHandlers.nativeHandler.postMessage({action: 'pay'})",
        "prodCode": """import WebKit

// Weak proxy to prevent retain cycle with WKUserContentController
public final class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private weak var delegate: WKScriptMessageHandler?

    public init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

public final class HybridBridgeManager: NSObject, WKScriptMessageHandler {
    public func attach(to config: WKWebViewConfiguration) {
        config.userContentController.add(WeakScriptMessageHandler(delegate: self), name: "checkoutBridge")
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "checkoutBridge",
              let body = message.body as? [String: Any],
              let action = body["action"] as? String else { return }
        
        Task { @MainActor in
            handleBridgeAction(action, payload: body)
        }
    }

    private func handleBridgeAction(_ action: String, payload: [String: Any]) {
        // Validate origin and execute native payment / navigation
    }
}""",
        "hood": "WKUserContentController retains its script message handlers strongly. If a UIViewController conforms to WKScriptMessageHandler and registers 'self' directly, a strong reference cycle (VC -> WKWebView -> Config -> UserContentController -> VC) is created, preventing deallocation.",
        "prodEx": "Super-app mini-programs, hybrid payment checkouts, and web-based authentication callbacks.",
        "perf": "Asynchronous serialization to NSDictionary; avoids blocking the main thread JavaScript engine.",
        "mem": "Using WeakScriptMessageHandler proxy allows clean deallocation of view controllers upon pop/dismiss.",
        "maint": "Centralizes JavaScript-native contract into strongly-typed Decodable models.",
        "test": "Easily tested by mocking WKScriptMessage with simulated name and body dictionaries.",
        "comp": "Requires strict origin validation to prevent malicious XSS attacks from executing native commands.",
        "bad": "config.userContentController.add(self, name: \"analytics\") // Leaks UIViewController forever!",
        "good": "config.userContentController.add(WeakScriptMessageHandler(delegate: self), name: \"analytics\")",
        "exp": "WKUserContentController holds a strong reference to the handler. Direct 'self' registration prevents the view controller from ever deallocating.",
        "trap": "Forgetting to validate message.frame.request.url.host before executing privileged native actions like payments or biometric prompts.",
        "jq": "How do you send a message from JavaScript to native iOS in WKWebView?", "ja": "By calling window.webkit.messageHandlers.<handlerName>.postMessage(data) in JS and registering a WKScriptMessageHandler in Swift.",
        "sq": "Why does registering a UIViewController directly with WKUserContentController cause a memory leak, and how do you resolve it?", "sa": "WKUserContentController holds a strong reference to the message handler, creating a circular reference. Resolve it by inserting an intermediate weak proxy (WeakScriptMessageHandler) or removing the script handler in viewWillDisappear/deinit.",
        "pq": "How do you architect a secure bi-directional bridge preventing Cross-Site Scripting (XSS) exploitation of native APIs?", "pa": "Validate message.frame.securityOrigin to whitelist authorized host domains, sanitize all input payloads via Codable schema validation, avoid eval() when evaluating JavaScript callbacks, and use evaluateJavaScript(_:completionHandler:) with strict CSP.",
        "task": "Create a type-safe generic message handler wrapper that decodes incoming JS dictionary into a Codable struct.",
        "hint": "Convert dictionary to JSONSerialization data, then decode with JSONDecoder.",
        "sol": "func decode<T: Decodable>(_ message: WKScriptMessage) -> T? { guard let dict = message.body as? [String: Any], let data = try? JSONSerialization.data(withJSONObject: dict) else { return nil }; return try? JSONDecoder().decode(T.self, from: data) }"
    },
    (13, 3): {
        "quick": "WKWebsiteDataStore manages all cookies, IndexedDB, local storage, and WebSQL caches. Default data stores persist to disk, while nonPersistent() stores operate strictly in memory for incognito sessions.",
        "why": "Synchronizing authentication tokens between native URLSession and WKWebView requires proactive cookie injection; failing to synchronize causes unauthorized 401 errors.",
        "model": "+---------------------------------------------------+\n| Native URLSession HTTPCookieStorage               |\n|                      │ Synchronize               |\n|                      ▼                            |\n| WKWebsiteDataStore.default().httpCookieStore      |\n|                      │ Injects                    |\n|                      ▼                            |\n| WKWebView WebContent Process Cookie Jar           |\n+---------------------------------------------------+",
        "minCode": "let store = WKWebsiteDataStore.default().httpCookieStore\nstore.setCookie(cookie) { print(\"Cookie injected\") }",
        "prodCode": """import WebKit

public actor CookieSyncCoordinator {
    public static let shared = CookieSyncCoordinator()

    @MainActor
    public func injectNativeCookies(from sessionCookies: [HTTPCookie], into webView: WKWebView) async {
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        
        for cookie in sessionCookies {
            await withCheckedContinuation { continuation in
                cookieStore.setCookie(cookie) {
                    continuation.resume()
                }
            }
        }
    }

    @MainActor
    public func clearSessionData() async {
        let dataStore = WKWebsiteDataStore.default()
        let types = WKWebsiteDataStore.allWebsiteDataTypes()
        let date = Date(timeIntervalSince1970: 0)
        
        await withCheckedContinuation { continuation in
            dataStore.removeData(ofTypes: types, modifiedSince: date) {
                continuation.resume()
            }
        }
    }
}""",
        "hood": "WKHTTPCookieStore is asynchronous and communicates with the out-of-process WebKit Networking daemon. Setting a cookie takes an async round-trip before the WebContent process can see it. Loading a URL immediately after calling setCookie without awaiting completion results in a race condition where the request lacks auth cookies.",
        "prodEx": "Single Sign-On (SSO) gateways where native login yields OAuth session cookies that must carry over into web checkout.",
        "perf": "Asynchronous persistence across process boundaries; batch cookie insertion prevents UI stutter.",
        "mem": "Non-persistent data stores keep cookies strictly in RAM, freeing them upon deallocation.",
        "maint": "Eliminates legacy document.cookie JavaScript hacks by using native WKHTTPCookieStore APIs.",
        "test": "Testable via cookieStore.getAllCookies verifying presence of auth headers before request dispatch.",
        "comp": "Requires handling async timing: always await cookieStore.setCookie completion before calling load(request).",
        "bad": "cookieStore.setCookie(authCookie) // Non-blocking async!\nwebView.load(protectedURL) // Fails with 401 because cookie hasn't reached WebKit networking process yet!",
        "good": "cookieStore.setCookie(authCookie) {\n    webView.load(protectedURL) // Guaranteed cookie presence!\n}",
        "exp": "WKHTTPCookieStore operations are asynchronous cross-process calls. Loading the URL synchronously before callback completion causes race conditions.",
        "trap": "Assuming document.cookie in JavaScript can read HttpOnly cookies; only WKHTTPCookieStore can view and manipulate HttpOnly cookies.",
        "jq": "How do you share cookies between native URLSession and WKWebView?", "ja": "Extract cookies from HTTPCookieStorage.shared and inject them asynchronously into WKWebsiteDataStore.default().httpCookieStore via setCookie(_:).",
        "sq": "Why does loading a webpage immediately after calling httpCookieStore.setCookie often result in missing session cookies?", "sa": "Because WKHTTPCookieStore is asynchronous and executes across an IPC boundary to the WebKit Networking daemon. If webView.load() is invoked before the completion handler fires, the request departs before the cookie is committed.",
        "pq": "How do you completely purge all user session data (cookies, LocalStorage, IndexedDB) during user logout in a compliant GDPR manner?", "pa": "Call WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date.distantPast). Await the completion handler before allowing any new unauthenticated web requests.",
        "task": "Write an async function that fetches all current cookies from a WKWebView's cookie store.",
        "hint": "Wrap cookieStore.getAllCookies in withCheckedContinuation.",
        "sol": "func fetchCookies(from store: WKHTTPCookieStore) async -> [HTTPCookie] { await withCheckedContinuation { cont in store.getAllCookies { cont.resume(returning: $0) } } }"
    },
    (13, 4): {
        "quick": "WebKit Content Rule Lists provide declarative, compile-time filtering of network loads, cookies, and tracking scripts, matching Safari Content Blocker syntax for high-performance ad/tracker blocking and privacy enforcement.",
        "why": "Declarative rules are compiled by WebKit into optimized bytecode and executed in C++, blocking tracking domains and malicious scripts with zero JavaScript CPU overhead.",
        "model": "+---------------------------------------------------+\n| JSON Rule List Specification                      |\n| [Trigger: url-filter, Action: block]               |\n|                      │ WKContentRuleListStore      |\n|                      ▼                            |\n| Compiled WebKit Bytecode Table (Zero JS Overhead) |\n|                      │ Enforces                   |\n| WebContent Networking Request Stream              |\n+---------------------------------------------------+",
        "minCode": "WKContentRuleListStore.default().compileContentRuleList(forIdentifier: \"blockAds\", encodedContentRuleList: json) { list, _ in config.userContentController.add(list!) }",
        "prodCode": """import WebKit

public final class WebSecurityManager {
    public static let shared = WebSecurityManager()

    private let trackerRuleJSON = \"\"\"
    [
        {
            "trigger": {
                "url-filter": ".*tracker.*",
                "resource-type": ["script", "image"]
            },
            "action": {
                "type": "block"
            }
        },
        {
            "trigger": {
                "url-filter": ".*",
                "if-domain": ["*untrusted-cdn.com"]
            },
            "action": {
                "type": "block-cookies"
            }
        }
    ]
    \"\"\"

    public func applySecurityPolicies(to config: WKWebViewConfiguration) async throws {
        let store = WKContentRuleListStore.default()
        
        let ruleList: WKContentRuleList = try await withCheckedThrowingContinuation { continuation in
            store.compileContentRuleList(forIdentifier: "AppSecurityRules", encodedContentRuleList: trackerRuleJSON) { list, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let list = list {
                    continuation.resume(returning: list)
                }
            }
        }
        
        config.userContentController.add(ruleList)
    }
}""",
        "hood": "WKContentRuleListStore compiles raw JSON regular expressions and triggers into a deterministic finite automaton (DFA) stored in binary format. When WebKit's network pipeline evaluates a request, DFA evaluation occurs in microseconds in native C++, completely bypassing the JS runtime.",
        "prodEx": "In-app browsers, fintech apps blocking third-party tracking analytics, and HIPAA-compliant healthcare portals.",
        "perf": "Near-zero runtime overhead; compiles ahead of time and matches URLs at line rate in C++.",
        "mem": "Compiled bytecodes are stored on disk in the application support container.",
        "maint": "Declarative JSON rules are easy to update dynamically via remote configuration without app binary releases.",
        "test": "Testable by asserting failed navigation or blocked resource loading callbacks for blacklisted URLs.",
        "comp": "Requires valid regex adhering to Safari Content Blocker syntax specifications.",
        "bad": "func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {\n    // Intercepting every single subresource via delegate is impossible and causes massive IPC lag!\n}",
        "good": "// Compile declarative WKContentRuleList ahead-of-time in WebContentController",
        "exp": "WKNavigationDelegate only intercepts document and frame navigations, NOT individual subresources (images, scripts, CSS). Content Rule Lists are mandatory for subresource blocking.",
        "trap": "Believing WKNavigationDelegate can block background image or tracking pixel loads; only WKContentRuleList can block subresources.",
        "jq": "What is a WKContentRuleList in WebKit?", "ja": "A compiled declarative rule set that allows blocking resources, cookies, or upgrading requests to HTTPS without running custom JavaScript.",
        "sq": "Why are Content Rule Lists significantly more efficient than JavaScript-based content blocking?", "sa": "Because they are compiled into native C++ deterministic finite automatons and evaluated directly in WebKit's network stack before requests depart, with zero JavaScript execution or IPC message overhead.",
        "pq": "How do you implement an enterprise Content Security Policy (CSP) and tracker blocker in a WKWebView using compiled rule lists?", "pa": "Define strict JSON triggers with url-filter regexes and actions (block, block-cookies, make-https), compile via WKContentRuleListStore with versioned identifiers, cache compiled rules on disk, and attach to WKUserContentController before loading content.",
        "task": "Create a rule list JSON string that enforces upgrading all http requests to https.",
        "hint": "Set action type to 'make-https' with a trigger filter matching '.*'.",
        "sol": "let rule = \"\"\"[{\"trigger\": {\"url-filter\": \".*\"}, \"action\": {\"type\": \"make-https\"}}]\"\"\""
    },

    # =========================================================================
    # DOMAIN 14: Multimedia, AVFoundation, Core Animation & 120Hz Jank
    # =========================================================================
    (14, 1): {
        "quick": "The Core Animation render pipeline operates across 4 distinct phases: Commit (App), Render Tree Preparation, Render (render server process), and Display (GPU frame buffer). The app commits layer tree states via IPC to the system backboardd/render server.",
        "why": "Understanding the boundary between the host app and the render server process is crucial for profiling frame drops, offscreen passes, and GPU stalls in Instruments.",
        "model": "+---------------------------------------------------+\n| App Process: Layout -> Display -> Prepare -> Commit|\n|                         │ IPC (Mach Message)      |\n| Render Server Process: Decode -> Draw (OpenGL/Metal)|\n|                         │ Render Pipeline         |\n| GPU Frame Buffer ──► Display Screen (8.33ms / 120Hz)|\n+---------------------------------------------------+",
        "minCode": "CATransaction.begin()\nCATransaction.setAnimationDuration(0.3)\nlayer.opacity = 0.5\nCATransaction.commit()",
        "prodCode": """import UIKit
import QuartzCore

public final class HighPerformanceCardView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayerPipeline()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayerPipeline()
    }

    private func setupLayerPipeline() {
        // Explicitly set opaque to avoid GPU alpha-blending passes
        layer.isOpaque = true
        backgroundColor = .systemBackground
        
        // Cache shadow path to avoid dynamic offscreen rendering pass
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSize(width: 0, height: 4)
        updateShadowPath()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    private func updateShadowPath() {
        // Critical: Passing explicit CGPath prevents GPU render server offscreen pass
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12.0).cgPath
    }
}""",
        "hood": "The app process executes 4 phases during commit: 1. Layout (layoutSubviews), 2. Display (drawRect rasterization if implemented), 3. Prepare (image decompression), 4. Commit (packing layer tree into Mach IPC message). The Render Server decodes the layer tree and schedules Metal draw calls for the GPU.",
        "prodEx": "Feed scrolling, complex interactive animations, and fluid transitions in apps like Instagram and Uber.",
        "perf": "Eliminating drawRect and providing shadowPath keeps commits well under the 8.33ms 120Hz ProMotion budget.",
        "mem": "Backing stores (CABackingStore) consume width * height * 4 bytes per rasterized layer.",
        "maint": "Using declarative CALayer properties ensures hardware acceleration without custom drawing code.",
        "test": "Verifiable in Xcode Instruments under 'Core Animation' and 'Metal System Trace'.",
        "comp": "Requires understanding difference between Model Layer, Presentation Layer, and Render Tree.",
        "bad": "layer.shadowOpacity = 0.5\n// Omitting layer.shadowPath forces GPU to perform expensive offscreen rendering pass on every frame!",
        "good": "layer.shadowOpacity = 0.5\nlayer.shadowPath = UIBezierPath(rect: bounds).cgPath // Zero offscreen rendering overhead!",
        "exp": "Without a shadowPath, the GPU cannot determine the layer's outline without first rendering all sublayers to an offscreen buffer, doubling GPU work.",
        "trap": "Modifying presentationLayer values expecting model state changes; presentationLayer is read-only during animations.",
        "jq": "What are the four phases of the Core Animation commit pipeline in the app process?", "ja": "Layout (layoutSubviews), Display (draw(_:)), Prepare (image decompression/format conversion), and Commit (packing layers into IPC for render server).",
        "sq": "Why does setting a shadow on a CALayer without defining shadowPath devastate scrolling performance?", "sa": "Because the GPU cannot compute the shadow geometry without first rendering the layer and all its children into a temporary offscreen buffer, creating an offscreen pass on every frame.",
        "pq": "Explain the difference between the Model Layer Tree, Presentation Layer Tree, and Render Tree during an ongoing spring animation.", "pa": "The Model Tree stores target values set in code. The Presentation Tree represents instantaneous interpolated values currently visible. The Render Tree is the private compiled tree inside the out-of-process render server executing GPU draws.",
        "task": "Write a CATransaction completion block that triggers a secondary animation strictly after the first finishes.",
        "hint": "Use CATransaction.setCompletionBlock before commit.",
        "sol": "CATransaction.begin(); CATransaction.setCompletionBlock { print(\"Finished\") }; layer.opacity = 0; CATransaction.commit()"
    },
    (14, 2): {
        "quick": "Offscreen rendering occurs when the GPU cannot draw content directly into the frame buffer and must allocate a temporary offscreen buffer to combine multiple rendering passes (masks, un-cached shadows, cornerRadius with masksToBounds, group opacity).",
        "why": "Offscreen rendering requires GPU pipeline stalls and context switches, dropping frame rates from 120Hz/60Hz and consuming high battery power.",
        "model": "+---------------------------------------------------+\n| Onscreen Render: GPU ──► Frame Buffer (Direct)     |\n|                                                   |\n| Offscreen Render: GPU ──► Temp Offscreen Buffer   |\n|                            │ Context Switch       |\n| GPU Combine Pass ──────────► Final Frame Buffer    |\n+---------------------------------------------------+",
        "minCode": "view.layer.cornerRadius = 10\nview.layer.masksToBounds = true // Triggers offscreen if sublayers overlap",
        "prodCode": """import UIKit

public final class OptimizedAvatarImageView: UIImageView {
    public func setRoundedImage(_ image: UIImage, cornerRadius: CGFloat) {
        // High-performance CPU pre-clipping: Zero GPU offscreen pass
        let size = bounds.size
        guard size.width > 0, size.height > 0 else { return }

        let renderer = UIGraphicsImageRenderer(size: size)
        let roundedImage = renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
            image.draw(in: rect)
        }
        
        self.image = roundedImage
        // Disable expensive GPU masking
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 0
    }
}""",
        "hood": "When offscreen rendering is triggered, the GPU halts rasterization to the onscreen frame buffer, switches rendering context to a secondary VRAM texture, completes all child draws, and copies the composited texture back. This context switch invalidates GPU tile cache pipelines on Apple Silicon (TBDR).",
        "prodEx": "Cell recycling in collection views with rounded user avatars, blur effects, and complex badges.",
        "perf": "Pre-clipping on a background thread or using UIGraphicsImageRenderer achieves locked 120fps scrolling.",
        "mem": "Avoids multiple ephemeral VRAM buffer allocations per scrolling cell.",
        "maint": "Eliminates visual glitching and stutter during fast fling scrolls.",
        "test": "Verifiable in Xcode via 'Debug > View Debugging > Rendering > Color Offscreen-Rendered Yellow'.",
        "comp": "Requires balancing CPU rasterization cost against GPU compositing load.",
        "bad": "cell.imageView.layer.cornerRadius = 24\ncell.imageView.layer.masksToBounds = true // Yellow flashing in Instruments on every recycled cell!",
        "good": "cell.imageView.image = preRoundedImage // Zero yellow offscreen render passes!",
        "exp": "masksToBounds combined with cornerRadius forces the GPU to allocate offscreen buffers for every visible cell in a fast-scrolling list.",
        "trap": "Believing shouldRasterize = true is a cure-all; rasterizing dynamically moving or resizing views causes severe offscreen churn.",
        "jq": "What is offscreen rendering and why is it problematic on iOS?", "ja": "It is when the GPU must render content into an intermediate memory buffer before copying to the frame buffer, causing context switches and dropping frame rates.",
        "sq": "What are 4 common triggers of offscreen rendering in UIKit?", "sa": "1. Shadows without shadowPath. 2. cornerRadius combined with masksToBounds. 3. Masks (layer.mask). 4. Group opacity (allowsGroupOpacity with transparent sublayers).",
        "pq": "How does Apple Silicon Tile-Based Deferred Rendering (TBDR) architecture exacerbate the cost of offscreen render passes?", "pa": "TBDR relies on tile-memory (on-chip SRAM) to process geometry and deferred shading before writing to unified memory. An offscreen pass forces flushing tile memory to main DRAM, incurring massive memory bus bandwidth penalties and battery consumption.",
        "task": "Identify the Xcode Debug menu option that visually highlights offscreen rendering on device.",
        "hint": "Check rendering options under View Debugging.",
        "sol": "Debug -> View Debugging -> Rendering -> Color Offscreen-Rendered"
    },
    (14, 3): {
        "quick": "AVFoundation manages multimedia through an asynchronous pipeline: AVAudioSession coordinates hardware audio routing, AVPlayer/AVQueuePlayer handles asset streaming, and AVPlayerItem tracks timeline buffering states.",
        "why": "Failing to properly configure AVAudioSession categories and interrupts leads to silent playback bugs, audio ducking failures, and App Store rejections.",
        "model": "+---------------------------------------------------+\n| Hardware Audio Device (Speaker / Bluetooth)       |\n|                      │ Control                    |\n| AVAudioSession (Category: .playback, Mode: .movie)|\n|                      ▲                            |\n| AVPlayer ──► AVPlayerItem ──► AVAsset (Tracks)    |\n+---------------------------------------------------+",
        "minCode": "let session = AVAudioSession.sharedInstance()\ntry session.setCategory(.playback, mode: .moviePlayback)\ntry session.setActive(true)",
        "prodCode": """import AVFoundation

public final class RobustAudioPlaybackEngine: Sendable {
    private let player = AVPlayer()

    public func configureSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])
        try session.setActive(true)
        
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: session,
            queue: .main
        ) { [weak self] notification in
            self?.handleInterruption(notification)
        }
    }

    private func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        switch type {
        case .began:
            player.pause()
        case .ended:
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    player.play()
                }
            }
        @unknown default:
            break
        }
    }
}""",
        "hood": "AVAudioSession communicates with the system mediaserverd daemon. When phone calls or alarms ring, mediaserverd revokes audio hardware access and dispatches interruption notifications. If the app fails to pause, playback stalls.",
        "prodEx": "Spotify-like music streaming, podcast players, and voice-guided navigation.",
        "perf": "Asynchronous asset loading avoids disk and network I/O stalls on the main thread.",
        "mem": "AVPlayerItem manages dynamic memory buffer caches according to preferredForwardBufferDuration.",
        "maint": "Proper interruption and route change handling prevents abrupt audio crashes.",
        "test": "Verifiable by simulating phone calls or plugging/unplugging headphones in manual QA.",
        "comp": "Requires handling complex audio route changes and Bluetooth disconnects.",
        "bad": "try AVAudioSession.sharedInstance().setActive(true) // Never listening to interruption notifications; app stays muted after phone calls!",
        "good": "// Observe AVAudioSession.interruptionNotification and check InterruptionOptions.shouldResume",
        "exp": "Failing to handle audio session interruptions means when an incoming phone call ends, the audio will remain permanently paused.",
        "trap": "Calling setActive(false) while other background audio is playing, inadvertently terminating other apps' music.",
        "jq": "What is the role of AVAudioSession in iOS multimedia apps?", "ja": "It acts as the intermediary between your app and the system audio hardware, defining audio category, interruptions, and mixing behaviors.",
        "sq": "How do you correctly handle an incoming phone call interruption during media playback in AVPlayer?", "sa": "Observe AVAudioSession.interruptionNotification. On .began, pause the player. On .ended, inspect AVAudioSessionInterruptionOptions for .shouldResume, and only resume playback if true.",
        "pq": "How do you achieve seamless gapless playback and pre-buffering across sequential video items in a short-form video feed (e.g. TikTok/Reels)?", "pa": "Use AVQueuePlayer with a pool of pre-initialized AVPlayerItem instances, configure automaticallyWaitsToMinimizeStalling = true, preload tracks asynchronously via AVAsset.loadValuesAsynchronously, and bound preferredForwardBufferDuration to prevent memory exhaustion.",
        "task": "Configure AVAudioSession category for playback that ducks other background audio.",
        "hint": "Use category .playback and option .duckOthers.",
        "sol": "try AVAudioSession.sharedInstance().setCategory(.playback, options: .duckOthers)"
    },
    (14, 4): {
        "quick": "On 120Hz ProMotion displays (iPhone 13 Pro+), each frame must be completely laid out, prepared, and committed within an 8.33ms budget (vs 16.67ms on 60Hz). Exceeding this budget causes dropped frames (jank).",
        "why": "High-end devices expose micro-stutters immediately; staying under the 8.33ms budget requires eliminating main-thread JSON parsing, view hierarchy recalculations, and layout thrashing.",
        "model": "+---------------------------------------------------+\n| 60Hz Frame Budget:  16.67ms (Generous)            |\n| 120Hz ProMotion:    8.33ms  (STRICT ZERO-JANK)    |\n| [Main Thread Commit: <4ms] [GPU Draw: <4ms]       |\n| Anything > 8.33ms ──► DROPPED FRAME (JANK)!       |\n+---------------------------------------------------+",
        "minCode": "let displayLink = CADisplayLink(target: self, selector: #selector(renderFrame))\ndisplayLink.add(to: .main, forMode: .common)",
        "prodCode": """import UIKit
import QuartzCore

public final class ProMotionAdaptiveAnimator {
    private var displayLink: CADisplayLink?

    public func startSmoothAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(handleFrameUpdate(link:)))
        
        // Target dynamic 120Hz ProMotion rates on capable hardware
        displayLink?.preferredFrameRateRange = CAFrameRateRange(
            minimum: 60,
            maximum: 120,
            preferred: 120
        )
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func handleFrameUpdate(link: CADisplayLink) {
        let frameDuration = link.targetTimestamp - link.timestamp
        // Ensure calculations finish in < 4ms to leave headroom for render server
        updatePositions(deltaTime: frameDuration)
    }

    private func updatePositions(deltaTime: CFTimeInterval) {
        // Fast numerical calculation with zero heap allocations
    }

    public func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
}""",
        "hood": "CADisplayLink synchronizes code execution with the vertical blanking interval (VBL) of the physical display. On ProMotion hardware, the system dynamically scales the refresh rate from 10Hz (static text) up to 120Hz (fast touch scroll) via variable refresh rate (VRR).",
        "prodEx": "Custom game engines, high-precision charting dashboards, and smooth gesture-driven sheet interactive transitions.",
        "perf": "Locking animations to CADisplayLink avoids timer drift and missed VBL intervals.",
        "mem": "Zero allocations within the tick handler ensures garbage collection/ARC doesn't spike frame times.",
        "maint": "CAFrameRateRange allows adaptive power saving down to 10Hz when static.",
        "test": "Profiled using Instruments 'Core Animation' checking Frame Rate and Hitch Time Ratio.",
        "comp": "Requires managing CADisplayLink lifecycle and preventing strong retain cycles with target.",
        "bad": "Timer.scheduledTimer(withTimeInterval: 0.008, repeats: true) { _ in /* Janky unsynchronized timer updates */ }",
        "good": "let link = CADisplayLink(target: self, selector: #selector(tick)); link.preferredFrameRateRange = CAFrameRateRange(min:60, max:120, pref:120)",
        "exp": "NSTimer is not synchronized with the GPU display refresh cycle (V-Sync), causing erratic frame tearing and jank.",
        "trap": "Allocating objects inside CADisplayLink tick callbacks; heap allocations trigger ARC churn and hitch spikes.",
        "jq": "What is the frame budget for a 120Hz ProMotion display on iPhone?", "ja": "8.33 milliseconds per frame (compared to 16.67ms for standard 60Hz displays).",
        "sq": "How does CADisplayLink differ from Timer when driving high-performance animations?", "sa": "CADisplayLink is synchronized with the display hardware's vertical refresh rate (V-Sync), eliminating frame stutter and visual tearing that occurs with unsynchronized NSTimers.",
        "pq": "How do you profile and measure Hitch Time Ratio in MetricKit and Instruments to diagnose scrolling jank?", "pa": "MetricKit reports MXScrollMetrics containing cumulativeHitchTime. In Instruments Core Animation / Time Profiler, filter by Hitch Ratio (ms of delay per second). Hitches over 5ms/s indicate noticeable stutter, usually traced to main-thread layout passes or offscreen GPU rendering.",
        "task": "Configure a CADisplayLink for maximum battery efficiency that scales between 30Hz and 120Hz.",
        "hint": "Set CAFrameRateRange with minimum 30 and maximum 120.",
        "sol": "displayLink.preferredFrameRateRange = CAFrameRateRange(minimum: 30, maximum: 120, preferred: 60)"
    },

    # =========================================================================
    # DOMAIN 20: Privacy Manifests (PrivacyInfo.xcprivacy), APIs & ATT
    # =========================================================================
    (20, 1): {
        "quick": "Privacy Manifests (PrivacyInfo.xcprivacy) are structured XML files required by Apple since Spring 2024. They declare the types of data collected, tracking practices, and approved reason codes for accessing sensitive platform APIs.",
        "why": "Missing or improperly formatted Privacy Manifests in your app or third-party dependencies results in immediate App Store Connect binary upload rejection (ITMS-91053).",
        "model": "+---------------------------------------------------+\n| PrivacyInfo.xcprivacy (Root Dictionary)           |\n| ├── NSPrivacyTracking (Bool)                      |\n| ├── NSPrivacyTrackingDomains (Array<String>)      |\n| ├── NSPrivacyCollectedDataTypes (Array<Dict>)     |\n| └── NSPrivacyAccessedAPITypes (Array<Dict>)       |\n+---------------------------------------------------+",
        "minCode": "<plist version=\"1.0\"><dict><key>NSPrivacyTracking</key><false/></dict></plist>",
        "prodCode": """// PrivacyInfo.xcprivacy XML Structure for App Store Compliance
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeUserID</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <true/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
    </array>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>""",
        "hood": "During App Store submission, Apple's automated ingest pipeline scans the app binary and all embedded frameworks for symbols belonging to Required Reason API categories. It cross-checks these symbols against the aggregated PrivacyInfo.xcprivacy files. Missing reasons trigger automated rejections.",
        "prodEx": "Mandatory across all production iOS apps and SDKs submitted to the App Store.",
        "perf": "Zero runtime overhead; purely static manifest evaluated during App Store ingest and Xcode archive.",
        "mem": "Zero memory footprint.",
        "maint": "Xcode 15+ allows generating a consolidated Privacy Report directly from the Organizer Archive.",
        "test": "Verifiable in Xcode via 'Product > Archive > Generate Privacy Report'.",
        "comp": "Requires synchronizing declared data types with App Store Connect Nutrition Labels.",
        "bad": "<!-- App accesses UserDefaults, but PrivacyInfo.xcprivacy is omitted! -->\n<!-- Immediate App Store rejection email: ITMS-91053: Missing API reason code! -->",
        "good": "<!-- Declare NSPrivacyAccessedAPICategoryUserDefaults with reason CA92.1 -->",
        "exp": "Since May 1, 2024, accessing UserDefaults or File Timestamps without declaring an approved reason code in PrivacyInfo.xcprivacy causes immediate binary rejection.",
        "trap": "Declaring tracking = false in the manifest while firing tracking network calls to third-party ad networks before ATT authorization.",
        "jq": "What is PrivacyInfo.xcprivacy and when is it required?", "ja": "It is an Apple-mandated privacy manifest XML file required for all apps and third-party SDKs to declare data collection, tracking domains, and Required Reason API usage.",
        "sq": "How does Xcode help you verify Privacy Manifest completeness across your app and all SPM dependencies?", "sa": "By archiving the app in Xcode Organizer, contextual clicking the archive, and choosing 'Generate Privacy Report', which outputs a consolidated PDF detailing all declared and undeclared API reasons and data types.",
        "pq": "How does Apple enforce tracking domain blocking when NSPrivacyTracking is true vs false?", "pa": "If a domain is listed in NSPrivacyTrackingDomains, the OS automatically blocks network requests to that domain if the user has not granted App Tracking Transparency (ATT) permission, throwing a network connection failure.",
        "task": "State the Xcode Organizer command used to create an aggregated privacy audit PDF.",
        "hint": "Check options in the Archive contextual menu.",
        "sol": "Organizer -> Select Archive -> Context Menu -> Generate Privacy Report"
    },
    (20, 2): {
        "quick": "Apple designates 4 sensitive API categories as 'Required Reason APIs': File Timestamp APIs, System Boot Time APIs, Disk Space APIs, and UserDefaults APIs. Developers must declare specific Apple-approved reason strings (e.g. CA92.1) in their manifest.",
        "why": "Apple introduced Required Reason APIs to permanently prevent fingerprinting (identifying users across apps without consent).",
        "model": "+---------------------------------------------------+\n| Required Reason API Categories (Apple Mandate)    |\n| 1. UserDefaults           ──► Reason: CA92.1      |\n| 2. File Timestamp         ──► Reason: C617.1      |\n| 3. System Boot Time       ──► Reason: 35F9.1      |\n| 4. Disk Space             ──► Reason: E174.1      |\n+---------------------------------------------------+",
        "minCode": "UserDefaults.standard.set(true, forKey: \"onboarding_completed\") // Requires CA92.1 in manifest",
        "prodCode": """import Foundation

// Safe abstraction accessing Required Reason APIs with verified justification
public enum AppPreferencesManager {
    // Reason: CA92.1 (Access UserDefaults to read and write app-specific state)
    public static func markOnboardingComplete() {
        UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
    }

    // Reason: C617.1 (Access file timestamps to verify cache freshness)
    public static func isCacheValid(at fileURL: URL, maxAge: TimeInterval) -> Bool {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
              let modDate = attributes[.modificationDate] as? Date else {
            return false
        }
        return Date().timeIntervalSince(modDate) < maxAge
    }
}""",
        "hood": "Apple's static analysis binary scanner decompiles the app Mach-O binary searching for calls to stat(), getattrlist(), sysctl(KERN_BOOTTIME), NSUserDefaults, and statfs(). If any symbol is detected, the scanner verifies that the corresponding reason code exists in the privacy plist.",
        "prodEx": "Every modern iOS codebase managing user preferences, disk caching, or app launch state.",
        "perf": "Zero overhead; static binary validation.",
        "mem": "Zero memory impact.",
        "maint": "Requires auditing third-party libraries: even if your code doesn't call an API, a dependency doing so triggers rejection.",
        "test": "Run ripgrep or nm across binary symbols to detect calls to prohibited APIs before App Store submission.",
        "comp": "Developers cannot invent custom reasons; must pick from Apple's official whitelist.",
        "bad": "// Using system boot time to calculate an un-resettable device fingerprint:\nvar bootTime = timeval()\nsysctlbyname(\"kern.boottime\", &bootTime, &size, nil, 0) // Violates Apple Anti-Fingerprinting Policy!",
        "good": "// Use ASIdentifierManager or UIDevice.current.identifierForVendor for legitimate vendor-level scoping",
        "exp": "Using boot time or disk space to compute a cross-app device fingerprint violates Apple developer terms and results in app termination.",
        "trap": "Believing UserDefaults doesn't require a reason code because it is basic Foundation functionality; it strictly requires CA92.1.",
        "jq": "What is reason code CA92.1 for in PrivacyInfo.xcprivacy?", "ja": "It is the approved reason code declaring that the app accesses UserDefaults to store and read app-specific configuration data.",
        "sq": "Why did Apple restrict access to File Timestamps, Disk Space, and Boot Time APIs?", "sa": "Because malicious ad SDKs combined minute disk space variations, boot time microseconds, and file modification dates to construct immutable device fingerprints without user consent.",
        "pq": "How would you diagnose which third-party dependency in a large modular SPM project is triggering an ITMS-91053 Required Reason rejection?", "pa": "Generate the Privacy Report from the Xcode archive to see the flagged category, then run 'nm -u' or 'grep -rn' on derived data binary artifacts to locate symbols like _OBJC_CLASS_$_NSUserDefaults or _statfs in third-party frameworks.",
        "task": "Specify the approved reason code for accessing File Modification Date to manage local cache files.",
        "hint": "The reason code starts with C617.",
        "sol": "C617.1 (Access info about files inside the app container to manage file caching)"
    },
    (20, 3): {
        "quick": "Apple maintains a list of 'Privacy-Impacting Third-Party SDKs' (e.g., Firebase, Facebook SDK, Alamofire, AppsFlyer). Starting in 2024, these SDKs MUST include their own Privacy Manifest AND be cryptographically signed with an Apple Developer ID.",
        "why": "Unsigned or unmanifested privacy-impacting SDKs are rejected at binary validation time to eliminate software supply chain vulnerabilities.",
        "model": "+---------------------------------------------------+\n| Third-Party SDK Supply Chain Verification         |\n| ├── Cryptographic Signature (Apple Developer ID)   |\n| ├── Embedded PrivacyInfo.xcprivacy                |\n| └── SPM / XCFramework Checksum Validation         |\n+---------------------------------------------------+",
        "minCode": "// XCFramework must contain: _CodeSignature/CodeResources and PrivacyInfo.xcprivacy",
        "prodCode": """// Package.swift manifest enforcing binary artifact security
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EnterpriseSecuritySuite",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "EnterpriseSecuritySuite", targets: ["EnterpriseSecuritySuiteTarget"])
    ],
    targets: [
        .binaryTarget(
            name: "VerifiedVendorSDK",
            url: "https://vendor.cdn.com/VerifiedVendorSDK-v2.4.0.xcframework.zip",
            checksum: "a1b2c3d4e5f67890abcdef1234567890abcdef1234567890abcdef1234567890"
        ),
        .target(
            name: "EnterpriseSecuritySuiteTarget",
            dependencies: ["VerifiedVendorSDK"],
            resources: [.process("PrivacyInfo.xcprivacy")]
        )
    ]
)""",
        "hood": "When building an archive, Xcode validates the signature of embedded XCFrameworks using codesign. If the certificate does not match the vendor's known Developer ID or if the signatures are forged, the build fails or App Store Connect rejects the submission.",
        "prodEx": "Managing third-party analytics (Mixpanel, Datadog), advertising, and payments (Stripe) in enterprise apps.",
        "perf": "Zero runtime impact; signed binary verification occurs during compilation and App Store validation.",
        "mem": "Zero memory footprint.",
        "maint": "Eliminates unexpected supply chain tampering or unvetted tracking payloads.",
        "test": "Verify via terminal: codesign -dv --verbose=4 FrameworkName.xcframework.",
        "comp": "Requires coordinating dependency updates with external vendors.",
        "bad": "// Importing an un-signed pre-compiled framework binary without PrivacyInfo.xcprivacy in 2024+",
        "good": "// Ensure all binary dependencies are signed XCFrameworks with embedded PrivacyInfo.xcprivacy",
        "exp": "Apple mandates that any privacy-impacting SDK must be signed by its author; unsigned binaries are rejected during App Store processing.",
        "trap": "Resigning a third-party framework with your own team certificate instead of requiring the vendor's signed distribution.",
        "jq": "What are Privacy-Impacting SDKs according to Apple?", "ja": "A designated list of widely-used third-party SDKs that have high privacy impact (analytics, ads, utilities) and are required to provide signed manifests.",
        "sq": "How does Xcode ensure that a third-party SDK has not been tampered with in transit?", "sa": "By requiring cryptographic code signing with the SDK vendor's Apple Developer certificate, and verifying SHA-256 checksums in Package.swift for remote binary targets.",
        "pq": "How do you audit and enforce third-party SDK privacy compliance in an enterprise CI/CD pipeline before merging PRs?", "pa": "Integrate an automated CI build step running a script that inspects all embedded frameworks for code signatures via codesign -dv, checks for PrivacyInfo.xcprivacy in bundle resources, and compares symbols against prohibited fingerprinting APIs.",
        "task": "Write the terminal command to verify the cryptographic code signature of an XCFramework.",
        "hint": "Use codesign with -dv and verbose flags.",
        "sol": "codesign -dv --verbose=4 Path/To/VendorSDK.xcframework"
    },
    (20, 4): {
        "quick": "App Tracking Transparency (ATT) requires apps to request user authorization via AppTrackingTransparency.framework before accessing the ID for Advertisers (IDFA) or tracking users across apps and websites owned by other companies.",
        "why": "Tracking users or accessing IDFA without explicit user authorization results in immediate App Store rejection or developer account suspension.",
        "model": "+---------------------------------------------------+\n| App Launch                                        |\n| └── Display Soft-Prompt Context Screen            |\n|       └── ATTrackingManager.requestTrackingAuth() |\n|             ├── .authorized   ──► Read IDFA       |\n|             └── .denied       ──► Zeroed UUID     |\n+---------------------------------------------------+",
        "minCode": "ATTrackingManager.requestTrackingAuthorization { status in print(status) }",
        "prodCode": """import AppTrackingTransparency
import AdSupport

public enum TrackingPermissionCoordinator {
    @MainActor
    public static func requestAuthorizationIfNeeded() async -> ATTrackingManager.AuthorizationStatus {
        // Must declare NSUserTrackingUsageDescription in Info.plist!
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            return ATTrackingManager.trackingAuthorizationStatus
        }

        // Must be called when app is in active foreground state
        return await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }

    public static func resolveAdvertisingIdentifier() -> String? {
        guard ATTrackingManager.trackingAuthorizationStatus == .authorized else {
            return nil // Return nil when not authorized; IDFA is zeroed out
        }
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}""",
        "hood": "When status is not .authorized, ASIdentifierManager returns a zeroed string: 00000000-0000-0000-0000-000000000000. Calling requestTrackingAuthorization while the application is not in UIApplication.State.active causes the prompt to fail silently.",
        "prodEx": "Mobile measurement partners (AppsFlyer, Branch), ad attribution, and retargeting campaigns.",
        "perf": "Asynchronous modal prompt; zero runtime impact.",
        "mem": "Zero memory footprint.",
        "maint": "Requires synchronizing user preferences across analytics SDK initializers.",
        "test": "Testable on physical device by resetting tracking permission under Settings > Privacy > Tracking.",
        "comp": "Requires an informative NSUserTrackingUsageDescription explaining value to user.",
        "bad": "let idfa = ASIdentifierManager.shared().advertisingIdentifier // Reading IDFA before requesting permission!",
        "good": "guard ATTrackingManager.trackingAuthorizationStatus == .authorized else { return nil }\nlet idfa = ASIdentifierManager.shared().advertisingIdentifier",
        "exp": "Attempting to track or read IDFA without user consent violates Apple privacy guidelines and triggers binary rejection.",
        "trap": "Calling requestTrackingAuthorization in application:didFinishLaunchingWithOptions: before the window is key and active, causing the dialog to never appear.",
        "jq": "What value does advertisingIdentifier return if tracking permission is denied?", "ja": "All zeros: 00000000-0000-0000-0000-000000000000.",
        "sq": "Why must requestTrackingAuthorization be called only after the application enters the active state?", "sa": "Because iOS requires an active UI window hierarchy to present the system permission modal. Calling it in didFinishLaunchingWithOptions before the scene is active causes the call to fail or be dropped.",
        "pq": "How do modern ad-tech platforms attribute app installations without ATT tracking consent?", "pa": "They rely on Apple's SKAdNetwork (SKAN) and AdAttributionKit, which provide privacy-preserving, cryptographically signed, aggregated conversion data directly from the App Store without exposing user-level IDFAs.",
        "task": "Specify the mandatory Info.plist key required before calling requestTrackingAuthorization.",
        "hint": "Starts with NSUserTracking...",
        "sol": "NSUserTrackingUsageDescription"
    },

    # =========================================================================
    # DOMAIN 24: App Extensions (WidgetKit, Share) & Multi-Target Setup
    # =========================================================================
    (24, 1): {
        "quick": "App Extensions are separate standalone binary executables (.appex) running in their own sandboxed processes with strict system-enforced memory limits (typically 30MB for WidgetKit and Share extensions). Exceeding this cap results in immediate Jetsam kill.",
        "why": "Extensions do not share process memory with the containing app; loading heavy images, large JSON payloads, or un-thinned frameworks crashes the extension silently.",
        "model": "+---------------------------------------------------+\n| Host App Process (.app)    Memory Cap: ~2GB+      |\n|                                                   |\n| Extension Process (.appex) Memory Cap: ~30MB      |\n| └── Exceeds 30MB? ──► JETSAM TERMINATION (Crash!) |\n|                                                   |\n| Shared Bridge: App Group Container Directory      |\n+---------------------------------------------------+",
        "minCode": "// Extension Info.plist: NSExtensionPointIdentifier = com.apple.widgetkit-extension",
        "prodCode": """import WidgetKit
import SwiftUI

// High-efficiency, memory-bounded timeline provider
public struct OptimizedTimelineProvider: TimelineProvider {
    public typealias Entry = SimpleEntry

    public func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "Loading...")
    }

    public func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date(), text: "Sample"))
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // Enforce lightweight data access: Read small shared JSON file from App Group
        let sharedText = readLightweightSharedState()
        let entry = SimpleEntry(date: Date(), text: sharedText)
        
        // Refresh after 1 hour to respect energy budget
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func readLightweightSharedState() -> String {
        // Fast, low-memory read avoiding heavy database or full app framework initialization
        return "Active"
    }
}

public struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let text: String
}""",
        "hood": "The iOS kernel assigns extension processes to the lowest Jetsam priority bucket. The operating system monitors memory foot-print via task_info. If resident memory crosses the extension's hard cap (~30MB), the process is immediately killed with EXC_RESOURCE / MEMORY_LIMIT without raising a Swift exception.",
        "prodEx": "WidgetKit home screen widgets, Share extensions, Safari web extensions, and Notification Service extensions.",
        "perf": "Extremely fast startup (<100ms) required; extensions that hang during initialization are killed by watchdog.",
        "mem": "Hard 30MB limit; avoid importing heavy dependencies or Core Data stacks unless specifically trimmed.",
        "maint": "Code sharing between main app and extension must be factored into isolated modular Swift packages.",
        "test": "Verifiable by running Allocations instrument specifically targeted at the .appex process.",
        "comp": "Requires decoupling presentation logic from heavyweight app singleton architectures.",
        "bad": "import HeavyAppFramework // Pulls in 80MB of dependencies into Widget extension!\n// Extension crashes immediately on launch due to Jetsam memory exhaustion!",
        "good": "import WidgetKit\n// Import only lightweight SharedModels package with minimal memory footprint",
        "exp": "Widget and extension processes have a strict ~30MB memory ceiling. Linking heavyweight monolithic frameworks triggers immediate termination.",
        "trap": "Attempting to call UIApplication.shared in an extension; extensions do not have access to the shared application instance.",
        "jq": "What is the typical memory limit for an iOS App Extension like WidgetKit?", "ja": "Approximately 30MB. Exceeding this limit causes immediate Jetsam process termination.",
        "sq": "Why can you not use UIApplication.shared inside an App Extension target?", "sa": "Because app extensions are not full applications and do not own the application lifecycle or window hierarchy; UIApplication.shared is marked unavailable in extension API environments.",
        "pq": "How do you architect modular code sharing between a main app target and multiple extension targets without binary bloat?", "pa": "Extract shared data models and business logic into lightweight, standalone Swift Packages or dynamic frameworks configured with 'Require Only Extension-Safe API'. Never link the main application monolithic target directly.",
        "task": "Name the build setting that restricts code to extension-safe APIs.",
        "hint": "Check Xcode target build setting for Extension API.",
        "sol": "APPLICATION_EXTENSION_API_ONLY = YES"
    },
    (24, 2): {
        "quick": "WidgetKit timelines are declarative schedules of TimelineEntry structs driven by TimelineProvider. Timelines specify reload policies: .atEnd, .after(date), or .never (relying on WidgetCenter.shared.reloadTimelines).",
        "why": "Widget reloads are strictly throttled by an OS daily budget (~40-70 reloads/day). Inefficient timeline scheduling exhausts the budget, leaving widgets frozen.",
        "model": "+---------------------------------------------------+\n| TimelineProvider.getTimeline()                    |\n| ├── Entry 1 (12:00 PM) ──► UI State A             |\n| ├── Entry 2 (12:15 PM) ──► UI State B             |\n| ├── Entry 3 (12:30 PM) ──► UI State C             |\n| Policy: .after(1:00 PM) (Respects OS Budget)      |\n+---------------------------------------------------+",
        "minCode": "let timeline = Timeline(entries: entries, policy: .after(nextHour))\ncompletion(timeline)",
        "prodCode": """import WidgetKit
import SwiftUI

public struct FlightWidgetProvider: TimelineProvider {
    public typealias Entry = FlightEntry

    public func placeholder(in context: Context) -> FlightEntry {
        FlightEntry(date: Date(), status: "On Time", gate: "B12")
    }

    public func getSnapshot(in context: Context, completion: @escaping (FlightEntry) -> Void) {
        completion(FlightEntry(date: Date(), status: "Departing", gate: "B12"))
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<FlightEntry>) -> Void) {
        let currentDate = Date()
        var entries: [FlightEntry] = []

        // Generate pre-calculated timeline entries for the next 2 hours
        for minuteOffset in stride(from: 0, to: 120, by: 15) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let status = minuteOffset > 60 ? "Boarding" : "On Time"
            entries.append(FlightEntry(date: entryDate, status: status, gate: "B12"))
        }

        // Request next timeline update after 2 hours
        let refreshDate = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}

public struct FlightEntry: TimelineEntry {
    public let date: Date
    public let status: String
    public let gate: String
}""",
        "hood": "WidgetKit does not run continuously. The system evaluates the timeline ahead of time, archives the entries, and renders snapshots of the SwiftUI views. At the designated timestamp, the system replaces the displayed snapshot with zero CPU wake-up for your code.",
        "prodEx": "Weather forecasts, flight status trackers, calendar agendas, and sports scoreboards.",
        "perf": "Zero background CPU wakeups between timeline steps; views are pre-rendered into static graphics by the OS.",
        "mem": "Entries must be lightweight data structs; pre-rendering minimizes runtime memory.",
        "maint": "Centralizes timeline computation in a single deterministic pure function.",
        "test": "Easily tested with unit tests evaluating generated entries across varying simulated dates.",
        "comp": "Requires understanding difference between pre-scheduled timeline entries and dynamic reloads.",
        "bad": "let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(10)))\n// Refreshing every 10 seconds exhausts the OS daily widget budget within 15 minutes!",
        "good": "let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(3600)))",
        "exp": "Widgets are subject to a strict daily budget. Requesting updates every few seconds causes iOS to permanently freeze widget refreshes until the next day.",
        "trap": "Believing widgets run live code in the background; widgets are pre-rendered snapshots evaluated on a timeline.",
        "jq": "What are the three reload policies available in WidgetKit's Timeline?", "ja": ".atEnd (reload when entries finish), .after(date) (reload after specific time), and .never (only reload when manually triggered via app or push).",
        "sq": "How does the iOS daily widget reload budget work, and how do you handle frequent dynamic updates?", "sa": "The system allocates roughly 40-70 reloads per 24 hours. For frequent real-time updates (like sports scores or delivery tracking), use Live Activities (ActivityKit) rather than standard WidgetKit widgets.",
        "pq": "How do you trigger a targeted widget reload from the main application when a critical user event occurs?", "pa": "Call WidgetCenter.shared.reloadTimelines(ofKind: 'WidgetKindIdentifier'). To reload all widgets across the app, call WidgetCenter.shared.reloadAllTimelines(). Avoid calling this in high-frequency loops.",
        "task": "Trigger a reload for all widgets with kind 'WeatherWidget' from the main app.",
        "hint": "Use WidgetCenter.shared.",
        "sol": "WidgetCenter.shared.reloadTimelines(ofKind: \"WeatherWidget\")"
    },
    (24, 3): {
        "quick": "Share Extensions allow users to share content (URLs, images, text) from other apps into your ecosystem via UIActivityViewController using NSExtensionContext and NSItemProvider.",
        "why": "Handling incoming shared payloads requires asynchronous type identification and graceful error handling before the system cancels the extension context.",
        "model": "+---------------------------------------------------+\n| Source App (Safari / Photos)                      |\n|                      │ Passes                     |\n| NSExtensionContext.inputItems                     |\n|                      ▼                            |\n| NSItemProvider (Load Item: UTType.image / url)    |\n|                      │ Save to                    |\n| Shared App Group Storage Directory                |\n+---------------------------------------------------+",
        "minCode": "guard let item = extensionContext?.inputItems.first as? NSExtensionItem else { return }",
        "prodCode": """import UIKit
import Social
import UniformTypeIdentifiers

public final class RobustShareViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        extractSharedPayload()
    }

    private func extractSharedPayload() {
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
            completeRequest()
            return
        }

        for item in items {
            guard let attachments = item.attachments else { continue }
            for provider in attachments {
                if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] item, error in
                        if let url = item as? URL {
                            self?.saveSharedURL(url)
                        }
                        self?.completeRequest()
                    }
                    return
                }
            }
        }
        completeRequest()
    }

    private func saveSharedURL(_ url: URL) {
        // Save to shared App Group container for host app pickup
    }

    private func completeRequest() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}""",
        "hood": "NSExtensionContext acts as the IPC bridge between the source app and the extension process. Data is transferred via security-scoped bookmarks or serialized object buffers. Calling completeRequest signals the host UI that the operation is finished.",
        "prodEx": "Saving bookmarks to Pocket, sharing photos to Instagram, or forwarding links to Slack.",
        "perf": "Asynchronous loading via NSItemProvider prevents freezing the Share sheet.",
        "mem": "Large files should be streamed directly to App Group disk rather than loaded entirely into RAM.",
        "maint": "Requires updating Activation Rules in Info.plist to specify supported UTTypes.",
        "test": "Testable via Xcode by selecting the Share Extension scheme and targeting Safari as runner.",
        "comp": "Requires handling diverse item provider types (raw data, file URLs, UIImage objects).",
        "bad": "extensionContext?.completeRequest(returningItems: nil, completionHandler: nil) // Called before async loadItem finishes, killing the upload!",
        "good": "provider.loadItem(...) { item, error in /* Complete request inside callback */ }",
        "exp": "Calling completeRequest before asynchronous data extraction finishes causes the extension process to terminate prematurely.",
        "trap": "Forgetting to configure NSExtensionActivationRule in Info.plist; using TRUEPREDICATE passes development but causes App Store rejection.",
        "jq": "What is the role of NSItemProvider in a Share Extension?", "ja": "It provides asynchronous access to the data items (images, URLs, text) passed to the extension from the sharing app.",
        "sq": "Why does using NSExtensionActivationRule = TRUEPREDICATE cause App Store review rejection?", "sa": "Because TRUEPREDICATE is a debug flag that allows all data types. Apple requires explicit predicate rules defining exactly what UTTypes (images, URLs, text) the extension supports.",
        "pq": "How do you safely handle sharing large 100MB+ video files in a Share Extension with a 30MB memory limit?", "pa": "Request a security-scoped URL using provider.loadItem(forTypeIdentifier: UTType.movie.identifier), and stream the file directly into the shared App Group directory using FileManager.copyItem, avoiding loading video bytes into RAM.",
        "task": "Call extensionContext to dismiss the Share Extension indicating user cancellation.",
        "hint": "Use cancelRequest with NSError.",
        "sol": "extensionContext?.cancelRequest(withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError))"
    },
    (24, 4): {
        "quick": "App Groups allow a containing app and its extensions to share data by providing a shared security container directory on disk and a shared UserDefaults suite (UserDefaults(suiteName: 'group.com.app')).",
        "why": "Standard app sandboxes strictly isolate files; App Groups are the ONLY approved way to share local database files, caches, and user tokens across app and extension processes.",
        "model": "+---------------------------------------------------+\n| Host App Sandbox             Extension Sandbox     |\n| (Private Data)               (Private Data)        |\n|         │                           │              |\n|         └──► [ Shared App Group ] ◄─┘              |\n|              ├── group.com.app UserDefaults         |\n|              └── Shared SQLite / File Container    |\n+---------------------------------------------------+",
        "minCode": "let sharedDefaults = UserDefaults(suiteName: \"group.com.myapp\")\nlet containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: \"group.com.myapp\")",
        "prodCode": """import Foundation

public final class AppGroupDataManager: Sendable {
    public static let shared = AppGroupDataManager()
    private let appGroupID = "group.com.enterprise.app"

    public var sharedUserDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    public var sharedContainerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
    }

    public func saveAuthToken(_ token: String) {
        sharedUserDefaults?.set(token, forKey: "shared_auth_token")
    }

    public func readAuthToken() -> String? {
        sharedUserDefaults?.string(forKey: "shared_auth_token")
    }

    public func sharedDatabaseURL() -> URL? {
        sharedContainerURL?.appendingPathComponent("SharedDatabase.sqlite")
    }
}""",
        "hood": "App Groups use shared POSIX permissions on iOS. The kernel mounts the shared container folder under /private/var/mobile/Containers/Shared/AppGroup/<UUID>/, granting read/write permissions to all binaries sharing the same entitlement group ID.",
        "prodEx": "Sharing session authentication tokens between main app and WidgetKit widget to render logged-in account balance.",
        "perf": "Fast local filesystem I/O; avoid high-frequency simultaneous writes to prevent file locking contention.",
        "mem": "Files reside on disk; shared memory mapping (mmap) allows zero-copy reading.",
        "maint": "Requires matching App Group entitlement across both the app target and extension target in Xcode.",
        "test": "Verifiable by writing a value in app test and asserting value presence in extension test.",
        "comp": "Requires careful file coordination (NSFileCoordinator) when accessing shared SQLite databases simultaneously.",
        "bad": "UserDefaults.standard.set(token, forKey: \"auth\") // Extension cannot read standard defaults!",
        "good": "UserDefaults(suiteName: \"group.com.app\")?.set(token, forKey: \"auth\") // Shared across both processes!",
        "exp": "UserDefaults.standard is sandboxed to the host app process; extensions reading it get nil.",
        "trap": "Accessing a shared SQLite database from both app and extension without WAL (Write-Ahead Logging) mode, causing database lock crashes.",
        "jq": "How do you access a shared directory between an iOS app and its widget?", "ja": "By enabling App Groups in Signing & Capabilities and calling FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:).",
        "sq": "Why must you configure SQLite databases to use WAL (Write-Ahead Logging) mode when sharing them via App Groups?", "sa": "Because both the host app and extension processes can open the database simultaneously. WAL mode allows concurrent readers and a writer without deadlocking or locking errors.",
        "pq": "How do you implement atomic, race-free file sharing between an app and extension using NSFileCoordinator and NSFilePresenter?", "pa": "Wrap file mutations in NSFileCoordinator.coordinate(writingItemAt:options:error:byAccessor:). This notifies other processes via NSFilePresenter to suspend reading or release locks before the write executes.",
        "task": "Obtain the shared container URL for App Group 'group.org.handylearn'.",
        "hint": "Call FileManager.default.containerURL.",
        "sol": "FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: \"group.org.handylearn\")"
    },

    # =========================================================================
    # DOMAIN 28 & 29: Xcode Build System, .xcconfig & Compiler Optimization
    # =========================================================================
    (28, 1): {
        "quick": "An Xcode Workspace (.xcworkspace) contains multiple Projects (.xcodeproj). A Project contains Targets (individual build products like .app, .framework, .appex). Schemes define the build/test/run configurations applied to targets.",
        "why": "Understanding workspace vs project hierarchy is essential for enterprise modularization, multi-repo integration, and reproducible CI build pipelines.",
        "model": "+---------------------------------------------------+\n| Xcode Workspace (.xcworkspace)                   |\n| ├── CoreData.xcodeproj (Library Target)           |\n| ├── NetworkEngine.xcodeproj (Framework Target)    |\n| └── MainApp.xcodeproj                             |\n|       ├── MainApp Target (.app)                   |\n|       ├── Widget Target (.appex)                  |\n|       └── Schemes: Dev, Staging, Production       |\n+---------------------------------------------------+",
        "minCode": "// Schemes map Build Configurations (Debug/Release) to Actions (Run, Test, Archive)",
        "prodCode": """// Fastfile demonstrating scheme-driven automated builds
platform :ios do
  desc "Build and sign enterprise flavor"
  lane :build_staging do
    build_app(
      workspace: "HandyLearn.xcworkspace",
      scheme: "HandyLearn-Staging",
      configuration: "Staging-Debug",
      export_method: "enterprise",
      output_directory: "./build/staging"
    )
  end
end""",
        "hood": "Xcode uses PBXProject serialization within project.pbxproj. The build system evaluates dependency graphs across targets defined in the active Scheme, executing parallel compilations when targets lack direct dependencies.",
        "prodEx": "Large scale modular architectures (Uber, Airbnb) with 100+ separate xcodeproj targets inside a single workspace.",
        "perf": "Independent targets compile concurrently utilizing all available Apple Silicon CPU cores.",
        "mem": "Reduces incremental build times by caching compiled target artifacts in DerivedData.",
        "maint": "Separates concerns; allows teams to work on isolated feature projects without touching the main project file.",
        "test": "Schemes allow configuring specific test suites and code coverage targets.",
        "comp": "Requires careful management of project references to avoid duplicate symbol errors.",
        "bad": "Putting all 500 source files into a single monolithic Target in one Project",
        "good": "Partition into modular Targets grouped cleanly inside an Xcode Workspace",
        "exp": "Monolithic targets destroy incremental build times because any file change triggers large rebuild cascades.",
        "trap": "Committing user-specific scheme files (*.xcscheme in xcuserdata) rather than sharing them in xcshareddata.",
        "jq": "What is the difference between a Target and a Scheme in Xcode?", "ja": "A Target specifies the product to build (app, test, extension) and its source files; a Scheme defines what happens when you build, test, or run those targets.",
        "sq": "Why should Xcode Schemes always be marked as 'Shared' in source control?", "sa": "Unshared schemes reside in the user's xcuserdata directory and are ignored by git. Marking them Shared moves them to xcshareddata so CI servers and teammates can build them.",
        "pq": "How does Xcode's New Build System resolve target dependencies and optimize parallel build execution?", "pa": "It constructs a directed acyclic graph (DAG) of target dependencies, determines which modules can build in parallel based on output interface files, and executes tasks using low-level llbuild without blocking independent branches.",
        "task": "State the folder path where shared schemes are stored in an .xcodeproj.",
        "hint": "Inside xcshareddata.",
        "sol": "ProjectName.xcodeproj/xcshareddata/xcschemes/"
    },
    (28, 2): {
        "quick": ".xcconfig files are plain-text build configuration files that externalize Xcode build settings, enabling version-controlled inheritance trees (#include), multi-environment flavoring, and zero merge conflicts.",
        "why": "Storing build settings inside project.pbxproj causes constant git merge conflicts and breaks CI flavoring; .xcconfig files provide clean, declarative configuration.",
        "model": "+---------------------------------------------------+\n| Base.xcconfig (Shared SDK versions & warnings)    |\n|       ▲                                           |\n|       ├── Debug.xcconfig (#include \"Base.xcconfig\")|\n|       └── Release.xcconfig                        |\n|             ▲                                     |\n|             └── Production.xcconfig               |\n+---------------------------------------------------+",
        "minCode": "// Debug.xcconfig\n#include \"Base.xcconfig\"\nSWIFT_OPTIMIZATION_LEVEL = -Onone\nPRODUCT_BUNDLE_IDENTIFIER = com.app.dev",
        "prodCode": """// Configurations/Base.xcconfig
SWIFT_VERSION = 5.0
IPHONEOS_DEPLOYMENT_TARGET = 16.0
ENABLE_USER_SCRIPT_SANDBOXING = YES
GCC_TREAT_WARNINGS_AS_ERRORS = YES

// Configurations/Production.xcconfig
#include "Base.xcconfig"
SWIFT_OPTIMIZATION_LEVEL = -O
SWIFT_COMPILATION_MODE = wholemodule
PRODUCT_NAME = HandyLearn
PRODUCT_BUNDLE_IDENTIFIER = com.enterprise.handylearn
APP_BACKEND_URL = https://api.handylearn.com
SLASH = /

// Usage in Swift via Info.plist macro expansion:
// BackendURL = $(APP_BACKEND_URL)""",
        "hood": "Xcode evaluates build settings using a strict priority cascade: 1. Command-line args (xcodebuild), 2. Target PBX attributes, 3. Target .xcconfig, 4. Project PBX attributes, 5. Project .xcconfig, 6. Xcode defaults.",
        "prodEx": "Industry standard for managing multi-environment builds (Dev, QA, Staging, Prod) across Spotify and Square.",
        "perf": "Zero runtime impact; eliminates build setting pollution in Xcode project files.",
        "mem": "Zero memory footprint.",
        "maint": "Eliminates 90% of pbxproj git conflicts because developers never edit target settings in Xcode GUI.",
        "test": "Verify via 'xcodebuild -showBuildSettings -configuration Staging'.",
        "comp": "Requires escaping slashes in URLs using $(SLASH) to prevent comment syntax parsing.",
        "bad": "Hardcoding backend URLs and bundle IDs manually inside Project Build Settings GUI",
        "good": "Externalize all environment settings into modular .xcconfig files using #include inheritance",
        "exp": "Editing settings in the Xcode GUI alters project.pbxproj directly, leading to catastrophic git merge conflicts across large teams.",
        "trap": "Writing URLs like https://api.com in .xcconfig without escaping; // is treated as a comment and truncates the string!",
        "jq": "What is the primary benefit of using .xcconfig files in iOS projects?", "ja": "They decouple build settings from the binary project.pbxproj file, preventing git merge conflicts and enabling clean configuration inheritance.",
        "sq": "How do you escape double slashes (//) in an .xcconfig file when defining a URL string?", "sa": "Define a variable like SLASH = / and write https:${SLASH}/api.domain.com, or use backslash escaping, because // is parsed as the start of a comment.",
        "pq": "Explain Xcode's 6-level build setting evaluation precedence hierarchy.", "pa": "Precedence from highest to lowest: 1. Command-line overrides (xcodebuild KEY=VAL), 2. Target-level PBX settings, 3. Target-level .xcconfig, 4. Project-level PBX settings, 5. Project-level .xcconfig, 6. Apple platform default settings.",
        "task": "Write an .xcconfig directive to include a shared configuration file named Common.xcconfig.",
        "hint": "Use #include.",
        "sol": "#include \"Common.xcconfig\""
    },
    (28, 3): {
        "quick": "Swift compilation modes (-Onone vs -O, Whole Module Optimization vs Incremental) and Link-Time Optimization (LTO) dramatically alter compilation speed, binary size, and runtime execution performance.",
        "why": "Using Whole Module Optimization (WMO) in Release allows the compiler to devirtualize generic calls and inline functions across files, boosting app speed by up to 40%.",
        "model": "+---------------------------------------------------+\n| Incremental (-Onone): Compile File by File (Fast) |\n|                                                   |\n| Whole Module Optimization (-O -wmo):              |\n| Analyze ALL files simultaneously ──► Devirtualize |\n| Inlines cross-file functions ──► High Performance  |\n+---------------------------------------------------+",
        "minCode": "// Release configuration: SWIFT_COMPILATION_MODE = wholemodule",
        "prodCode": """// Build settings for production release optimization
SWIFT_COMPILATION_MODE = wholemodule
SWIFT_OPTIMIZATION_LEVEL = -O
LLVM_LTO = full
DEAD_CODE_STRIPPING = YES
STRIP_INSTALLED_PRODUCT = YES
DEPLOYMENT_POSTPROCESSING = YES""",
        "hood": "Under Whole Module Optimization, the compiler analyzes all Swift files in a module as a single LLVM compilation unit. It identifies all concrete conformances of protocols and final classes, converting indirect vtable and witness table dispatches into direct assembly branch instructions or inlined code.",
        "prodEx": "High-frequency trading apps, game engines, and performance-critical UI rendering engines.",
        "perf": "WMO + LTO reduces binary execution time significantly; increases release build time.",
        "mem": "Inlining reduces function call stack frame overhead.",
        "maint": "Debug builds should use Single File / Incremental mode to keep developer iteration cycles fast.",
        "test": "Benchmarked via XCTest measureBlock comparing Debug vs Release build schemes.",
        "comp": "Requires balancing build times in CI vs runtime execution performance.",
        "bad": "Setting SWIFT_COMPILATION_MODE = wholemodule in Debug configuration! (Destroys local compile speed!)",
        "good": "Debug: SWIFT_COMPILATION_MODE = incremental; Release: SWIFT_COMPILATION_MODE = wholemodule",
        "exp": "Enabling WMO in Debug forces the compiler to re-analyze every file on every keystroke, drastically slowing local development.",
        "trap": "Assuming compiler optimizations are enabled in Debug; running performance benchmarks on Debug builds yields invalid metrics.",
        "jq": "What is Whole Module Optimization (WMO) in Swift?", "ja": "A compilation mode where the compiler evaluates all files in a module at once, allowing cross-file function inlining and generic devirtualization.",
        "sq": "Why should you never enable Whole Module Optimization for Debug builds?", "sa": "Because WMO eliminates incremental compilation; modifying a single line of code forces the entire module to recompile, crippling developer iteration speed.",
        "pq": "How does Link-Time Optimization (LTO) differ from Whole Module Optimization?", "pa": "WMO operates at the Swift module level before code generation. LTO operates at the LLVM linker level across different C/C++/Objective-C and Swift modules, inlining code and stripping dead functions across framework boundaries.",
        "task": "Set the build setting key that enables full Link-Time Optimization.",
        "hint": "Check LLVM_LTO build setting.",
        "sol": "LLVM_LTO = full"
    },
    (28, 4): {
        "quick": "dSYM (Debug Symbol) files store the mapping between compiled machine memory addresses and human-readable source code files, line numbers, and function names. Crash symbolication translates raw stack traces into actionable diagnostics.",
        "why": "Without dSYMs matching the exact build UUID, production crashes appear as meaningless hex addresses (e.g. 0x000000010432a9fc), blinding engineering teams during outages.",
        "model": "+---------------------------------------------------+\n| Unsymbolicated Crash:                             |\n| 0x1042a9b4 0x104000000 + 2793812                  |\n|                      │ + dSYM (UUID Match)        |\n|                      ▼ atos / dwarf info          |\n| Symbolicated Crash:                               |\n| UserService.swift:42 - [UserService fetchUser()] |\n+---------------------------------------------------+",
        "minCode": "atos -arch arm64 -o MyApp.app.dSYM/Contents/Resources/DWARF/MyApp -l 0x104000000 0x1042a9b4",
        "prodCode": """#!/bin/bash
# Symbolication helper script for production crash triage
CRASH_ADDRESS="0x00000001042a9b4"
LOAD_ADDRESS="0x000000010400000"
DSYM_PATH="./HandyLearn.app.dSYM/Contents/Resources/DWARF/HandyLearn"

# Verify UUID match between crash report and dSYM
dwarfdump --uuid "$DSYM_PATH"

# Symbolicate address to source file and line number
atos -arch arm64 -o "$DSYM_PATH" -l "$LOAD_ADDRESS" "$CRASH_ADDRESS" """,
        "hood": "The compiler emits DWARF debug symbols. The dsymutil tool extracts these symbols into a separate .dSYM bundle before binary stripping removes symbol names from the shipped binary to save space. Each binary and dSYM pair shares an identical 128-bit UUID.",
        "prodEx": "Crashlytics, Sentry, Datadog, and Apple Xcode Organizer crash reporting pipelines.",
        "perf": "Zero app runtime impact; symbols are stripped completely from the shipped App Store binary.",
        "mem": "Reduces shipped app download size by dozens of megabytes.",
        "maint": "CI must upload dSYMs to crash reporting providers on every release archive.",
        "test": "Verify dSYM UUID matches binary via: dwarfdump --uuid MyApp.app/MyApp.",
        "comp": "Requires Bitcode/App Store stripped dSYM downloads when Apple generates the final build.",
        "bad": "Stripping symbols without archiving dSYMs; production crashes become permanently unrecoverable hex numbers!",
        "good": "Archive dSYMs to S3 or crash reporter automatically in fastlane/CI release lanes",
        "exp": "If dSYM files are discarded during build, crashes from production users can never be mapped back to code lines.",
        "trap": "Attempting to symbolicate a crash using a dSYM with a mismatched UUID; atos will output incorrect or empty symbols.",
        "jq": "What is a dSYM file in iOS development?", "ja": "A Debug Symbol file that maps compiled memory addresses to original source code file names, method names, and line numbers.",
        "sq": "What CLI tool is used to manually translate a memory address from a crash log into source code using a dSYM?", "sa": "The 'atos' (address-to-symbol) command-line utility, or dwarfdump.",
        "pq": "How do you verify whether a given dSYM file matches a specific crash log received from a production user?", "pa": "Run 'dwarfdump --uuid PathTo.dSYM' to extract the dSYM's UUID. Check the 'Binary Images' section at the bottom of the crash report to find the app's UUID. If the two 128-bit hex UUID strings match exactly, symbolication will succeed.",
        "task": "Write the command to check the UUID of a dSYM file.",
        "hint": "Use dwarfdump with the uuid flag.",
        "sol": "dwarfdump --uuid MyApp.app.dSYM"
    },

    # =========================================================================
    # DOMAIN 30: App Size Optimization, App Thinning, Slicing & ODR
    # =========================================================================
    (30, 1): {
        "quick": "App Thinning combines three distinct Apple technologies: App Slicing (serving only device-specific executable architectures and 2x/3x assets), Bitcode (historic), and On-Demand Resources (ODR).",
        "why": "Keeping the initial download size below Apple's cellular download threshold (200MB) directly boosts App Store conversion rates and user retention.",
        "model": "+---------------------------------------------------+\n| Universal App Bundle (Developer Upload: 150MB)     |\n|                      │ App Store Slicing          |\n|                      ▼                            |\n| iPhone 16 Pro Slice: Only ARM64e + 3x Assets (55MB)|\n| iPhone SE Slice:     Only ARM64  + 2x Assets (42MB)|\n+---------------------------------------------------+",
        "minCode": "// Place assets in Assets.xcassets to enable automatic Apple App Slicing",
        "prodCode": """// App Size Audit and Asset Scale Optimization Blueprint
// In Build Phases: Run Script for Asset Validation
# Verify that loose images outside asset catalogs are prohibited
find "$SRCROOT" -name "*.png" -not -path "*/Assets.xcassets/*" | while read -r image; do
    echo "warning: Image $image is not inside an Asset Catalog! App Slicing will not optimize it."
done""",
        "hood": "Asset catalogs are compiled by actool into an optimized Assets.car file. The App Store generates tailored device variants based on device hardware descriptors, slicing out irrelevant @2x or @3x images and vector assets.",
        "prodEx": "Global scale consumer apps (Uber, Airbnb, TikTok) targeting diverse global bandwidth markets.",
        "perf": "Faster app install and update download times; reduces user cellular data consumption.",
        "mem": "Smaller binary foot-print loaded into device RAM during launch.",
        "maint": "Zero code changes required; simply migrating loose bundle images into Assets.xcassets enables slicing.",
        "test": "Verify thinning via: xcodebuild -exportArchive with exportOptions.plist specifying compileBitcode and thinning.",
        "comp": "Requires placing all visual assets into xcassets rather than loose folder references.",
        "bad": "Adding 100MB of raw PNGs directly into the Copy Bundle Resources phase outside asset catalogs!",
        "good": "Store all graphics inside Assets.xcassets so Apple's actool automatically slices by device scale",
        "exp": "Loose images in the app bundle cannot be sliced by the App Store; every device downloads all @1x, @2x, and @3x assets.",
        "trap": "Believing PDF vector images in Asset Catalogs automatically scale; unless 'Preserve Vector Data' is unchecked, raster slices are generated.",
        "jq": "What are the two active components of Apple's App Thinning?", "ja": "App Slicing (device-specific assets and binary slicing) and On-Demand Resources (ODR).",
        "sq": "Why should you always place images inside Assets.xcassets rather than loose in the bundle?", "sa": "Because Apple's App Slicing only optimizes and strips assets stored inside Asset Catalogs. Loose bundle files are delivered universally to all devices, bloating download size.",
        "pq": "How do you generate an App Thinning Size Report in Xcode to evaluate compressed vs uncompressed install sizes?", "pa": "Create an archive, export with exportOptions.plist containing '<key>thinning</key><string>&lt;all-devices&gt;</string>'. Xcode outputs an 'App Thinning Size Report.txt' detailing download and install sizes for every iOS device model.",
        "task": "State the asset catalog compiler tool used by Xcode.",
        "hint": "Command line tool starts with ac.",
        "sol": "actool"
    },
    (30, 2): {
        "quick": "Dead code stripping removes unused functions, symbols, and unreferenced classes at link time. Link Map analysis inspects the exact byte contribution of every class, object file, and third-party library.",
        "why": "Unused legacy code, unreferenced third-party libraries, and debug logging strings silently bloat binary size, directly increasing app launch latency.",
        "model": "+---------------------------------------------------+\n| Source Code & Frameworks                          |\n|                      │ Compiler / Linker          |\n|                      ▼                            |\n| Dead Code Stripping (DEAD_CODE_STRIPPING = YES)   |\n|                      │ Removes unused symbols     |\n| Shipped Mach-O Binary (Lean & Fast Launch)         |\n+---------------------------------------------------+",
        "minCode": "// Build Setting:\nDEAD_CODE_STRIPPING = YES\nLD_GENERATE_MAP_FILE = YES",
        "prodCode": """// Python link map analyzer snippet to find top binary bloat culprits
# Run after building with LD_GENERATE_MAP_FILE = YES
# Path: $(DERIVED_DATA)/Build/Products/Debug-iphoneos/MyApp-LinkMap.txt

# Link map contains 3 sections:
# 1. # Object files: List of all .o files and libraries
# 2. # Sections: Memory address segments (__TEXT, __DATA)
# 3. # Symbols: Individual functions and their byte sizes in hex""",
        "hood": "The static linker (ld64) reads the symbol graph. Starting from entry points (main, @main), it marks referenced symbols. Unmarked functions and static data blocks are discarded if DEAD_CODE_STRIPPING is enabled, unless marked with __attribute__((used)).",
        "prodEx": "Quarterly app size reduction sprints at Meta, Uber, and Netflix saving tens of megabytes.",
        "perf": "Smaller Mach-O __TEXT segment allows dyld to map pages faster during pre-main launch.",
        "mem": "Less memory mapped from disk into physical RAM pages.",
        "maint": "Eliminates dead deadweight code across legacy refactors.",
        "test": "Analyze output using tools like LinkMap-Reader or bloaty.",
        "comp": "Requires caution with Objective-C dynamic runtime classes which can be stripped if not referenced statically.",
        "bad": "DEAD_CODE_STRIPPING = NO in Release build settings",
        "good": "DEAD_CODE_STRIPPING = YES and LD_GENERATE_MAP_FILE = YES to monitor symbol sizes",
        "exp": "Disabling dead code stripping forces the linker to include every compiled function, even those never called.",
        "trap": "Stripping needed Objective-C classes that are loaded purely via NSClassFromString; requires -ObjC linker flag or explicit references.",
        "jq": "What does Dead Code Stripping do during the Xcode build?", "ja": "It instructs the linker to remove unreferenced code and data symbols from the final executable binary.",
        "sq": "How does generating a Link Map file help in iOS app size optimization?", "sa": "A Link Map reveals the exact byte size of every object file, class, and method compiled into the Mach-O binary, highlighting which dependencies contribute the most bloat.",
        "pq": "Why can Dead Code Stripping inadvertently strip Objective-C classes, and how do you protect them?", "pa": "Because Objective-C uses dynamic message passing, classes accessed only via runtime reflection (NSClassFromString) have no static references in the AST. The linker assumes they are unused and strips them. Protect them using the -ObjC or -force_load linker flags or @objc attribute.",
        "task": "Set the Xcode build setting key to generate a Link Map file.",
        "hint": "Build setting starts with LD_GENERATE...",
        "sol": "LD_GENERATE_MAP_FILE = YES"
    },
    (30, 3): {
        "quick": "On-Demand Resources (ODR) host secondary assets (game levels, tutorial videos, rarely accessed themes) on Apple's App Store servers, downloading them lazily in the background when requested via NSBundleResourceRequest.",
        "why": "ODR allows apps with gigabytes of total assets to maintain an initial App Store download size under 50MB, downloading heavy assets only when the user unlocks that feature.",
        "model": "+---------------------------------------------------+\n| Initial App Store Download (< 50MB)               |\n|                      │ User navigates to Level 5   |\n| NSBundleResourceRequest(tags: [\"level5\"])         |\n|                      ▼ Downloads from Apple CDN    |\n| Asset unlocked in RAM/Disk ──► Render Feature      |\n| Resources Purged automatically under low disk      |\n+---------------------------------------------------+",
        "minCode": "let request = NSBundleResourceRequest(tags: [\"level2\"])\ntry await request.beginAccessingResources()\n// Access assets, then request.endAccessingResources()",
        "prodCode": """import Foundation

public final class OnDemandAssetCoordinator: Sendable {
    public static let shared = OnDemandAssetCoordinator()

    public func loadFeatureAssets(tag: String) async throws {
        let resourceRequest = NSBundleResourceRequest(tags: [tag])
        resourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent

        // Check if resource is already cached locally
        let isAvailable = await resourceRequest.conditionallyBeginAccessingResources()
        if isAvailable {
            return // Assets already on disk!
        }

        // Download assets from Apple CDN
        try await resourceRequest.beginAccessingResources()
    }

    public func releaseAssets(for tag: String) {
        // Releases access; system may purge assets if device is low on storage
    }
}""",
        "hood": "Apple hosts ODR packages on the App Store CDN. When beginAccessingResources is called, the OS downloads the asset pack to the device cache directory. If device storage is low, the OS automatically purges un-accessed ODR assets.",
        "prodEx": "Games downloading subsequent levels, education apps downloading voice packs, and e-commerce apps downloading seasonal themes.",
        "perf": "Dramatically faster initial app installation; keeps app bundle lean.",
        "mem": "Downloaded assets reside in managed caches, avoiding active RAM bloat.",
        "maint": "Requires tagging assets in Xcode File Inspector under 'Resource Tags'.",
        "test": "Tested in development using Xcode local ODR simulation server.",
        "comp": "Requires graceful network error handling if user is offline when requesting new resources.",
        "bad": "Packaging 300MB of tutorial video files directly in the main app bundle!",
        "good": "Tag tutorial videos with 'intro_tutorial' ODR tag and download lazily on first launch",
        "exp": "Bundling large static videos in the app binary balloons the initial download size and hurts App Store conversion.",
        "trap": "Forgetting to call endAccessingResources(); the system cannot purge cached assets if the access count remains positive.",
        "jq": "What is the purpose of On-Demand Resources (ODR) in iOS?", "ja": "To host secondary assets on Apple servers and download them on demand, keeping the initial app download size small.",
        "sq": "How does the iOS operating system handle On-Demand Resources when a device runs low on local storage?", "sa": "The OS automatically purges un-accessed or released ODR asset packs from the device cache to reclaim space, re-downloading them only when requested again.",
        "pq": "How do you handle offline scenarios when an on-demand asset is requested by a user without an active internet connection?", "pa": "Call conditionallyBeginAccessingResources() first to verify if the asset is already cached locally. If false and network connectivity is unavailable, fail gracefully with an offline explanation and offer to retry when connected.",
        "task": "Call the method that checks if an on-demand resource is already available locally without downloading.",
        "hint": "Check conditionallyBeginAccessingResources.",
        "sol": "await resourceRequest.conditionallyBeginAccessingResources()"
    },
    (30, 4): {
        "quick": "Pre-main launch time optimization focuses on accelerating dyld (dynamic linker) execution before main() is reached by minimizing dynamic framework linking, reducing ObjC class counts, eliminating +load methods, and optimizing Page In faults.",
        "why": "Users perceive slow launch times (>400ms) as poor quality, and the system Watchdog terminates apps taking >20 seconds to launch.",
        "model": "+---------------------------------------------------+\n| Pre-Main Phase (dyld4 Execution):                 |\n| 1. dylib Loading (Mach-O parsing)                 |\n| 2. Rebasing & Binding (ASLR pointer fixups)       |\n| 3. ObjC Runtime Setup (Class registration)        |\n| 4. Initializers (+load & C++ static ctors)        |\n|                      ▼                            |\n| main() ──► UIApplicationMain ──► First Frame Render|\n+---------------------------------------------------+",
        "minCode": "// Environment variable to profile pre-main time: DYLD_PRINT_STATISTICS = 1",
        "prodCode": """// Swift launch optimization: Replace synchronous +load with deferred tasks
import UIKit

// BAD: +load runs before main() synchronously on the main thread!
// GOOD: Swift initializers executed lazily upon first access or on background task

public final class AppLaunchOptimizer {
    @MainActor
    public static func schedulePostLaunchWarmup() {
        // Defer non-critical analytics and SDK warmups until after first frame renders
        RunLoop.main.perform(inModes: [.default]) {
            initializeSecondarySDKs()
        }
    }

    private static func initializeSecondarySDKs() {
        // Analytics, crashlytics secondary logging, pre-fetching caches
    }
}""",
        "hood": "In dyld4, Apple uses pre-computed launch closures cached on disk to accelerate launch. The dynamic linker must rebase pointers (adjusting addresses due to ASLR - Address Space Layout Randomization) and bind external symbols. Dynamic frameworks require individual Mach-O header parsing; static libraries merge directly into the main binary.",
        "prodEx": "Optimizing launch times across all tier-1 iOS apps to achieve sub-400ms cold start.",
        "perf": "Converting dynamic frameworks to static frameworks cuts pre-main launch time in half.",
        "mem": "Minimizes initial page faults during cold startup.",
        "maint": "Eliminates legacy Objective-C +load methods and heavy static C++ constructors.",
        "test": "Profiled via Instruments 'App Launch' template or DYLD_PRINT_STATISTICS in Xcode Scheme.",
        "comp": "Requires balancing static framework duplicate symbol risks against dynamic framework link speed.",
        "bad": "Adding 30 dynamic third-party frameworks and multiple +load methods across ObjC classes",
        "good": "Merge dependencies into Static Libraries (SPM) and defer SDK warmups until after first frame",
        "exp": "Each dynamic framework requires dyld to parse Mach-O headers and fixup pointers, severely delaying cold launch.",
        "trap": "Placing heavy initialization or synchronous disk I/O inside application:didFinishLaunchingWithOptions:.",
        "jq": "What environment variable can you enable in Xcode to inspect pre-main launch time breakdown?", "ja": "DYLD_PRINT_STATISTICS = 1 (or DYLD_PRINT_STATISTICS_DETAILS = 1).",
        "sq": "Why are static libraries faster for app launch time compared to dynamic frameworks?", "sa": "Because static libraries are merged into the main app binary at compile time, eliminating the need for dyld to locate, load, rebase, and bind separate Mach-O binaries at launch.",
        "pq": "Explain what dyld does during the 'Rebasing' and 'Binding' phases of pre-main launch.", "pa": "Rebasing adjusts internal pointers to account for Address Space Layout Randomization (ASLR) slide. Binding resolves external pointers that reference symbols in outside dynamic libraries (like Foundation or UIKit) by looking up their runtime addresses.",
        "task": "Set the scheme environment variable to print dyld launch timing statistics.",
        "hint": "DYLD_PRINT_STATISTICS.",
        "sol": "DYLD_PRINT_STATISTICS = 1"
    }
}
