/// Example test file demonstrating how to use the Campaign Creation Wizard endpoints.
///
/// This file shows the complete flow from creating a company profile and product
/// to generating a multi-platform campaign.
///
/// To run tests, you'll need to:
/// 1. Set up test database
/// 2. Set GEMINI_API_KEY environment variable
/// 3. Create test user and organization
///
/// Example test framework setup (using package:test):
/// ```dart
/// test('Complete campaign creation flow', () async {
///   // Your test code here
/// });
/// ```

import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'campaign_endpoint.dart';
import 'company_endpoint.dart';
import 'product_endpoint.dart';

/// Example: Complete campaign creation workflow
Future<void> exampleCampaignCreationFlow(Session session, int userId) async {
  final campaignEndpoint = CampaignEndpoint();
  final companyEndpoint = CompanyEndpoint();
  final productEndpoint = ProductEndpoint();

  print('=== Campaign Creation Wizard - Complete Flow ===\n');

  // Step 1: List existing company profiles
  print('Step 1: Listing company profiles...');
  final companies = await companyEndpoint.listCompanyProfiles(
    session,
    userId: userId,
  );
  print('Found ${companies.length} company profiles\n');

  // Step 2: Create a new company profile (if needed)
  print('Step 2: Creating company profile...');
  final companyProfile = await companyEndpoint.createCompanyProfile(
    session,
    userId: userId,
    name: 'Acme Corporation',
    description: 'Leading provider of innovative business solutions',
    brandVoice: 'Professional, innovative, customer-focused. We use clear, '
        'jargon-free language and emphasize practical benefits.',
    uploadedFiles: ['brand-guide.pdf', 'logo.png'],
  );
  print('Created company profile: ${companyProfile.name} (ID: ${companyProfile.id})\n');

  // Step 3: Create a product
  print('Step 3: Creating product...');
  final product = await productEndpoint.createProduct(
    session,
    userId: userId,
    companyProfileId: companyProfile.id!,
    name: 'Widget Pro 3000',
    description: 'Revolutionary widget that increases productivity by 300%',
    targetAudience: 'Business professionals, managers, age 30-55, '
        'working in technology and operations',
    keyFeatures: [
      'Cloud-based operation',
      'Real-time analytics dashboard',
      'Automated workflow integration',
      'Enterprise-grade security',
      'Mobile app included',
    ],
  );
  print('Created product: ${product.name} (ID: ${product.id})\n');

  // Step 4: Generate multi-platform campaign
  print('Step 4: Generating AI campaign...');
  final campaign = await campaignEndpoint.generateCampaign(
    session,
    userId: userId,
    companyProfileId: companyProfile.id!,
    productId: product.id,
    userPrompt: 'Announce the launch of Widget Pro 3000 with excitement. '
        'Highlight the 300% productivity boost and cloud-based features. '
        'Include a call-to-action to sign up for early access.',
    selectedPlatforms: ['x', 'linkedin', 'instagram', 'facebook'],
    generateImage: true,
    title: 'Widget Pro 3000 Launch Campaign',
  );

  if (campaign.success) {
    print('✅ Campaign generated successfully!');
    print('Post ID: ${campaign.postId}\n');

    // Display generated content
    print('Generated Content:');
    print('─' * 80);

    for (final platform in campaign.platformContents.keys) {
      print('\n[$platform]');
      print(campaign.platformContents[platform]);
      print('─' * 80);
    }

    if (campaign.imagePrompt != null) {
      print('\n[Image Prompt]');
      print(campaign.imagePrompt);
      print('─' * 80);
    }

    // Display timing information
    if (campaign.timings != null) {
      print('\nPerformance Metrics:');
      print('Total time: ${campaign.timings!['total_ms']}ms');
      print('Platform count: ${campaign.timings!['platforms_count']}');
      print('Average per platform: ${campaign.timings!['total_ms'] ~/ campaign.timings!['platforms_count']}ms');
    }
  } else {
    print('❌ Campaign generation failed: ${campaign.errorMessage}');
    return;
  }

  print('\n=== Optional: Regenerate Content ===\n');

  // Step 5: Example - Regenerate X content if it's too long
  final xContent = campaign.platformContents['x']!;
  if (xContent.length > 280) {
    print('X content is too long (${xContent.length} chars), regenerating...');

    final newX = await campaignEndpoint.regeneratePlatform(
      session,
      userId: userId,
      postId: campaign.postId,
      platform: 'x',
      newPrompt: 'Same message but keep it under 280 characters',
    );

    print('✅ Regenerated X content:');
    print(newX.content);
    print('Length: ${newX.content.length} chars\n');
  }

  // Step 6: Example - Edit LinkedIn content
  print('Editing LinkedIn content to add more professional tone...');

  final editedLinkedIn = await campaignEndpoint.editPlatformContent(
    session,
    userId: userId,
    postId: campaign.postId,
    platform: 'linkedin',
    editRequest: 'Make it more professional and add industry statistics if possible. '
        'Include a strong call-to-action at the end.',
  );

  print('✅ Edited LinkedIn content:');
  print(editedLinkedIn.content);
  print('\n');

  print('=== Campaign Creation Complete ===');
  print('Next steps:');
  print('1. Review content in UI');
  print('2. Make any final edits');
  print('3. Schedule via Postiz integration');
  print('4. Monitor performance');
}

