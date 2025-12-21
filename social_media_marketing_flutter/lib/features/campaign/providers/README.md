# Campaign Wizard State Management

This directory contains the state management providers for the Campaign Creation Wizard.

## Files Created

### 1. `campaign_provider.dart`
Main provider for the 4-step campaign creation wizard.

**Steps:**
- **Step 0:** Company & Product Selection
- **Step 1:** Campaign Details & Platform Selection
- **Step 2:** Content Generation & Review
- **Step 3:** Publishing Options

**Key Features:**
- Wizard navigation with validation
- Company and product loading
- Multi-platform content generation
- Individual platform regeneration
- Content editing support
- Platform connection checking
- Publishing configuration (immediate or scheduled)

**Usage Example:**
```dart
// In your main.dart or app setup
ChangeNotifierProvider(
  create: (_) => CampaignProvider(),
  child: MyApp(),
)

// In your widget
final campaignProvider = Provider.of<CampaignProvider>(context);

// Load companies on wizard start
await campaignProvider.loadCompanyProfiles();

// Select company and load its products
await campaignProvider.selectCompany(selectedCompany);

// Generate content for all platforms
await campaignProvider.generateContent();

// Regenerate for single platform
await campaignProvider.regeneratePlatform('x');

// Navigate wizard
campaignProvider.nextStep();
```

### 2. `company_provider.dart`
Provider for company profile CRUD operations.

**Features:**
- Load all company profiles
- Create new company profile
- Update existing company profile
- Delete company profile
- Local caching of companies

**Usage Example:**
```dart
// In your main.dart or app setup
ChangeNotifierProvider(
  create: (_) => CompanyProvider(),
  child: MyApp(),
)

// In your widget
final companyProvider = Provider.of<CompanyProvider>(context);

// Load companies
await companyProvider.loadCompanies();

// Create company
await companyProvider.createCompany(
  name: 'Acme Corp',
  description: 'Leading provider...',
  brandVoice: 'Professional, friendly',
);

// Update company
await companyProvider.updateCompany(
  companyId: 1,
  name: 'New Name',
);

// Delete company
await companyProvider.deleteCompany(companyId: 1);
```

### 3. `platform_constants.dart`
Utility class with platform-specific constants.

**Features:**
- Character limits per platform
- Platform display names
- Brand colors
- Icons/emojis
- Content guidelines
- Helper methods for validation

**Usage Example:**
```dart
import 'package:your_app/core/constants/platform_constants.dart';

// Get character limit
final limit = PlatformConstants.getCharacterLimit('x'); // 280

// Validate content
final isValid = PlatformConstants.isContentValid('x', content);

// Get remaining characters
final remaining = PlatformConstants.getRemainingCharacters('x', content);

// Get platform color
final color = PlatformConstants.getPlatformColor('linkedin');

// Get character count status
final status = PlatformConstants.getCharacterCountStatus('x', content);
// Returns: "250/280" or "300/280 (over by 20)"
```

## Platform Generation Status

The `PlatformGenerationStatus` class tracks content generation for each platform:

```dart
class PlatformGenerationStatus {
  String status;                  // 'pending', 'generating', 'completed', 'error'
  String? content;                // Generated content
  double? generationTimeSeconds;  // Time taken to generate
  String? error;                  // Error message if failed
  int? characterCount;            // Content length
}
```

## Character Limits

Supported platforms and their limits:

| Platform  | Character Limit |
|-----------|----------------|
| X (Twitter) | 280 |
| LinkedIn | 3,000 |
| Instagram | 2,200 |
| Facebook | 63,206 |
| Pinterest | 500 |

## Important Notes

### Serverpod Endpoint Registration

The providers now use properly typed endpoint calls. The Serverpod client has been regenerated with all endpoints properly registered:

**Campaign Endpoints:**
```dart
final result = await _client.campaign.generateCampaign(
  userId: _userId,
  companyProfileId: companyId,
  productId: productId,
  userPrompt: prompt,
  selectedPlatforms: platforms,
  generateImage: generateImage,
);
```

**Company Endpoints:**
```dart
final companies = await _client.company.listCompanyProfiles(userId: _userId);
final company = await _client.company.createCompanyProfile(
  userId: _userId,
  name: name,
  description: description,
  brandVoice: brandVoice,
);
```

