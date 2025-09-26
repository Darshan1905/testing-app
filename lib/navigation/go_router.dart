import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:occusearch/features/ai_webview/ai_webview_page.dart';
import 'package:occusearch/features/authentication/congratulations/congratulations_screen.dart';
import 'package:occusearch/features/authentication/create_account/create_account_screen.dart';
import 'package:occusearch/features/authentication/login/login_screen.dart';
import 'package:occusearch/features/authentication/otp/otp_screen.dart';
import 'package:occusearch/features/authentication/welcome_back/welcome_back_screen.dart';
import 'package:occusearch/features/contact_us/contact_us_screen.dart';
import 'package:occusearch/features/cricos_course/course_compare/course_compare_detail_screen.dart';
import 'package:occusearch/features/cricos_course/course_detail/course_detail_screen.dart';
import 'package:occusearch/features/cricos_course/course_list/course_list_screen.dart';
import 'package:occusearch/features/custom_question/custom_question_answer_review_screen.dart';
import 'package:occusearch/features/custom_question/custom_question_onbaording_screen.dart';
import 'package:occusearch/features/custom_question/custom_question_screen.dart';
import 'package:occusearch/features/dashboard/recent_updates/recent_update_screen.dart';
import 'package:occusearch/features/discover_dream/unit_group/unit_group_list_screen.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_onboarding_screen.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_questions_screen.dart';
import 'package:occusearch/features/fund_calculator/fund_calculator_summary_page.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/other_living_cost_screen.dart';
import 'package:occusearch/features/fund_calculator/other_living_cost/other_living_summary_page.dart';
import 'package:occusearch/features/get_my_policy/gmp_welcome_page.dart';
import 'package:occusearch/features/get_my_policy/ovhc/gmp_ovhc_detail_screen.dart';
import 'package:occusearch/features/get_my_policy/ovhc/gmp_ovhc_screen.dart';
import 'package:occusearch/features/get_my_policy/oshc/gmp_oshc_screen.dart';
import 'package:occusearch/features/get_my_policy/oshc/oshc_comapre_screen.dart';
import 'package:occusearch/features/home_tab/home_tab_screen.dart';
import 'package:occusearch/features/labour_insights/labour_insight_unit_group_screen.dart';
import 'package:occusearch/features/more_menu/about_and_legal/about_and_legal_screen.dart';
import 'package:occusearch/features/more_menu/about_and_legal/pdf_view_screen.dart';
import 'package:occusearch/features/more_menu/edit_profile/edit_profile_screen.dart';
import 'package:occusearch/features/more_menu/more_apps/more_app_screen.dart';
import 'package:occusearch/features/more_menu/more_menu_screen.dart';
import 'package:occusearch/features/my_bookmark/my_bookmark_screen.dart';
import 'package:occusearch/features/occupation_search/occupation_detail_page/occupation_detail_screen.dart';
import 'package:occusearch/features/occupation_search/occupation_list/occupation_list_screen.dart';
import 'package:occusearch/features/onboarding/onboarding_screen.dart';
import 'package:occusearch/features/permission/location_permission_screen.dart';
import 'package:occusearch/features/point_test/point_test_question_screen.dart';
import 'package:occusearch/features/point_test/point_test_review/point_test_review_screen.dart';
import 'package:occusearch/features/point_test/point_test_welcome_screen.dart';
import 'package:occusearch/features/splash/splash_screen.dart';
import 'package:occusearch/features/subscription/compare_plan/compare_plan_list_page.dart';
import 'package:occusearch/features/subscription/subscription_plan.dart';
import 'package:occusearch/features/subscription/transaction_history/transaction_history_screen.dart';
import 'package:occusearch/features/user_migration/user_migration_screen.dart';
import 'package:occusearch/features/vevo_check/vevo_check_detail_screen.dart';
import 'package:occusearch/features/vevo_check/vevo_check_form_screen.dart';
import 'package:occusearch/features/vevo_check/vevo_check_screen.dart';
import 'package:occusearch/features/visa_fees/visa_fees_detail_screen.dart';
import 'package:occusearch/features/visa_fees/visa_fees_question_screen.dart';
import 'package:occusearch/features/visa_fees/visa_fees_screen.dart';
import 'package:occusearch/features/visa_fees/visa_fees_subclass_screen.dart';
import 'package:occusearch/navigation/routes.dart';

import 'navigation_observer.dart';