/// Example: Managing company profiles
Future<void> exampleCompanyManagement(Session session, int userId) async {
  final companyEndpoint = CompanyEndpoint();

  print('=== Company Profile Management ===\n');

  // Create
  final company = await companyEndpoint.createCompanyProfile(
    session,
    userId: userId,
    name: 'Tech Startup Inc',
    description: 'Innovative SaaS solutions',
    brandVoice: 'Casual, friendly, tech-savvy',
    uploadedFiles: [],
  );
  print('Created: ${company.name}\n');

  // Read
  final retrieved = await companyEndpoint.getCompanyProfile(
    session,
    userId: userId,
    companyProfileId: company.id!,
  );
  print('Retrieved: ${retrieved.name}\n');

  // Update
  final updated = await companyEndpoint.updateCompanyProfile(
    session,
    userId: userId,
    companyProfileId: company.id!,
    description: 'Innovative SaaS solutions for modern businesses',
    brandVoice: 'Casual, friendly, tech-savvy, helpful',
  );
  print('Updated description: ${updated.description}\n');

  // List
  final allCompanies = await companyEndpoint.listCompanyProfiles(
    session,
    userId: userId,
  );
  print('Total companies: ${allCompanies.length}\n');

  // Get products
  final products = await companyEndpoint.getCompanyProducts(
    session,
    userId: userId,
    companyProfileId: company.id!,
  );
  print('Products for ${company.name}: ${products.length}\n');

  // Note: Delete would fail if there are products or posts
  // final deleted = await companyEndpoint.deleteCompanyProfile(
  //   session,
  //   userId: userId,
  //   companyProfileId: company.id!,
  // );
}

/// Example: Managing products
Future<void> exampleProductManagement(
  Session session,
  int userId,
  int companyProfileId,
) async {
  final productEndpoint = ProductEndpoint();

  print('=== Product Management ===\n');

  // Create
  final product = await productEndpoint.createProduct(
    session,
    userId: userId,
    companyProfileId: companyProfileId,
    name: 'Product X',
    description: 'Amazing product',
    targetAudience: 'Everyone',
    keyFeatures: ['Fast', 'Reliable', 'Affordable'],
  );
  print('Created: ${product.name}\n');

  // Read
  final retrieved = await productEndpoint.getProduct(
    session,
    userId: userId,
    productId: product.id!,
  );
  print('Retrieved: ${retrieved.name}\n');

  // Parse key features
  final features = ProductEndpoint.parseKeyFeatures(product.keyFeatures);
  print('Features: ${features.join(', ')}\n');

  // Update
  final updated = await productEndpoint.updateProduct(
    session,
    userId: userId,
    productId: product.id!,
    keyFeatures: ['Fast', 'Reliable', 'Affordable', 'Easy to use'],
  );
  print('Updated features count: ${ProductEndpoint.parseKeyFeatures(updated.keyFeatures).length}\n');

  // List
  final allProducts = await productEndpoint.listProducts(
    session,
    userId: userId,
    companyProfileId: companyProfileId,
  );
  print('Total products: ${allProducts.length}\n');

  // Get posts using this product
  final posts = await productEndpoint.getProductPosts(
    session,
    userId: userId,
    productId: product.id!,
  );
  print('Posts using ${product.name}: ${posts.length}\n');
}

