import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onNavigateHome;
  final VoidCallback onNavigateLogin;

  final String appName;
  final String appSubtitle;
  final String tagline;
  final String taglineHighlight;
  final String poweredByText;

  final int minimumSplashMs;

  const SplashScreen({
    super.key,
    required this.onNavigateHome,
    required this.onNavigateLogin,
    this.appName = 'FuturePath',
    this.appSubtitle = 'EMPLOYMENT HUB',
    this.tagline = 'Building Skills. ',
    this.taglineHighlight = 'Creating Opportunities.',
    this.poweredByText = 'Powered by Department of Labour & Employment',
    this.minimumSplashMs = 1500,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late Stream<int> _dotStream;
  late StreamSubscription<int> _dotSubscription;

  int _activeDot = 0;


  @override
  void initState() {
    super.initState();


    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );


    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );


    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutBack,
      ),
    );


    _fadeController.forward();


    _dotStream = Stream.periodic(
      const Duration(milliseconds: 400),
          (tick) => tick % 3,
    );


    _dotSubscription = _dotStream.listen((dot) {

      if (mounted) {
        setState(() {
          _activeDot = dot;
        });
      }

    });


    _checkAuthAndNavigate();
  }



  Future<void> _checkAuthAndNavigate() async {

    final minimumDelay = Future.delayed(
      Duration(
        milliseconds: widget.minimumSplashMs,
      ),
    );


    final prefs = await SharedPreferences.getInstance();


    final hasSession =
        prefs.getString('session_token') != null;


    await minimumDelay;


    if (!mounted) return;


    if (hasSession) {

      widget.onNavigateHome();

    } else {

      widget.onNavigateLogin();

    }
  }



  @override
  void dispose() {

    _dotSubscription.cancel();

    _fadeController.dispose();

    super.dispose();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppTheme.primary,

      body: SafeArea(

        child: FadeTransition(

          opacity: _fadeAnimation,

          child: Column(

            children: [


              Expanded(

                flex: 5,

                child: Column(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [


                    ScaleTransition(

                      scale: _scaleAnimation,

                      child: const _AppIconWidget(),

                    ),


                    const SizedBox(height: 24),



                    _WordmarkWidget(

                      appName: widget.appName,

                      appSubtitle: widget.appSubtitle,

                    ),



                    const SizedBox(height: 32),



                    _TaglineWidget(

                      tagline: widget.tagline,

                      highlight: widget.taglineHighlight,

                    ),

                  ],

                ),

              ),




              Expanded(

                flex: 4,

                child: Padding(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),

                  child: const _BarChartIllustration(),

                ),

              ),





              Expanded(

                flex: 2,

                child: Column(

                  mainAxisAlignment:
                  MainAxisAlignment.end,

                  children: [


                    _DotsIndicator(
                      activeDot: _activeDot,
                    ),


                    const SizedBox(height: 24),


                    _PoweredByWidget(
                      text: widget.poweredByText,
                    ),


                    const SizedBox(height: 24),

                  ],

                ),

              ),


            ],

          ),

        ),

      ),

    );

  }

}






class _AppIconWidget extends StatelessWidget {

  const _AppIconWidget();


  @override
  Widget build(BuildContext context) {

    return Container(

      width: 110,

      height: 110,

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(24),

      ),


      child: const Icon(

        Icons.work_outline,

        size: 60,

        color: Colors.blue,

      ),

    );

  }

}






class _WordmarkWidget extends StatelessWidget {

  final String appName;

  final String appSubtitle;


  const _WordmarkWidget({

    required this.appName,

    required this.appSubtitle,

  });



  @override
  Widget build(BuildContext context) {

    return Column(

      children: [


        Text(

          appName,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 36,

            fontWeight:
            FontWeight.bold,

          ),

        ),



        const SizedBox(height: 4),



        Text(

          appSubtitle,

          style: const TextStyle(

            color: Colors.white70,

            fontSize: 14,

            letterSpacing: 3,

          ),

        ),

      ],

    );

  }

}






class _TaglineWidget extends StatelessWidget {

  final String tagline;

  final String highlight;



  const _TaglineWidget({

    required this.tagline,

    required this.highlight,

  });



  @override
  Widget build(BuildContext context) {

    return RichText(

      textAlign: TextAlign.center,

      text: TextSpan(

        style: const TextStyle(

          color: Colors.white,

          fontSize: 20,

        ),


        children: [


          TextSpan(

            text: tagline,

          ),



          TextSpan(

            text: highlight,

            style: const TextStyle(

              fontWeight:
              FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }

}







class _BarChartIllustration extends StatelessWidget {

  const _BarChartIllustration();



  @override
  Widget build(BuildContext context) {

    return Center(

      child: Icon(

        Icons.bar_chart_rounded,

        size: 140,

        color:
        Colors.white.withOpacity(0.8),

      ),

    );

  }

}







class _DotsIndicator extends StatelessWidget {

  final int activeDot;


  const _DotsIndicator({

    required this.activeDot,

  });



  @override
  Widget build(BuildContext context) {

    return Row(

      mainAxisAlignment:
      MainAxisAlignment.center,


      children: List.generate(

        3,

            (index) {


          return Container(

            margin:
            const EdgeInsets.symmetric(
              horizontal: 5,
            ),


            width: 10,

            height: 10,


            decoration: BoxDecoration(

              shape: BoxShape.circle,


              color: index == activeDot

                  ? Colors.white

                  : Colors.white38,

            ),

          );


        },

      ),

    );

  }

}







class _PoweredByWidget extends StatelessWidget {

  final String text;


  const _PoweredByWidget({

    required this.text,

  });



  @override
  Widget build(BuildContext context) {

    return Text(

      text,

      textAlign: TextAlign.center,


      style: const TextStyle(

        color: Colors.white70,

        fontSize: 12,

      ),

    );

  }

}