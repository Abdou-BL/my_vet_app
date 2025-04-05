import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with AutomaticKeepAliveClientMixin<AIScreen> {
  late InAppWebViewController _webViewController;
  bool _isError = false;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          // WebView
          if (!_isError)
            InAppWebView(
              key: const PageStorageKey<String>('aiWebView'),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  mediaPlaybackRequiresUserGesture: false,
                  cacheEnabled: true,
                ),
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
              ),
              initialUrlRequest: URLRequest(
                url: WebUri('https://test-ai-1--vetvet.on.websim.ai'),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                  _isError = false;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  _isLoading = false;
                });
                await _hideLogo();
              },
              onLoadError: (controller, url, code, message) {
                setState(() {
                  _isError = true;
                  _isLoading = false;
                });
              },
              onReceivedError: (controller, request, error) {
                setState(() {
                  _isError = true;
                  _isLoading = false;
                });
              },
            ),
          
          // Error View
          if (_isError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Failed.png'), // Replace with your image path
                  const SizedBox(height: 20),
                  const Text(
                    'Failed to load content',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _refreshPage,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          
          // Loading Indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      _isError = false;
      _isLoading = true;
    });
    await _webViewController.reload();
  }

  Future<void> _hideLogo() async {
    try {
      await _webViewController.evaluateJavascript(source: """
        // Your existing hideLogo function
        function hideLogo() {
          const logo = document.querySelector('#websim-logo-container');
          if (logo) {
            logo.style.display = 'none';
            return true;
          }
          const elements = document.querySelectorAll('*');
          for (let i = 0; i < elements.length; i++) {
            if (elements[i].shadowRoot) {
              const shadowLogo = elements[i].shadowRoot.querySelector('#websim-logo-container');
              if (shadowLogo) {
                shadowLogo.style.display = 'none';
                return true;
              }
            }
          }
          return false;
        }
        
        if (!hideLogo()) {
          const interval = setInterval(() => {
            if (hideLogo()) {
              clearInterval(interval);
            }
          }, 1000);
          setTimeout(() => clearInterval(interval), 5000);
        }
      """);
    } catch (e) {
      debugPrint("Error hiding logo: \$e");
    }
  }
}
