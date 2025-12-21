import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../services/serverpod_client.dart';
import '../../../core/constants/platform_constants.dart';

/// Status of platform content generation
class PlatformGenerationStatus {
  String status; // 'pending', 'generating', 'completed', 'error'
  String? content;
  double? generationTimeSeconds;
  String? error;
  int? characterCount;

  PlatformGenerationStatus({
    required this.status,
    this.content,
    this.generationTimeSeconds,
    this.error,
    this.characterCount,
  });

  bool get isPending => status == 'pending';
  bool get isGenerating => status == 'generating';
  bool get isCompleted => status == 'completed';
  bool get isError => status == 'error';

  /// Gets color based on status
  bool get isWithinLimit {
    if (characterCount == null || content == null) return true;
    return characterCount! <= (PlatformConstants.characterLimits[content!] ?? 280);
  }
}

/// Provider for managing campaign creation wizard state.
///
/// This provider handles the complete campaign creation workflow across 4 steps:
/// 1. Company & Product Selection
/// 2. Campaign Details & Platform Selection
/// 3. Content Generation & Review
/// 4. Publishing Options
class CampaignProvider with ChangeNotifier {
  // ====================================================================
  // STATE VARIABLES
  // ====================================================================

  // Wizard navigation
  int _currentStep = 0;

  // Step 1: Company & Product Selection
  CompanyProfile? _selectedCompany;
  Product? _selectedProduct;
  List<CompanyProfile> _companies = [];
  List<Product> _products = [];

  // Step 2: Campaign Details
  String _campaignPrompt = '';
  List<String> _selectedPlatforms = [];
  bool _generateImage = true;

  // Step 3: Content Generation & Review
  Map<String, PlatformGenerationStatus> _platformStatus = {};
  Map<String, String> _originalContent = {}; // Store original AI-generated content
  Map<String, String> _editedContent = {}; // Store user-edited content
  String? _imagePrompt;
  String? _originalImagePrompt; // Store the original AI-generated prompt
  int? _postId;
  bool _isRegenerating = false;

  // Step 4: Publishing Options
  bool _publishNow = false;
  DateTime? _scheduleTime;

  // Platform connections (which platforms are connected)
  Map<String, bool> _platformConnections = {};

  // Loading and error states
  bool _isLoading = false;
  String? _error;
  bool _isGenerating = false;

  // ====================================================================
  // GETTERS
  // ====================================================================

  // Navigation
  int get currentStep => _currentStep;
  bool get canGoNext => _validateCurrentStep();
  bool get canGoPrevious => _currentStep > 0;
  bool get isLastStep => _currentStep == 3;

  // Step 1 getters
  CompanyProfile? get selectedCompany => _selectedCompany;
  Product? get selectedProduct => _selectedProduct;
  List<CompanyProfile> get companies => List.unmodifiable(_companies);
  List<Product> get products => List.unmodifiable(_products);
  int? get selectedCompanyId => _selectedCompany?.id;
  int? get selectedProductId => _selectedProduct?.id;

  // Step 2 getters
  String get campaignPrompt => _campaignPrompt;
  String get prompt => _campaignPrompt;
  List<String> get selectedPlatforms => List.unmodifiable(_selectedPlatforms);
  bool get generateImage => _generateImage;

  // Step 3 getters
  Map<String, PlatformGenerationStatus> get platformStatus =>
      Map.unmodifiable(_platformStatus);
  String? get imagePrompt => _imagePrompt;
  String? get generatedImagePrompt => _imagePrompt;
  int? get postId => _postId;
  bool get hasGeneratedContent => _platformStatus.values.any((s) => s.isCompleted);
  bool get allPlatformsCompleted =>
      _selectedPlatforms.every((p) => _platformStatus[p]?.isCompleted ?? false);

  // Step 4 getters
  bool get publishNow => _publishNow;
  DateTime? get scheduleTime => _scheduleTime;
  Map<String, bool> get platformConnections => Map.unmodifiable(_platformConnections);

  // General state
  bool get isLoading => _isLoading;
  bool get isGenerating => _isGenerating;
  bool get isRegenerating => _isRegenerating;
  String? get error => _error;
  bool get hasError => _error != null;

  // Image prompt editing state
  bool get imagePromptEdited => _imagePrompt != _originalImagePrompt && _originalImagePrompt != null;
  String? get originalImagePrompt => _originalImagePrompt;

  /// Serverpod client instance
  Client get _client => ServerpodClientManager.instance.client;

  /// Mock user ID (TODO: Replace with actual auth)
  final int _userId = 1;

