import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/screens/authentication/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(pages: [
        OnboardingPageModel(
          title: 'Chào mừng đã đến với Eventify',
          description: 'Ứng dụng quản lý sự kiện, tiện ích, dễ dàng sử dụng !',
          imageUrl: "assets/welcome_page/welcome_Image_1.png",
          bgColor: const Color(0xff1eb090),
        ),
        OnboardingPageModel(
          title: 'Quản lý sự kiện, báo cáo, tiến độ,..',
          description: 'Và còn hơn thế nữa !',
          imageUrl: "assets/welcome_page/welcome_Image_2.png",
          bgColor: const Color(0xfffeae4f),
        ),
        OnboardingPageModel(
          title: 'Bạn đã sẵn sàng ?',
          description: 'Bắt đầu tạo sự kiện nào !!!',
          imageUrl: "assets/welcome_page/welcome_Image_3.png",
          bgColor: Colors.blue.shade200,
        ),
      ],
       onFinish: () async {
          // Save seen state to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('alreadySeenWelcome', true);

          // Navigate to appropriate screen
          // RouterService().goToIndexScreen(context); 
        },
      ),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {Key? key, required this.pages, this.onSkip, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);
  final RouterService routerService = RouterService();

  void _navigateToNextScreen(BuildContext context) {
    // routerService.goToIndexScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Image.asset(
                              item.imageUrl,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(item.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: item.textColor,
                                        )),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: Text(item.description,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: item.textColor,
                                        )),
                              )
                            ]))
                      ],
                    );
                  },
                ),
              ),

              // Current page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map((item) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _currentPage == widget.pages.indexOf(item)
                              ? 30
                              : 8,
                          height: 8,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                        ))
                    .toList(),
              ),

              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            visualDensity: VisualDensity.comfortable,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          // widget.onSkip?.call();
                          _navigateToNextScreen(context);
                        },
                        child: const Text("Bỏ qua")),
                    TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        if (_currentPage == widget.pages.length - 1) {
                          // widget.onFinish?.call();
                          _navigateToNextScreen(context);
                        } else {
                          _pageController.animateToPage(_currentPage + 1,
                              curve: Curves.easeInOutCubic,
                              duration: const Duration(milliseconds: 250));
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == widget.pages.length - 1
                                ? "Hoàn tất"
                                : "Tiếp theo",
                          ),
                          const SizedBox(width: 8),
                          Icon(_currentPage == widget.pages.length - 1
                              ? Icons.done
                              : Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      this.bgColor = Colors.blue,
      this.textColor = Colors.white});
}
