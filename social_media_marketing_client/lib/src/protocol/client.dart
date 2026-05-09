/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:social_media_marketing_client/src/protocol/ai_interaction_log.dart'
    as _i5;
import 'package:social_media_marketing_client/src/protocol/user.dart' as _i6;
import 'package:social_media_marketing_client/src/protocol/campaign_generation_result.dart'
    as _i7;
import 'package:social_media_marketing_client/src/protocol/platform_content.dart'
    as _i8;
import 'package:social_media_marketing_client/src/protocol/company_profile.dart'
    as _i9;
import 'package:social_media_marketing_client/src/protocol/product.dart'
    as _i10;
import 'package:social_media_marketing_client/src/protocol/social_media_connection.dart'
    as _i11;
import 'package:social_media_marketing_client/src/protocol/post.dart' as _i12;
import 'package:social_media_marketing_client/src/protocol/organization.dart'
    as _i13;
import 'package:social_media_marketing_client/src/protocol/greetings/greeting.dart'
    as _i14;
import 'protocol.dart' as _i15;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Endpoint for viewing AI interaction logs.
///
/// Provides read-only access to AI interaction history with filtering and pagination.
/// Logs are linked to posts, and access is controlled through post ownership.
/// {@category Endpoint}
class EndpointAILogs extends _i2.EndpointRef {
  EndpointAILogs(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'aILogs';

  /// Lists AI interaction logs with optional filtering.
  ///
  /// Parameters:
  /// - [userId] - User making the request (for access control)
  /// - [limit] - Max number of logs to return (default: 50, max: 200)
  /// - [offset] - Pagination offset (default: 0)
  /// - [interactionType] - Filter by type (initial_generation, edit_request, image_generation)
  /// - [startDate] - Filter logs after this date
  /// - [endDate] - Filter logs before this date
  /// - [postId] - Optional filter by specific post
  ///
  /// Returns: List of AIInteractionLog objects ordered by timestamp DESC
  ///
  /// Throws:
  /// - [Exception] if user not found
  _i3.Future<List<_i5.AIInteractionLog>> getLogs({
    required int userId,
    int? limit,
    int? offset,
    String? interactionType,
    DateTime? startDate,
    DateTime? endDate,
    int? postId,
  }) => caller.callServerEndpoint<List<_i5.AIInteractionLog>>(
    'aILogs',
    'getLogs',
    {
      'userId': userId,
      'limit': limit,
      'offset': offset,
      'interactionType': interactionType,
      'startDate': startDate,
      'endDate': endDate,
      'postId': postId,
    },
  );

  /// Gets total cost of AI interactions for a user.
  ///
  /// Calculates the sum of all AI interaction costs for posts owned by the user.
  ///
  /// Parameters:
  /// - [userId] - User making the request
  /// - [startDate] - Include logs after this date
  /// - [endDate] - Include logs before this date
  /// - [postId] - Optional filter by specific post
  ///
  /// Returns: Total cost in USD
  ///
  /// Throws:
  /// - [Exception] if user not found
  _i3.Future<double> getTotalCost({
    required int userId,
    DateTime? startDate,
    DateTime? endDate,
    int? postId,
  }) => caller.callServerEndpoint<double>(
    'aILogs',
    'getTotalCost',
    {
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
      'postId': postId,
    },
  );

  /// Gets detailed information about a specific log entry.
  ///
  /// Verifies that the user has access to the post associated with this log.
  ///
  /// Parameters:
  /// - [userId] - User making the request (for access control)
  /// - [logId] - ID of the log to retrieve
  ///
  /// Returns: AIInteractionLog or null if not found/not authorized
  ///
  /// Throws:
  /// - [Exception] if unauthorized access attempt
  _i3.Future<_i5.AIInteractionLog?> getLog({
    required int userId,
    required int logId,
  }) => caller.callServerEndpoint<_i5.AIInteractionLog?>(
    'aILogs',
    'getLog',
    {
      'userId': userId,
      'logId': logId,
    },
  );

  /// Gets statistics about AI usage for a user.
  ///
  /// Returns aggregated data including:
  /// - Total interactions
  /// - Total cost
  /// - Breakdown by interaction type
  /// - Average cost per interaction
  ///
  /// Parameters:
  /// - [userId] - User making the request
  /// - [startDate] - Include logs after this date
  /// - [endDate] - Include logs before this date
  ///
  /// Returns: Map with statistics
  _i3.Future<Map<String, dynamic>> getStatistics({
    required int userId,
    DateTime? startDate,
    DateTime? endDate,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'aILogs',
    'getStatistics',
    {
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
    },
  );
}

/// Authentication endpoint for user registration, login, and session management.
///
/// Provides secure authentication with bcrypt password hashing and
/// organization-based multi-tenancy support.
///
/// Example usage from client:
/// ```dart
/// // Register new user and organization
/// final session = await client.auth.register(
///   email: 'admin@company.com',
///   password: 'secure_password',
///   fullName: 'John Doe',
///   organizationName: 'Acme Corp',
/// );
///
/// // Login existing user
/// final session = await client.auth.login(
///   email: 'admin@company.com',
///   password: 'secure_password',
///   );
/// ```
/// {@category Endpoint}
class EndpointAuth extends _i2.EndpointRef {
  EndpointAuth(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Registers a new user and creates a new organization.
  ///
  /// This is the initial signup flow - it creates both a user account
  /// and a new organization, making the user an admin of that organization.
  ///
  /// Parameters:
  /// - [email] - User's email address (must be unique)
  /// - [password] - Plain text password (will be hashed)
  /// - [fullName] - User's full name
  /// - [organizationName] - Name for the new organization
  ///
  /// Returns: The newly created [User] object (without password hash)
  ///
  /// Throws:
  /// - [Exception] if email already exists
  /// - [Exception] if validation fails
  _i3.Future<_i6.User> register({
    required String email,
    required String password,
    required String fullName,
    required String organizationName,
  }) => caller.callServerEndpoint<_i6.User>(
    'auth',
    'register',
    {
      'email': email,
      'password': password,
      'fullName': fullName,
      'organizationName': organizationName,
    },
  );

  /// Authenticates a user and returns session information.
  ///
  /// Verifies email and password, then returns the authenticated user
  /// if credentials are valid.
  ///
  /// Parameters:
  /// - [email] - User's email address
  /// - [password] - Plain text password
  ///
  /// Returns: Authenticated [User] object (without password hash)
  ///
  /// Throws:
  /// - [Exception] if credentials are invalid
  /// - [Exception] if account is inactive
  _i3.Future<_i6.User> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i6.User>(
    'auth',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Logs out the current user session.
  ///
  /// Cleans up any session-related resources.
  ///
  /// Returns: Success message
  _i3.Future<String> logout() => caller.callServerEndpoint<String>(
    'auth',
    'logout',
    {},
  );

  /// Gets user information by user ID.
  ///
  /// Parameters:
  /// - [userId] - The user ID to fetch
  ///
  /// Returns: [User] object with organization details
  ///
  /// Throws:
  /// - [Exception] if user not found
  _i3.Future<_i6.User> getCurrentUser({required int userId}) =>
      caller.callServerEndpoint<_i6.User>(
        'auth',
        'getCurrentUser',
        {'userId': userId},
      );

  /// Changes the current user's password.
  ///
  /// Requires authentication and current password verification.
  ///
  /// Parameters:
  /// - [currentPassword] - Current password for verification
  /// - [newPassword] - New password to set
  ///
  /// Returns: Success message
  ///
  /// Throws:
  /// - [Exception] if current password is invalid
  /// - [Exception] if new password doesn't meet requirements
  _i3.Future<String> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) => caller.callServerEndpoint<String>(
    'auth',
    'changePassword',
    {
      'userId': userId,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    },
  );

  /// Updates current user's profile information.
  ///
  /// Requires authentication.
  ///
  /// Parameters:
  /// - [fullName] - Optional new full name
  /// - [email] - Optional new email (must be unique)
  ///
  /// Returns: Updated [User] object
  _i3.Future<_i6.User> updateProfile({
    required int userId,
    String? fullName,
    String? email,
  }) => caller.callServerEndpoint<_i6.User>(
    'auth',
    'updateProfile',
    {
      'userId': userId,
      'fullName': fullName,
      'email': email,
    },
  );
}

/// Campaign endpoint for generating AI-powered social media content.
///
/// Provides methods for:
/// - Generating multi-platform campaigns with AI
/// - Regenerating content for individual platforms
/// - Managing campaign creation workflow
///
/// Example usage from client:
/// ```dart
/// final result = await client.campaign.generateCampaign(
///   request: CampaignRequest(
///     companyProfileId: 1,
///     productId: 2,
///     userPrompt: 'Launch announcement for new product',
///     selectedPlatforms: ['x', 'linkedin', 'instagram'],
///     generateImage: true,
///   ),
/// );
/// ```
/// {@category Endpoint}
class EndpointCampaign extends _i2.EndpointRef {
  EndpointCampaign(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'campaign';

  /// Generates a complete campaign with AI content for all selected platforms.
  ///
  /// This is the main method for the Campaign Creation Wizard. It:
  /// 1. Validates user has access to the company profile
  /// 2. Loads company and product information
  /// 3. Calls Gemini AI to generate platform-specific content
  /// 4. Creates a draft Post in the database
  /// 5. Logs all AI interactions
  /// 6. Optionally generates image prompt
  ///
  /// Parameters:
  /// - [userId] - Current user ID (from session)
  /// - [companyProfileId] - Company profile to use for brand context
  /// - [productId] - Optional product for targeted content
  /// - [userPrompt] - User's content request/description
  /// - [selectedPlatforms] - List of platforms (x, linkedin, instagram, facebook, pinterest)
  /// - [generateImage] - Whether to generate image prompt (default: true)
  /// - [title] - Optional post title (auto-generated if not provided)
  ///
  /// Returns: CampaignGenerationResult with all generated content and post ID
  ///
  /// Throws:
  /// - [Exception] if user doesn't have access to company profile
  /// - [Exception] if company profile or product not found
  /// - [Exception] if AI generation fails
  _i3.Future<_i7.CampaignGenerationResult> generateCampaign({
    required int userId,
    required int companyProfileId,
    int? productId,
    required String userPrompt,
    required List<String> selectedPlatforms,
    required bool generateImage,
    String? title,
  }) => caller.callServerEndpoint<_i7.CampaignGenerationResult>(
    'campaign',
    'generateCampaign',
    {
      'userId': userId,
      'companyProfileId': companyProfileId,
      'productId': productId,
      'userPrompt': userPrompt,
      'selectedPlatforms': selectedPlatforms,
      'generateImage': generateImage,
      'title': title,
    },
  );

  /// Regenerates content for a single platform.
  ///
  /// Used when user wants to regenerate or edit content for one platform
  /// without affecting other platforms.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - Existing post ID
  /// - [platform] - Platform to regenerate (x, linkedin, etc.)
  /// - [newPrompt] - Optional new prompt (uses original if not provided)
  ///
  /// Returns: PlatformContent with updated content
  ///
  /// Throws:
  /// - [Exception] if post not found or access denied
  /// - [Exception] if platform not in selected platforms
  _i3.Future<_i8.PlatformContent> regeneratePlatform({
    required int userId,
    required int postId,
    required String platform,
    String? newPrompt,
  }) => caller.callServerEndpoint<_i8.PlatformContent>(
    'campaign',
    'regeneratePlatform',
    {
      'userId': userId,
      'postId': postId,
      'platform': platform,
      'newPrompt': newPrompt,
    },
  );

  /// Edits existing platform content based on user feedback.
  ///
  /// Uses AI to edit content while maintaining platform best practices.
  ///
  /// Parameters:
  /// - [userId] - Current user ID
  /// - [postId] - Existing post ID
  /// - [platform] - Platform to edit
  /// - [editRequest] - User's edit instructions (e.g., "make it shorter", "add emoji")
  ///
  /// Returns: PlatformContent with edited content
  _i3.Future<_i8.PlatformContent> editPlatformContent({
    required int userId,
    required int postId,
    required String platform,
    required String editRequest,
  }) => caller.callServerEndpoint<_i8.PlatformContent>(
    'campaign',
    'editPlatformContent',
    {
      'userId': userId,
      'postId': postId,
      'platform': platform,
      'editRequest': editRequest,
    },
  );
}

/// Company Profile endpoint for managing company brand information.
///
/// Provides CRUD operations for company profiles within an organization.
/// Company profiles contain brand voice, description, and uploaded files
/// that are used as context for AI content generation.
///
/// Example usage from client:
/// ```dart
/// // List all company profiles for organization
/// final profiles = await client.company.listCompanyProfiles(
///   userId: currentUser.id,
/// );
///
/// // Create new company profile
/// final profile = await client.company.createCompanyProfile(
///   userId: currentUser.id,
///   name: 'Acme Corp',
///   description: 'Leading provider of innovative solutions',
///   brandVoice: 'Professional, friendly, innovative',
///   uploadedFiles: ['file1.pdf', 'logo.png'],
/// );
/// ```
/// {@category Endpoint}
class EndpointCompany extends _i2.EndpointRef {
  EndpointCompany(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'company';

  /// Lists all company profiles for the user's organization.
  ///
  /// Returns company profiles filtered by the user's organization ID
  /// to ensure multi-tenant isolation.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (to get organization ID)
  ///
  /// Returns: List of CompanyProfile objects
  ///
  /// Throws:
  /// - [Exception] if user not found
  _i3.Future<List<_i9.CompanyProfile>> listCompanyProfiles({
    required int userId,
  }) => caller.callServerEndpoint<List<_i9.CompanyProfile>>(
    'company',
    'listCompanyProfiles',
    {'userId': userId},
  );

  /// Gets a single company profile by ID.
  ///
  /// Validates that the user has access to this company profile
  /// via their organization.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID to retrieve
  ///
  /// Returns: CompanyProfile object
  ///
  /// Throws:
  /// - [Exception] if profile not found
  /// - [Exception] if access denied
  _i3.Future<_i9.CompanyProfile> getCompanyProfile({
    required int userId,
    required int companyProfileId,
  }) => caller.callServerEndpoint<_i9.CompanyProfile>(
    'company',
    'getCompanyProfile',
    {
      'userId': userId,
      'companyProfileId': companyProfileId,
    },
  );

  /// Creates a new company profile.
  ///
  /// Creates a company profile within the user's organization.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (to get organization ID)
  /// - [name] - Company name (required)
  /// - [description] - Company description (optional)
  /// - [brandVoice] - Brand voice guidelines (optional)
  /// - [uploadedFiles] - List of uploaded file references (optional)
  ///
  /// Returns: Created CompanyProfile object
  ///
  /// Throws:
  /// - [Exception] if validation fails
  /// - [Exception] if user not found
  _i3.Future<_i9.CompanyProfile> createCompanyProfile({
    required int userId,
    required String name,
    String? description,
    String? brandVoice,
    List<String>? uploadedFiles,
  }) => caller.callServerEndpoint<_i9.CompanyProfile>(
    'company',
    'createCompanyProfile',
    {
      'userId': userId,
      'name': name,
      'description': description,
      'brandVoice': brandVoice,
      'uploadedFiles': uploadedFiles,
    },
  );

  /// Updates an existing company profile.
  ///
  /// Updates specified fields of a company profile. Only the user's
  /// organization profiles can be updated.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID to update
  /// - [name] - New company name (optional)
  /// - [description] - New description (optional)
  /// - [brandVoice] - New brand voice (optional)
  /// - [uploadedFiles] - New uploaded files list (optional)
  ///
  /// Returns: Updated CompanyProfile object
  ///
  /// Throws:
  /// - [Exception] if profile not found or access denied
  /// - [Exception] if validation fails
  _i3.Future<_i9.CompanyProfile> updateCompanyProfile({
    required int userId,
    required int companyProfileId,
    String? name,
    String? description,
    String? brandVoice,
    List<String>? uploadedFiles,
  }) => caller.callServerEndpoint<_i9.CompanyProfile>(
    'company',
    'updateCompanyProfile',
    {
      'userId': userId,
      'companyProfileId': companyProfileId,
      'name': name,
      'description': description,
      'brandVoice': brandVoice,
      'uploadedFiles': uploadedFiles,
    },
  );

  /// Deletes a company profile.
  ///
  /// Deletes a company profile and all associated data. This operation
  /// cannot be undone.
  ///
  /// Note: This will fail if there are products or posts referencing
  /// this company profile due to foreign key constraints.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID to delete
  ///
  /// Returns: Success message
  ///
  /// Throws:
  /// - [Exception] if profile not found or access denied
  /// - [Exception] if there are dependent records
  _i3.Future<String> deleteCompanyProfile({
    required int userId,
    required int companyProfileId,
  }) => caller.callServerEndpoint<String>(
    'company',
    'deleteCompanyProfile',
    {
      'userId': userId,
      'companyProfileId': companyProfileId,
    },
  );

  /// Gets all products for a company profile.
  ///
  /// Convenience method to get products associated with a company profile.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID
  ///
  /// Returns: List of Product objects
  _i3.Future<List<_i10.Product>> getCompanyProducts({
    required int userId,
    required int companyProfileId,
  }) => caller.callServerEndpoint<List<_i10.Product>>(
    'company',
    'getCompanyProducts',
    {
      'userId': userId,
      'companyProfileId': companyProfileId,
    },
  );
}

/// Connections endpoint for managing social media platform connections via Postiz.
///
/// Provides methods for:
/// - Listing all platform connections for a user's organization
/// - Syncing connections from Postiz API
/// - Disconnecting platforms (removing from DB only)
/// - Checking connection status for all platforms
///
/// Example usage from client:
/// ```dart
/// // Sync connections from Postiz
/// final connections = await client.connections.syncFromPostiz(
///   userId: currentUser.id,
/// );
///
/// // List all connections
/// final allConnections = await client.connections.listConnections(
///   userId: currentUser.id,
/// );
///
/// // Check platform status
/// final status = await client.connections.getConnectionStatus(
///   userId: currentUser.id,
/// );
/// print('Instagram connected: ${status['instagram']}');
///
/// // Disconnect a platform
/// await client.connections.disconnectPlatform(
///   userId: currentUser.id,
///   connectionId: 123,
/// );
/// ```
/// {@category Endpoint}
class EndpointConnections extends _i2.EndpointRef {
  EndpointConnections(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'connections';

  /// Lists all social media platform connections for the user's organization.
  ///
  /// This method retrieves all active and inactive connections that belong to
  /// the user's organization. Connections are linked via organizationId.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (used to determine organization)
  ///
  /// Returns: List of SocialMediaConnection objects
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if user doesn't belong to an organization
  _i3.Future<List<_i11.SocialMediaConnection>> listConnections({
    required int userId,
  }) => caller.callServerEndpoint<List<_i11.SocialMediaConnection>>(
    'connections',
    'listConnections',
    {'userId': userId},
  );

  /// Syncs platform connections from Postiz API.
  ///
  /// This is the primary way connections are added to the system. The method:
  /// 1. Validates user and loads organization
  /// 2. Checks organization has Postiz API key configured
  /// 3. Calls Postiz API to get all integrations
  /// 4. Creates or updates SocialMediaConnection records
  /// 5. Maps Postiz integration data to our model
  ///
  /// Postiz Integration Mapping:
  /// - `providerIdentifier` → our `platform` field
  /// - `name` → our `platformUsername` field
  /// - `id` → our `postizIntegrationId` field
  /// - `picture` → stored in platformUserId temporarily (should be separate field)
  ///
  /// Parameters:
  /// - [userId] - Current user ID
  ///
  /// Returns: List of synced SocialMediaConnection objects
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if organization not found
  /// - [Exception] if Postiz API key not configured
  /// - [PostizApiException] if Postiz API call fails
  _i3.Future<List<_i11.SocialMediaConnection>> syncFromPostiz({
    required int userId,
  }) => caller.callServerEndpoint<List<_i11.SocialMediaConnection>>(
    'connections',
    'syncFromPostiz',
    {'userId': userId},
  );

  /// Disconnects a platform by removing the connection record.
  ///
  /// NOTE: This only removes the connection from our database. It does NOT
  /// disconnect the integration from Postiz. Users must disconnect from
  /// Postiz directly if they want to revoke access.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [connectionId] - ID of the connection to remove
  ///
  /// Returns: void
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if connection not found
  /// - [Exception] if user doesn't have access to this connection
  _i3.Future<void> disconnectPlatform({
    required int userId,
    required int connectionId,
  }) => caller.callServerEndpoint<void>(
    'connections',
    'disconnectPlatform',
    {
      'userId': userId,
      'connectionId': connectionId,
    },
  );

  /// Checks which platforms are connected for the user's organization.
  ///
  /// Returns a map of platform names to their connection status.
  /// Supports the following platforms:
  /// - x (Twitter/X)
  /// - linkedin
  /// - instagram
  /// - facebook
  /// - pinterest
  ///
  /// Parameters:
  /// - [userId] - Current user ID
  ///
  /// Returns: `Map<String, bool>` where key is platform name and value is connected status
  ///
  /// Throws:
  /// - [Exception] if user not found
  _i3.Future<Map<String, bool>> getConnectionStatus({required int userId}) =>
      caller.callServerEndpoint<Map<String, bool>>(
        'connections',
        'getConnectionStatus',
        {'userId': userId},
      );
}

/// Post endpoint for managing social media posts (CRUD operations).
///
/// Provides methods for:
/// - Listing posts with filtering and pagination
/// - Getting a single post by ID
/// - Updating post details (status, schedule, content)
/// - Deleting posts
/// - Duplicating posts
/// - Publishing posts immediately
///
/// Example usage from client:
/// ```dart
/// // List posts with filters
/// final posts = await client.post.listPosts(
///   userId: 1,
///   statusFilter: ['draft', 'scheduled'],
///   platformFilter: ['x', 'linkedin'],
///   limit: 50,
/// );
///
/// // Get single post
/// final post = await client.post.getPost(
///   userId: 1,
///   postId: 123,
/// );
///
/// // Update post
/// final updated = await client.post.updatePost(
///   userId: 1,
///   postId: 123,
///   status: 'scheduled',
///   scheduleTime: DateTime.now().add(Duration(hours: 2)),
/// );
/// ```
/// {@category Endpoint}
class EndpointPost extends _i2.EndpointRef {
  EndpointPost(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'post';

  /// Lists posts with filtering and pagination.
  ///
  /// This method retrieves posts for a specific user with various filtering
  /// options. All posts are filtered by organization to ensure data isolation.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (used for organization validation)
  /// - [statusFilter] - Optional list of statuses to filter by (draft, scheduled, published, failed)
  /// - [platformFilter] - Optional list of platforms to filter by (x, linkedin, instagram, facebook, pinterest)
  /// - [startDate] - Optional start date for filtering by createdAt
  /// - [endDate] - Optional end date for filtering by createdAt
  /// - [searchQuery] - Optional text search in title and content
  /// - [limit] - Maximum number of posts to return (default: 50, max: 200)
  /// - [offset] - Number of posts to skip for pagination (default: 0)
  ///
  /// Returns: List of Post objects matching the filters, ordered by createdAt DESC
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if invalid status or platform values provided
  _i3.Future<List<_i12.Post>> listPosts({
    required int userId,
    List<String>? statusFilter,
    List<String>? platformFilter,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i12.Post>>(
    'post',
    'listPosts',
    {
      'userId': userId,
      'statusFilter': statusFilter,
      'platformFilter': platformFilter,
      'startDate': startDate,
      'endDate': endDate,
      'searchQuery': searchQuery,
      'limit': limit,
      'offset': offset,
    },
  );

  /// Gets a single post by ID.
  ///
  /// Validates that the user has access to the post through their organization.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to retrieve
  ///
  /// Returns: Post object or null if not found or user doesn't have access
  ///
  /// Throws:
  /// - [Exception] if user not found
  _i3.Future<_i12.Post?> getPost({
    required int userId,
    required int postId,
  }) => caller.callServerEndpoint<_i12.Post?>(
    'post',
    'getPost',
    {
      'userId': userId,
      'postId': postId,
    },
  );

  /// Updates an existing post.
  ///
  /// Allows updating post status, schedule time, edited content, and title.
  /// User must own the post (through organization).
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to update
  /// - [status] - Optional new status (draft, scheduled, published, failed)
  /// - [scheduleTime] - Optional new schedule time
  /// - [editedContent] - Optional map of platform-specific edited content
  /// - [title] - Optional new title
  ///
  /// Returns: Updated Post object
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if post not found
  /// - [Exception] if user doesn't have access to the post
  /// - [Exception] if invalid status value
  _i3.Future<_i12.Post> updatePost({
    required int userId,
    required int postId,
    String? status,
    DateTime? scheduleTime,
    Map<String, String>? editedContent,
    String? title,
  }) => caller.callServerEndpoint<_i12.Post>(
    'post',
    'updatePost',
    {
      'userId': userId,
      'postId': postId,
      'status': status,
      'scheduleTime': scheduleTime,
      'editedContent': editedContent,
      'title': title,
    },
  );

  /// Deletes a post.
  ///
  /// User must own the post (through organization).
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to delete
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if post not found
  /// - [Exception] if user doesn't have access to the post
  _i3.Future<void> deletePost({
    required int userId,
    required int postId,
  }) => caller.callServerEndpoint<void>(
    'post',
    'deletePost',
    {
      'userId': userId,
      'postId': postId,
    },
  );

  /// Duplicates an existing post.
  ///
  /// Creates a copy of the post with all fields except id, createdAt.
  /// The new post is set to 'draft' status with cleared publishing timestamps.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to duplicate
  ///
  /// Returns: New Post object (the duplicate)
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if post not found
  /// - [Exception] if user doesn't have access to the post
  _i3.Future<_i12.Post> duplicatePost({
    required int userId,
    required int postId,
  }) => caller.callServerEndpoint<_i12.Post>(
    'post',
    'duplicatePost',
    {
      'userId': userId,
      'postId': postId,
    },
  );

  /// Publishes a post immediately by scheduling it for now.
  ///
  /// Sets the post status to 'scheduled' and scheduleTime to current time.
  /// This triggers the publishing workflow.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to publish
  ///
  /// Returns: Updated Post object
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if post not found
  /// - [Exception] if user doesn't have access to the post
  _i3.Future<_i12.Post> publishNow({
    required int userId,
    required int postId,
  }) => caller.callServerEndpoint<_i12.Post>(
    'post',
    'publishNow',
    {
      'userId': userId,
      'postId': postId,
    },
  );
}

/// Product endpoint for managing products within company profiles.
///
/// Provides CRUD operations for products that are used to generate
/// targeted marketing content. Products belong to company profiles.
///
/// Example usage from client:
/// ```dart
/// // List all products for a company
/// final products = await client.product.listProducts(
///   userId: currentUser.id,
///   companyProfileId: 1,
/// );
///
/// // Create new product
/// final product = await client.product.createProduct(
///   userId: currentUser.id,
///   companyProfileId: 1,
///   name: 'Premium Widget',
///   description: 'High-quality widget for professionals',
///   targetAudience: 'Business professionals, age 30-50',
///   keyFeatures: ['Durable', 'Easy to use', 'Cost-effective'],
/// );
/// ```
/// {@category Endpoint}
class EndpointProduct extends _i2.EndpointRef {
  EndpointProduct(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  /// Lists all products for a company profile.
  ///
  /// Returns products filtered by company profile ID. Also validates
  /// that the user has access to this company profile.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID
  ///
  /// Returns: List of Product objects
  ///
  /// Throws:
  /// - [Exception] if user doesn't have access to company profile
  _i3.Future<List<_i10.Product>> listProducts({
    required int userId,
    required int companyProfileId,
  }) => caller.callServerEndpoint<List<_i10.Product>>(
    'product',
    'listProducts',
    {
      'userId': userId,
      'companyProfileId': companyProfileId,
    },
  );

  /// Gets a single product by ID.
  ///
  /// Validates that the user has access to the company profile
  /// that owns this product.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [productId] - Product ID to retrieve
  ///
  /// Returns: Product object
  ///
  /// Throws:
  /// - [Exception] if product not found
  /// - [Exception] if access denied
  _i3.Future<_i10.Product> getProduct({
    required int userId,
    required int productId,
  }) => caller.callServerEndpoint<_i10.Product>(
    'product',
    'getProduct',
    {
      'userId': userId,
      'productId': productId,
    },
  );

  /// Creates a new product.
  ///
  /// Creates a product within a company profile. The user must have
  /// access to the company profile.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID this product belongs to
  /// - [name] - Product name (required)
  /// - [description] - Product description (optional)
  /// - [targetAudience] - Target audience description (optional)
  /// - [keyFeatures] - List of key features (optional)
  /// - [category] - Product category (optional)
  ///
  /// Returns: Created Product object
  ///
  /// Throws:
  /// - [Exception] if validation fails
  /// - [Exception] if user doesn't have access to company profile
  _i3.Future<_i10.Product> createProduct({
    required int userId,
    required int companyProfileId,
    required String name,
    String? description,
    String? targetAudience,
    List<String>? keyFeatures,
    String? category,
  }) => caller.callServerEndpoint<_i10.Product>(
    'product',
    'createProduct',
    {
      'userId': userId,
      'companyProfileId': companyProfileId,
      'name': name,
      'description': description,
      'targetAudience': targetAudience,
      'keyFeatures': keyFeatures,
      'category': category,
    },
  );

  /// Updates an existing product.
  ///
  /// Updates specified fields of a product. The user must have access
  /// to the company profile that owns this product.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [productId] - Product ID to update
  /// - [name] - New product name (optional)
  /// - [description] - New description (optional)
  /// - [targetAudience] - New target audience (optional)
  /// - [keyFeatures] - New key features list (optional)
  /// - [category] - New product category (optional)
  ///
  /// Returns: Updated Product object
  ///
  /// Throws:
  /// - [Exception] if product not found or access denied
  /// - [Exception] if validation fails
  _i3.Future<_i10.Product> updateProduct({
    required int userId,
    required int productId,
    String? name,
    String? description,
    String? targetAudience,
    List<String>? keyFeatures,
    String? category,
  }) => caller.callServerEndpoint<_i10.Product>(
    'product',
    'updateProduct',
    {
      'userId': userId,
      'productId': productId,
      'name': name,
      'description': description,
      'targetAudience': targetAudience,
      'keyFeatures': keyFeatures,
      'category': category,
    },
  );

  /// Deletes a product.
  ///
  /// Deletes a product. This operation cannot be undone.
  ///
  /// Note: This will fail if there are posts referencing this product
  /// due to foreign key constraints.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [productId] - Product ID to delete
  ///
  /// Returns: Success message
  ///
  /// Throws:
  /// - [Exception] if product not found or access denied
  /// - [Exception] if there are dependent posts
  _i3.Future<String> deleteProduct({
    required int userId,
    required int productId,
  }) => caller.callServerEndpoint<String>(
    'product',
    'deleteProduct',
    {
      'userId': userId,
      'productId': productId,
    },
  );

  /// Gets all posts that use this product.
  ///
  /// Convenience method to get posts associated with a product.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [productId] - Product ID
  ///
  /// Returns: List of Post objects
  _i3.Future<List<_i12.Post>> getProductPosts({
    required int userId,
    required int productId,
  }) => caller.callServerEndpoint<List<_i12.Post>>(
    'product',
    'getProductPosts',
    {
      'userId': userId,
      'productId': productId,
    },
  );
}

/// Settings endpoint for user and organization settings management.
///
/// Provides methods for:
/// - Getting user profile and organization information
/// - Updating user profile (name, email)
/// - Changing user password
/// - Updating organization settings (admin only)
/// - Deactivating user accounts
///
/// Example usage from client:
/// ```dart
/// // Get user settings
/// final settings = await client.settings.getUserSettings(userId: 1);
///
/// // Update user profile
/// final updatedUser = await client.settings.updateUserProfile(
///   userId: 1,
///   fullName: 'Jane Doe',
///   email: 'jane@example.com',
/// );
///
/// // Change password
/// await client.settings.updatePassword(
///   userId: 1,
///   currentPassword: 'old_password',
///   newPassword: 'new_secure_password',
/// );
///
/// // Update organization (admin only)
/// final updatedOrg = await client.settings.updateOrganization(
///   userId: 1,
///   name: 'New Company Name',
///   postizApiKey: 'new_api_key',
/// );
/// ```
/// {@category Endpoint}
class EndpointSettings extends _i2.EndpointRef {
  EndpointSettings(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'settings';

  /// Gets user profile and organization information.
  ///
  /// Returns both the user profile and their organization details
  /// in a single call for the settings page.
  ///
  /// Parameters:
  /// - [userId] - The user ID to fetch settings for
  ///
  /// Returns: Map containing:
  /// - 'user': User object without password hash
  /// - 'organization': Organization object
  ///
  /// Throws:
  /// - [Exception] if user or organization not found
  _i3.Future<Map<String, dynamic>> getUserSettings({required int userId}) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'settings',
        'getUserSettings',
        {'userId': userId},
      );

  /// Updates user's name and email.
  ///
  /// Allows users to update their profile information. Email must be
  /// unique across the system.
  ///
  /// Parameters:
  /// - [userId] - User ID to update
  /// - [fullName] - Optional new full name
  /// - [email] - Optional new email address
  ///
  /// Returns: Updated User object without password hash
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if email is already in use
  /// - [Exception] if email format is invalid
  _i3.Future<_i6.User> updateUserProfile({
    required int userId,
    String? fullName,
    String? email,
  }) => caller.callServerEndpoint<_i6.User>(
    'settings',
    'updateUserProfile',
    {
      'userId': userId,
      'fullName': fullName,
      'email': email,
    },
  );

  /// Changes user password.
  ///
  /// Requires current password verification before allowing the change.
  /// New password must meet security requirements.
  ///
  /// Parameters:
  /// - [userId] - User ID
  /// - [currentPassword] - Current password for verification
  /// - [newPassword] - New password (min 8 characters)
  ///
  /// Returns: Success message string
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if current password is incorrect
  /// - [Exception] if new password doesn't meet requirements
  _i3.Future<String> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) => caller.callServerEndpoint<String>(
    'settings',
    'updatePassword',
    {
      'userId': userId,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    },
  );

  /// Updates organization settings (admin only).
  ///
  /// Allows organization admins to update organization name and API keys.
  /// Regular users cannot access this endpoint.
  ///
  /// Parameters:
  /// - [userId] - User ID (must have admin role)
  /// - [name] - Optional new organization name
  /// - [postizApiKey] - Optional Postiz API key
  /// - [geminiApiKey] - Optional Gemini API key
  ///
  /// Returns: Updated Organization object
  ///
  /// Throws:
  /// - [Exception] if user is not admin
  /// - [Exception] if user or organization not found
  /// - [Exception] if no fields provided for update
  _i3.Future<_i13.Organization> updateOrganization({
    required int userId,
    String? name,
    String? postizApiKey,
    String? geminiApiKey,
  }) => caller.callServerEndpoint<_i13.Organization>(
    'settings',
    'updateOrganization',
    {
      'userId': userId,
      'name': name,
      'postizApiKey': postizApiKey,
      'geminiApiKey': geminiApiKey,
    },
  );

  /// Deactivates user account (soft delete).
  ///
  /// Marks the user account as inactive without deleting data.
  /// Requires password confirmation for security.
  ///
  /// Parameters:
  /// - [userId] - User ID to deactivate
  /// - [password] - Password confirmation
  ///
  /// Returns: Success message string
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if password is incorrect
  /// - [Exception] if account is already inactive
  _i3.Future<String> deactivateAccount({
    required int userId,
    required String password,
  }) => caller.callServerEndpoint<String>(
    'settings',
    'deactivateAccount',
    {
      'userId': userId,
      'password': password,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i14.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i14.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i15.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    aILogs = EndpointAILogs(this);
    auth = EndpointAuth(this);
    campaign = EndpointCampaign(this);
    company = EndpointCompany(this);
    connections = EndpointConnections(this);
    post = EndpointPost(this);
    product = EndpointProduct(this);
    settings = EndpointSettings(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAILogs aILogs;

  late final EndpointAuth auth;

  late final EndpointCampaign campaign;

  late final EndpointCompany company;

  late final EndpointConnections connections;

  late final EndpointPost post;

  late final EndpointProduct product;

  late final EndpointSettings settings;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'aILogs': aILogs,
    'auth': auth,
    'campaign': campaign,
    'company': company,
    'connections': connections,
    'post': post,
    'product': product,
    'settings': settings,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
