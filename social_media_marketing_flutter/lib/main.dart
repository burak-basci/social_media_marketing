import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/router.dart';
import 'services/serverpod_client.dart';
import 'services/auth_service.dart';
import 'config/app_config.dart';
import 'features/campaign/providers/campaign_provider.dart';
import 'features/campaign/providers/company_provider.dart';

/// Main entry point for the Social Media Marketing application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration
  // When running in browser, config.json is fetched from server
  // This allows dynamic API URL configuration per environment
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final config = await AppConfig.loadConfig();
  final serverUrl = serverUrlFromEnv.isEmpty
      ? config.apiUrl ?? 'http://localhost:8080/'
      : serverUrlFromEnv;

  // Initialize Serverpod client
  ServerpodClientManager.initialize(serverUrl: serverUrl);

  // Restore previous session if exists
  await AuthService.restoreSession();

  runApp(const SocialMediaMarketingApp());
}

/// Root application widget
class SocialMediaMarketingApp extends StatelessWidget {
  const SocialMediaMarketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CampaignProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
      ],
      child: MaterialApp.router(
        title: 'Social Media Marketing',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,

        // Router configuration
        routerConfig: AppRouter.router,
      ),
    );
  }
}