/// Example: Error handling
Future<void> exampleErrorHandling(Session session, int userId) async {
  final campaignEndpoint = CampaignEndpoint();

  print('=== Error Handling Examples ===\n');

  // 1. Invalid company profile
  try {
    await campaignEndpoint.generateCampaign(
      session,
      userId: userId,
      companyProfileId: 99999, // Non-existent
      userPrompt: 'Test',
      selectedPlatforms: ['x'],
    );
  } catch (e) {
    print('✅ Caught error: $e\n');
  }

  // 2. Empty prompt
  try {
    await campaignEndpoint.generateCampaign(
      session,
      userId: userId,
      companyProfileId: 1,
      userPrompt: '', // Empty
      selectedPlatforms: ['x'],
    );
  } catch (e) {
    print('✅ Caught error: $e\n');
  }

  // 3. No platforms selected
  try {
    await campaignEndpoint.generateCampaign(
      session,
      userId: userId,
      companyProfileId: 1,
      userPrompt: 'Test',
      selectedPlatforms: [], // Empty
    );
  } catch (e) {
    print('✅ Caught error: $e\n');
  }

  // 4. Access denied (different organization)
  try {
    await campaignEndpoint.regeneratePlatform(
      session,
      userId: userId,
      postId: 99999, // Post from different org
      platform: 'x',
    );
  } catch (e) {
    print('✅ Caught error: $e\n');
  }
}

/// Example: JSON field handling
void exampleJsonFieldParsing() {
  print('=== JSON Field Parsing ===\n');

  // Parse uploaded files
  final uploadedFilesJson = '["file1.pdf", "logo.png", "brand-guide.pdf"]';
  final files = CompanyEndpoint.parseUploadedFiles(uploadedFilesJson);
  print('Uploaded files: ${files.join(', ')}\n');

  // Parse key features
  final keyFeaturesJson = '["Fast", "Reliable", "Affordable"]';
  final features = ProductEndpoint.parseKeyFeatures(keyFeaturesJson);
  print('Key features: ${features.join(', ')}\n');

  // Encode features back to JSON
  final newFeatures = ['Fast', 'Reliable', 'Affordable', 'Easy to use'];
  final encoded = ProductEndpoint.encodeKeyFeatures(newFeatures);
  print('Encoded: $encoded\n');

  // Parse post content
  final aiGeneratedContent = jsonDecode('''
    {
      "x": "Exciting announcement! 🚀",
      "linkedin": "We are thrilled to announce...",
      "instagram": "New product alert! 📢"
    }
  ''') as Map<String, dynamic>;

  print('Platform contents:');
  for (final entry in aiGeneratedContent.entries) {
    print('  ${entry.key}: ${entry.value}');
  }
}

/// Main function showing how to run examples
void main() async {
  // Note: This is a demonstration file, not a working test
  // You need to set up:
  // 1. Serverpod session
  // 2. Test database
  // 3. GEMINI_API_KEY environment variable
  // 4. Test user and organization

  print('Campaign Creation Wizard - Endpoint Examples');
  print('This file demonstrates the API usage patterns.');
  print('See ENDPOINTS_GUIDE.md for complete documentation.\n');

  // Example calls (commented out - need proper setup):
  // final session = ... // Get Serverpod session
  // final userId = 1;
  //
  // await exampleCampaignCreationFlow(session, userId);
  // await exampleCompanyManagement(session, userId);
  // await exampleProductManagement(session, userId, 1);
  // await exampleErrorHandling(session, userId);
  // exampleJsonFieldParsing();
}