**Product Endpoints:**
```dart
final products = await _client.product.listProducts(
  userId: _userId,
  companyProfileId: companyId,
);
```

### Mock User ID

Currently using `_userId = 1` as a placeholder. Replace with actual authenticated user ID from your auth provider:

```dart
// Get from auth provider
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final userId = authProvider.currentUser?.id ?? 0;
```

### Error Handling

All async methods include try-catch blocks and set error states. Always check for errors in your UI:

```dart
if (campaignProvider.hasError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(campaignProvider.error!)),
  );
}
```

### Loading States

Use loading states to show progress indicators:

```dart
if (campaignProvider.isLoading) {
  return CircularProgressIndicator();
}

if (campaignProvider.isGenerating) {
  return LinearProgressIndicator();
}
```

## Dependencies Required

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  social_media_marketing_client:
    path: ../../social_media_marketing_client
```

## Provider Setup

In your `main.dart`:

```dart
void main() {
  // Initialize Serverpod client
  ServerpodClientManager.initialize(
    serverUrl: 'http://localhost:8080',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CampaignProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        // ... other providers
      ],
      child: MyApp(),
    ),
  );
}
```

## Workflow Example

Complete campaign creation flow:

```dart
// Step 0: Company Selection
await campaignProvider.loadCompanyProfiles();
await campaignProvider.selectCompany(company);
campaignProvider.selectProduct(product); // optional
campaignProvider.nextStep();

// Step 1: Campaign Details
campaignProvider.updateCampaignPrompt('Launch announcement...');
campaignProvider.togglePlatform('x');
campaignProvider.togglePlatform('linkedin');
campaignProvider.setGenerateImage(true);
campaignProvider.nextStep();

// Step 2: Content Generation
await campaignProvider.generateContent();

// Review and edit if needed
if (needsChanges) {
  campaignProvider.updateEditedContent('x', editedContent);
  // or regenerate
  await campaignProvider.regeneratePlatform('linkedin');
}
campaignProvider.nextStep();

// Step 3: Publishing
await campaignProvider.checkPlatformConnections();
campaignProvider.setPublishNow(true);
// or
campaignProvider.setScheduleTime(DateTime.now().add(Duration(hours: 2)));

// Validate and submit
if (campaignProvider.validateForSubmission()) {
  // Call publish endpoint
  await publishCampaign();
}

// Clean up
campaignProvider.reset();
```

## Testing

Example unit test structure:

```dart
void main() {
  group('CampaignProvider', () {
    late CampaignProvider provider;

    setUp(() {
      provider = CampaignProvider();
    });

    test('initial state is correct', () {
      expect(provider.currentStep, 0);
      expect(provider.selectedCompany, null);
      expect(provider.selectedPlatforms, isEmpty);
    });

    test('can select company', () {
      final company = CompanyProfile(...);
      provider.selectCompany(company);
      expect(provider.selectedCompany, company);
    });

    test('validates step before allowing next', () {
      expect(provider.canGoNext, false);
      provider.selectCompany(company);
      expect(provider.canGoNext, true);
    });

    // ... more tests
  });
}
```

## Future Enhancements

1. **Undo/Redo Support:** Add command pattern for content edits
2. **Draft Saving:** Auto-save wizard state to local storage
3. **Content Versioning:** Track content edit history per platform
4. **A/B Testing:** Generate multiple variants for comparison
5. **Analytics:** Track generation times and success rates
6. **Offline Support:** Cache generated content locally
7. **Collaborative Editing:** Real-time collaboration features

## Troubleshooting

**Issue: "ServerpodClientManager not initialized"**
- Solution: Call `ServerpodClientManager.initialize()` in main() before runApp()

**Issue: "Failed to load companies"**
- Check server is running on correct port
- Verify endpoint is registered in server
- Check network connectivity

**Issue: "Content generation fails"**
- Verify Gemini API key is configured
- Check campaign_endpoint is properly set up
- Review server logs for detailed errors

**Issue: "Platform not connected"**
- Implement social media OAuth flow
- Check platform API credentials
- Verify callback URLs are configured