  // ====================================================================
  // CONSTRUCTOR
  // ====================================================================

  /// Constructor that initializes the provider
  CampaignProvider() {
    _init();
  }

  /// Initialize the provider by loading companies
  Future<void> _init() async {
    await loadCompanyProfiles();
  }

  // ====================================================================
  // STEP 1: COMPANY & PRODUCT SELECTION
  // ====================================================================

  /// Loads all company profiles for the organization
  Future<void> loadCompanyProfiles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _companies = await _client.company.listCompanyProfiles(
        userId: _userId,
      );

      _error = null;
    } catch (e) {
      _error = 'Failed to load companies: ${e.toString()}';
      debugPrint('Error loading companies: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads products for a specific company
  Future<void> loadProducts(int companyId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _client.product.listProducts(
        userId: _userId,
        companyProfileId: companyId,
      );

      _error = null;
    } catch (e) {
      _error = 'Failed to load products: ${e.toString()}';
      debugPrint('Error loading products: $e');
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Selects a company and loads its products
  Future<void> selectCompany(CompanyProfile company) async {
    // Ensure company is in the list
    if (!_companies.any((c) => c.id == company.id)) {
      _companies.add(company);
      _companies.sort((a, b) => a.name.compareTo(b.name));
    }

    _selectedCompany = company;
    _selectedProduct = null; // Reset product when company changes
    notifyListeners();

    await loadProducts(company.id!);
  }

  /// Selects a product
  void selectProduct(Product? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  // ====================================================================
  // STEP 2: CAMPAIGN DETAILS
  // ====================================================================

  /// Updates the campaign prompt
  void updateCampaignPrompt(String prompt) {
    _campaignPrompt = prompt;
    notifyListeners();
  }

  /// Toggles a platform selection
  void togglePlatform(String platform) {
    if (_selectedPlatforms.contains(platform)) {
      _selectedPlatforms.remove(platform);
    } else {
      _selectedPlatforms.add(platform);
    }
    notifyListeners();
  }

  /// Sets selected platforms
  void setSelectedPlatforms(List<String> platforms) {
    _selectedPlatforms = List.from(platforms);
    notifyListeners();
  }

  /// Toggles image generation
  void toggleGenerateImage() {
    _generateImage = !_generateImage;
    notifyListeners();
  }

  /// Sets image generation flag
  void setGenerateImage(bool value) {
    _generateImage = value;
    notifyListeners();
  }

  // ====================================================================
  // STEP 3: CONTENT GENERATION
  // ====================================================================

  /// Generates content for all selected platforms
  Future<void> generateContent() async {
    if (_selectedCompany == null) {
      _error = 'Please select a company';
      notifyListeners();
      return;
    }

    if (_selectedPlatforms.isEmpty) {
      _error = 'Please select at least one platform';
      notifyListeners();
      return;
    }

    if (_campaignPrompt.trim().isEmpty) {
      _error = 'Please enter a campaign prompt';
      notifyListeners();
      return;
    }

    _isGenerating = true;
    _error = null;

    // Initialize platform statuses
    for (final platform in _selectedPlatforms) {
      _platformStatus[platform] = PlatformGenerationStatus(status: 'generating');
    }
    notifyListeners();

    try {
      final startTime = DateTime.now();

      final result = await _client.campaign.generateCampaign(
        userId: _userId,
        companyProfileId: _selectedCompany!.id!,
        productId: _selectedProduct?.id,
        userPrompt: _campaignPrompt,
        selectedPlatforms: _selectedPlatforms,
        generateImage: _generateImage,
      );

      final endTime = DateTime.now();
      final totalDuration = endTime.difference(startTime).inMilliseconds / 1000;

      // Parse result
      final success = result.success;

      if (!success) {
        throw Exception(result.errorMessage ?? 'Generation failed');
      }

      _postId = result.postId;
      final platformContents = result.platformContents ?? {};
      _imagePrompt = result.imagePrompt;
      _originalImagePrompt = result.imagePrompt; // Save the original AI-generated prompt

      // Update platform statuses with generated content
      for (final platform in _selectedPlatforms) {
        final content = platformContents[platform];

        if (content != null) {
          _platformStatus[platform] = PlatformGenerationStatus(
            status: 'completed',
            content: content,
            generationTimeSeconds: totalDuration / _selectedPlatforms.length,
            characterCount: content.length,
          );

          // Store original content
          _originalContent[platform] = content;
        } else {
          _platformStatus[platform] = PlatformGenerationStatus(
            status: 'error',
            error: 'No content generated for this platform',
          );
        }
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to generate content: ${e.toString()}';
      debugPrint('Error generating content: $e');

      // Mark all platforms as error
      for (final platform in _selectedPlatforms) {
        _platformStatus[platform] = PlatformGenerationStatus(
          status: 'error',
          error: e.toString(),
        );
      }
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  /// Regenerates content for a single platform
  Future<void> regeneratePlatform(String platform) async {
    if (_postId == null) {
      _error = 'No post ID available for regeneration';
      notifyListeners();
      return;
    }

    // Set platform to generating
    _platformStatus[platform] = PlatformGenerationStatus(status: 'generating');
    _isRegenerating = true;
    notifyListeners();

    try {
      final startTime = DateTime.now();

      final result = await _client.campaign.regeneratePlatform(
        userId: _userId,
        postId: _postId!,
        platform: platform,
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds / 1000;

      final content = result.content;

      if (content != null) {
        _platformStatus[platform] = PlatformGenerationStatus(
          status: 'completed',
          content: content,
          generationTimeSeconds: duration,
          characterCount: content.length,
        );

        // Update original content and clear edits
        _originalContent[platform] = content;
        _editedContent.remove(platform);
      } else {
        throw Exception('No content received');
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to regenerate content: ${e.toString()}';
      debugPrint('Error regenerating platform $platform: $e');

      _platformStatus[platform] = PlatformGenerationStatus(
        status: 'error',
        error: e.toString(),
      );
    } finally {
      _isRegenerating = false;
      notifyListeners();
    }
  }

  /// Updates edited content for a platform
  void updateEditedContent(String platform, String content) {
    final currentStatus = _platformStatus[platform];

    if (currentStatus != null) {
      _platformStatus[platform] = PlatformGenerationStatus(
        status: 'completed',
        content: content,
        generationTimeSeconds: currentStatus.generationTimeSeconds,
        characterCount: content.length,
      );
      notifyListeners();
    }
  }

  /// Updates the image prompt (when user edits it)
  void updateImagePrompt(String prompt) {
    _imagePrompt = prompt;
    notifyListeners();
  }

  /// Reverts the image prompt back to the original AI-generated prompt
  void revertImagePromptToOriginal() {
    if (_originalImagePrompt != null) {
      _imagePrompt = _originalImagePrompt;
      notifyListeners();
    }
  }

  // ====================================================================
  // STEP 4: PUBLISHING OPTIONS
  // ====================================================================

  /// Checks which platforms are connected/authorized
  Future<void> checkPlatformConnections() async {
    try {
      // TODO: Implement actual platform connection check via API
      // For now, mock some connections
      _platformConnections = {
        'x': true,
        'linkedin': true,
        'instagram': false,
        'facebook': true,
        'pinterest': false,
      };
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking platform connections: $e');
    }
  }

  /// Toggles publish now vs schedule
  void setPublishNow(bool value) {
    _publishNow = value;
    if (value) {
      _scheduleTime = null; // Clear schedule time if publishing now
    }
    notifyListeners();
  }

  /// Sets the scheduled publish time
  void setScheduleTime(DateTime? time) {
    _scheduleTime = time;
    if (time != null) {
      _publishNow = false; // If scheduling, turn off publish now
    }
    notifyListeners();
  }

  // ====================================================================
  // NAVIGATION
  // ====================================================================

  /// Moves to next step
  void nextStep() {
    if (canGoNext && _currentStep < 3) {
      _currentStep++;
      _error = null;

      // Auto-check platform connections when entering step 4
      if (_currentStep == 3) {
        checkPlatformConnections();
      }

      notifyListeners();
    }
  }

  /// Moves to previous step
  void previousStep() {
    if (canGoPrevious) {
      _currentStep--;
      _error = null;
      notifyListeners();
    }
  }

  /// Goes to a specific step
  void goToStep(int step) {
    if (step >= 0 && step <= 3) {
      _currentStep = step;
      _error = null;
      notifyListeners();
    }
  }

  /// Validates current step before allowing navigation
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        // Step 1: Must have company selected
        return _selectedCompany != null;

      case 1:
        // Step 2: Must have prompt and at least one platform
        return _campaignPrompt.trim().isNotEmpty &&
            _selectedPlatforms.isNotEmpty;

      case 2:
        // Step 3: Must have generated content
        return hasGeneratedContent;

      case 3:
        // Step 4: Always valid (can save draft or publish)
        return true;

      default:
        return false;
    }
  }

  // ====================================================================
  // UTILITY METHODS
  // ====================================================================

  /// Gets content for a specific platform
  String? getContentForPlatform(String platform) {
    return _platformStatus[platform]?.content;
  }

  /// Gets the current (possibly edited) content for a platform
  String? getGeneratedContent(String platform) {
    // Return edited content if available, otherwise return original
    return _editedContent[platform] ?? _platformStatus[platform]?.content;
  }

  /// Gets the original AI-generated content for a platform
  String? getOriginalContent(String platform) {
    return _originalContent[platform];
  }

  /// Checks if content has been edited for a platform
  bool hasBeenEdited(String platform) {
    return _editedContent.containsKey(platform);
  }

  /// Updates content for a platform (when user edits)
  void updateContent(String platform, String content) {
    _editedContent[platform] = content;

    // Update the platform status content as well
    final currentStatus = _platformStatus[platform];
    if (currentStatus != null) {
      _platformStatus[platform] = PlatformGenerationStatus(
        status: 'completed',
        content: content,
        generationTimeSeconds: currentStatus.generationTimeSeconds,
        characterCount: content.length,
      );
    }

    notifyListeners();
  }

  /// Reverts content to original AI-generated version
  void revertToOriginal(String platform) {
    _editedContent.remove(platform);

    final originalContent = _originalContent[platform];
    if (originalContent != null) {
      final currentStatus = _platformStatus[platform];
      if (currentStatus != null) {
        _platformStatus[platform] = PlatformGenerationStatus(
          status: 'completed',
          content: originalContent,
          generationTimeSeconds: currentStatus.generationTimeSeconds,
          characterCount: originalContent.length,
        );
      }
    }

    notifyListeners();
  }

  /// Regenerates image prompt
  Future<void> regenerateImagePrompt() async {
    if (_postId == null) {
      _error = 'No post ID available for regeneration';
      notifyListeners();
      return;
    }

    _isRegenerating = true;
    notifyListeners();

    try {
      // TODO: Implement actual image prompt regeneration API call
      // For now, just simulate a delay
      await Future.delayed(const Duration(seconds: 2));

      // This is a placeholder - replace with actual API call when available
      _imagePrompt = 'Regenerated image prompt: ${DateTime.now()}';
      _originalImagePrompt = _imagePrompt;

      _error = null;
    } catch (e) {
      _error = 'Failed to regenerate image prompt: ${e.toString()}';
      debugPrint('Error regenerating image prompt: $e');
    } finally {
      _isRegenerating = false;
      notifyListeners();
    }
  }

  /// Checks if a platform is connected
  bool isPlatformConnected(String platform) {
    return _platformConnections[platform] ?? false;
  }

  /// Gets unconnected platforms from selected platforms
  List<String> getUnconnectedPlatforms() {
    return _selectedPlatforms
        .where((platform) => !isPlatformConnected(platform))
        .toList();
  }

  /// Parses key features from JSON string
  static List<String> parseKeyFeatures(String keyFeaturesJson) {
    try {
      final decoded = jsonDecode(keyFeaturesJson);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Clears error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Resets the entire wizard to initial state
  void reset() {
    _currentStep = 0;
    _selectedCompany = null;
    _selectedProduct = null;
    _companies = [];
    _products = [];
    _campaignPrompt = '';
    _selectedPlatforms = [];
    _generateImage = true;
    _platformStatus = {};
    _originalContent = {};
    _editedContent = {};
    _imagePrompt = null;
    _originalImagePrompt = null;
    _postId = null;
    _publishNow = false;
    _scheduleTime = null;
    _platformConnections = {};
    _isLoading = false;
    _error = null;
    _isGenerating = false;
    _isRegenerating = false;
    notifyListeners();
  }

  /// Validates all required data before final submission
  bool validateForSubmission() {
    if (_selectedCompany == null) {
      _error = 'Company not selected';
      notifyListeners();
      return false;
    }

    if (_selectedPlatforms.isEmpty) {
      _error = 'No platforms selected';
      notifyListeners();
      return false;
    }

    if (!hasGeneratedContent) {
      _error = 'No content generated';
      notifyListeners();
      return false;
    }

    if (!_publishNow && _scheduleTime == null) {
      _error = 'Please select publish now or set a schedule time';
      notifyListeners();
      return false;
    }

    final unconnected = getUnconnectedPlatforms();
    if (unconnected.isNotEmpty) {
      _error = 'Some platforms are not connected: ${unconnected.join(', ')}';
      notifyListeners();
      return false;
    }

    return true;
  }
}