class GoRouterConfig {
  /// The route configuration......
  static final GoRouter router = GoRouter(observers: [
    NavigationObserver()
  ], routes: <RouteBase>[
    GoRoute(
      path: RouteName.root,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        // [ONBOARDING SCREEN]
        GoRoute(
          path: RouteName.onboarding,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.onboarding,
            key: state.pageKey,
            child: const OnBoardingScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [LOGIN SCREEN]
        GoRoute(
          path: RouteName.login,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.login,
            key: state.pageKey,
            child: const LoginScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [OTP SCREEN]
        GoRoute(
          path: RouteName.otp,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.otp,
            key: state.pageKey,
            child: OTPScreen(
                arguments: state.extra != null
                    ? state.extra as Map<String, dynamic>
                    : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [USER MIGRATION SCREEN]
        GoRoute(
          path: RouteName.userMigration,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.userMigration,
            key: state.pageKey,
            child: UserMigrationScreen(
                arguments: state.extra != null ? state.extra as dynamic : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [CONGRATULATIONS SCREEN]
        GoRoute(
          path: RouteName.congratulation,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.congratulation,
            key: state.pageKey,
            child: const CongratulationsScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [WELCOME SCREEN]
        GoRoute(
          path: RouteName.welcomeBack,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.welcomeBack,
            key: state.pageKey,
            child: WelcomeBackScreen(
                arguments: state.extra != null
                    ? state.extra as Map<String, dynamic>
                    : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [CREATE ACCOUNT]
        GoRoute(
          path: RouteName.createAccount,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.createAccount,
            key: state.pageKey,
            child: CreateAccountScreen(
                arguments: state.extra != null
                    ? state.extra as Map<String, dynamic>
                    : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [HOME SCREEN] - BOTTOM NAVIGATION TAB
        GoRoute(
          path: RouteName.home,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.home,
            key: state.pageKey,
            child: const HomeScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [CUSTOM QUESTION ONBOARDING SCREEN]
        GoRoute(
          path: RouteName.customQuestionOnboarding,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.customQuestionOnboarding,
            key: state.pageKey,
            child: const CustomQuestionOnbaordingScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.customQuestionOnboarding,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.customQuestionOnboarding,
            key: state.pageKey,
            child: CustomQuestionOnbaordingScreen(arguments: state.extra),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.customQuestionAnswerReview,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.customQuestionAnswerReview,
            key: state.pageKey,
            child: CustomQuestionAnswerReviewScreen(arguments: state.extra),
          ),
          // transitionsBuilder:
          //     (context, animation, secondaryAnimation, child) =>
          //         FadeTransition(opacity: animation, child: child),
        ),
        // [CUSTOM QUESTION SCREEN]
        GoRoute(
          path: RouteName.customQuestion,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.customQuestion,
            key: state.pageKey,
            child: CustomQuestionScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [VISA FEES SCREEN]
        GoRoute(
          path: RouteName.visaFeesScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.visaFeesScreen,
            key: state.pageKey,
            child: const VisaFeesScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [VISA SUBCLASS SCREEN]
        GoRoute(
          path: RouteName.visaFeesSubclassScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.visaFeesSubclassScreen,
            key: state.pageKey,
            child: const VisaFeesSubclassScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [VISA PRIMARY APPLICANT SCREEN]
        GoRoute(
          path: RouteName.primaryApplicantScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.primaryApplicantScreen,
            key: state.pageKey,
            child: VisaFeesQuestionScreen(
                arguments: state.extra != null ? state.extra as dynamic : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [VISA FEES DETAIL SCREEN]
        GoRoute(
          path: RouteName.visaFeesDetail,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.visaFeesDetail,
            key: state.pageKey,
            child: VisaFeesDetailScreen(arguments: state.extra),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [FUND CALCULATOR SCREEN]
        GoRoute(
          path: RouteName.fundCalculatorOnBoarding,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.fundCalculatorOnBoarding,
            key: state.pageKey,
            child: const FundCalculatorOnBoardingScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.fundCalculatorQuestions,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            name: RouteName.fundCalculatorQuestions,
            key: state.pageKey,
            child: FundCalculatorQuestionsScreen(
                arguments: state.extra as dynamic),
            transitionDuration: const Duration(milliseconds: 850),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: RouteName.occupationListScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.occupationListScreen,
            key: state.pageKey,
            child: const OccupationListScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.coursesListScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.coursesListScreen,
            key: state.pageKey,
            child: CoursesListScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.coursesDetailScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.coursesDetailScreen,
            key: state.pageKey,
            child: CoursesDetailScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.compareCourseDetailScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.compareCourseDetailScreen,
            key: state.pageKey,
            child: CourseCompareDetailScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        //MY BOOKMARK LIST SCREEN
        GoRoute(
          path: RouteName.myBookmarkListScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.myBookmarkListScreen,
            key: state.pageKey,
            child: MyBookmarkListScreen(
                arguments: state.extra != null ? state.extra as dynamic : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),

        //More Menu Screen
        GoRoute(
          path: RouteName.moreMenu,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.moreMenu,
            key: state.pageKey,
            child: const MoreMenuScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        //More Apps Screen
        GoRoute(
          path: RouteName.moreApps,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.moreApps,
            key: state.pageKey,
            child: MoreAppsScreen(
                arguments: state.extra != null ? state.extra as dynamic : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        //ABOUT AND LEGAL Screen
        GoRoute(
          path: RouteName.aboutAndLegal,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.aboutAndLegal,
            key: state.pageKey,
            child: const AboutAndLegalScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        //Edit Profile
        GoRoute(
          path: RouteName.editProfile,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.editProfile,
            key: state.pageKey,
            child: const EditProfileScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.occupationSearchScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.occupationSearchScreen,
            key: state.pageKey,
            child: SearchOccupationScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.fundCalculatorSummaryPage,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.fundCalculatorSummaryPage,
            key: state.pageKey,
            child: FundCalculatorSummaryPage(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.otherLivingCostScreen,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            name: RouteName.otherLivingCostScreen,
            key: state.pageKey,
            child: OtherLivingCostScreen(arguments: state.extra as dynamic),
            transitionDuration: const Duration(milliseconds: 850),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: RouteName.otherLivingSummaryPage,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.otherLivingSummaryPage,
            key: state.pageKey,
            child: OtherLivingSummaryPage(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [CONTACT US SCREEN]
        GoRoute(
          path: RouteName.contactUs,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.contactUs,
            key: state.pageKey,
            child: ContactUsScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [VEVO CHECK SCREEN]
        GoRoute(
          path: RouteName.vevoCheck,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.vevoCheck,
            key: state.pageKey,
            child: const VevoCheckScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [VEVO CHECK FORM SCREEN]
        GoRoute(
          path: RouteName.vevoCheckForm,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.vevoCheckForm,
            key: state.pageKey,
            child: VevoCheckFormScreen(
                arguments: state.extra != null ? state.extra as dynamic : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [VEVO CHECK DETAIL SCREEN]
        GoRoute(
          path: RouteName.vevoCheckDetail,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.vevoCheckDetail,
            key: state.pageKey,
            child: VevoCheckDetailScreen(
                arguments: state.extra != null ? state.extra as dynamic : null),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.pointTestWelcomeScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.pointTestWelcomeScreen,
            key: state.pageKey,
            child: const PointTestWelcomeScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.pointTestQuestionScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.pointTestQuestionScreen,
            key: state.pageKey,
            child: PointTestQuestionScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.pointTestReviewScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.pointTestReviewScreen,
            key: state.pageKey,
            child: PointTestReviewScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.recentUpdateScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.recentUpdateScreen,
            key: state.pageKey,
            child: RecentUpdateScreen(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.labourInsightUnitGroupScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.labourInsightUnitGroupScreen,
            key: state.pageKey,
            child:
                LabourInsightUnitGroupScreen(arguments: state.extra as dynamic),
          ),
        ),

        GoRoute(
          path: RouteName.unitGroupListScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.unitGroupListScreen,
            key: state.pageKey,
            child: const UnitGroupListScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),

        GoRoute(
          path: RouteName.pdfViewer,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.pdfViewer,
            key: state.pageKey,
            child: const PDFViewerScreen(),
          ),
        ),
        //user Live location
        GoRoute(
          path: RouteName.locationPermissionScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.locationPermissionScreen,
            key: state.pageKey,
            child: const LocationPermissionScreen(),
          ),
        ),
        GoRoute(
          path: RouteName.subscription,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.subscription,
            key: state.pageKey,
            child: SubscriptionPlan(arguments: state.extra as dynamic),
          ),
        ),
        //compare plan screen
        GoRoute(
          path: RouteName.planCompareListScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.planCompareListScreen,
            key: state.pageKey,
            child: ComparePlanScreen(arguments: state.extra as dynamic),
          ),
        ),
        GoRoute(
          path: RouteName.transactionHistoryScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.transactionHistoryScreen,
            key: state.pageKey,
            child: const TransactionHistoryScreen(),
          ),
        ),
        GoRoute(
          path: RouteName.aiWebViewScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.aiWebViewScreen,
            key: state.pageKey,
            child: const AIWebViewPage(),
          ),
        ),
        GoRoute(
          path: RouteName.getMyPolicy,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.getMyPolicy,
            key: state.pageKey,
            child: const GetMyPolicyWelcomePage(),
          ),
        ),

        // [GET MY POLICY OVHC SCREEN]
        GoRoute(
          path: RouteName.gmpOVHCScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.gmpOVHCScreen,
            key: state.pageKey,
            child: const GMPOVHCPage(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.gmpOVHCDetailsScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.gmpOVHCDetailsScreen,
            key: state.pageKey,
            child: GMPOVHCDetailsPage(arguments: state.extra as dynamic),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        // [GET MY POLICY OSHC SCREEN]
        GoRoute(
          path: RouteName.gmpOSHCScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.gmpOSHCScreen,
            key: state.pageKey,
            child: const GmpOSHCScreen(),
            // transitionsBuilder:
            //     (context, animation, secondaryAnimation, child) =>
            //         FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: RouteName.gmpOSHCCompareScreen,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: RouteName.gmpOSHCCompareScreen,
            key: state.pageKey,
            child: OSHCCompareScreen(arguments: state.extra as dynamic),
          ),
        )
      ],
    ),
  ]);
}
