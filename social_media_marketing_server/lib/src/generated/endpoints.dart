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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/ai_logs_endpoint.dart' as _i4;
import '../endpoints/auth_endpoint.dart' as _i5;
import '../endpoints/campaign_endpoint.dart' as _i6;
import '../endpoints/company_endpoint.dart' as _i7;
import '../endpoints/connections_endpoint.dart' as _i8;
import '../endpoints/post_endpoint.dart' as _i9;
import '../endpoints/product_endpoint.dart' as _i10;
import '../endpoints/settings_endpoint.dart' as _i11;
import '../greetings/greeting_endpoint.dart' as _i12;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i13;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i14;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'aILogs': _i4.AILogsEndpoint()
        ..initialize(
          server,
          'aILogs',
          null,
        ),
      'auth': _i5.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'campaign': _i6.CampaignEndpoint()
        ..initialize(
          server,
          'campaign',
          null,
        ),
      'company': _i7.CompanyEndpoint()
        ..initialize(
          server,
          'company',
          null,
        ),
      'connections': _i8.ConnectionsEndpoint()
        ..initialize(
          server,
          'connections',
          null,
        ),
      'post': _i9.PostEndpoint()
        ..initialize(
          server,
          'post',
          null,
        ),
      'product': _i10.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'settings': _i11.SettingsEndpoint()
        ..initialize(
          server,
          'settings',
          null,
        ),
      'greeting': _i12.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['aILogs'] = _i1.EndpointConnector(
      name: 'aILogs',
      endpoint: endpoints['aILogs']!,
      methodConnectors: {
        'getLogs': _i1.MethodConnector(
          name: 'getLogs',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'interactionType': _i1.ParameterDescription(
              name: 'interactionType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['aILogs'] as _i4.AILogsEndpoint).getLogs(
                session,
                userId: params['userId'],
                limit: params['limit'],
                offset: params['offset'],
                interactionType: params['interactionType'],
                startDate: params['startDate'],
                endDate: params['endDate'],
                postId: params['postId'],
              ),
        ),
        'getTotalCost': _i1.MethodConnector(
          name: 'getTotalCost',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aILogs'] as _i4.AILogsEndpoint).getTotalCost(
                    session,
                    userId: params['userId'],
                    startDate: params['startDate'],
                    endDate: params['endDate'],
                    postId: params['postId'],
                  ),
        ),
        'getLog': _i1.MethodConnector(
          name: 'getLog',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'logId': _i1.ParameterDescription(
              name: 'logId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['aILogs'] as _i4.AILogsEndpoint).getLog(
                session,
                userId: params['userId'],
                logId: params['logId'],
              ),
        ),
        'getStatistics': _i1.MethodConnector(
          name: 'getStatistics',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aILogs'] as _i4.AILogsEndpoint).getStatistics(
                    session,
                    userId: params['userId'],
                    startDate: params['startDate'],
                    endDate: params['endDate'],
                  ),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'register': _i1.MethodConnector(
          name: 'register',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'organizationName': _i1.ParameterDescription(
              name: 'organizationName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i5.AuthEndpoint).register(
                session,
                email: params['email'],
                password: params['password'],
                fullName: params['fullName'],
                organizationName: params['organizationName'],
              ),
        ),
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i5.AuthEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'logout': _i1.MethodConnector(
          name: 'logout',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i5.AuthEndpoint).logout(session),
        ),
        'getCurrentUser': _i1.MethodConnector(
          name: 'getCurrentUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i5.AuthEndpoint).getCurrentUser(
                session,
                userId: params['userId'],
              ),
        ),
        'changePassword': _i1.MethodConnector(
          name: 'changePassword',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'currentPassword': _i1.ParameterDescription(
              name: 'currentPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i5.AuthEndpoint).changePassword(
                session,
                userId: params['userId'],
                currentPassword: params['currentPassword'],
                newPassword: params['newPassword'],
              ),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i5.AuthEndpoint).updateProfile(
                session,
                userId: params['userId'],
                fullName: params['fullName'],
                email: params['email'],
              ),
        ),
      },
    );
    connectors['campaign'] = _i1.EndpointConnector(
      name: 'campaign',
      endpoint: endpoints['campaign']!,
      methodConnectors: {
        'generateCampaign': _i1.MethodConnector(
          name: 'generateCampaign',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'companyProfileId': _i1.ParameterDescription(
              name: 'companyProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'userPrompt': _i1.ParameterDescription(
              name: 'userPrompt',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'selectedPlatforms': _i1.ParameterDescription(
              name: 'selectedPlatforms',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
            'generateImage': _i1.ParameterDescription(
              name: 'generateImage',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['campaign'] as _i6.CampaignEndpoint)
                  .generateCampaign(
                    session,
                    userId: params['userId'],
                    companyProfileId: params['companyProfileId'],
                    productId: params['productId'],
                    userPrompt: params['userPrompt'],
                    selectedPlatforms: params['selectedPlatforms'],
                    generateImage: params['generateImage'],
                    title: params['title'],
                  ),
        ),
        'regeneratePlatform': _i1.MethodConnector(
          name: 'regeneratePlatform',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'platform': _i1.ParameterDescription(
              name: 'platform',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPrompt': _i1.ParameterDescription(
              name: 'newPrompt',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['campaign'] as _i6.CampaignEndpoint)
                  .regeneratePlatform(
                    session,
                    userId: params['userId'],
                    postId: params['postId'],
                    platform: params['platform'],
                    newPrompt: params['newPrompt'],
                  ),
        ),
        'editPlatformContent': _i1.MethodConnector(
          name: 'editPlatformContent',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'platform': _i1.ParameterDescription(
              name: 'platform',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'editRequest': _i1.ParameterDescription(
              name: 'editRequest',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['campaign'] as _i6.CampaignEndpoint)
                  .editPlatformContent(
                    session,
                    userId: params['userId'],
                    postId: params['postId'],
                    platform: params['platform'],
                    editRequest: params['editRequest'],
                  ),
        ),
      },
    );
    connectors['company'] = _i1.EndpointConnector(
      name: 'company',
      endpoint: endpoints['company']!,
      methodConnectors: {
        'listCompanyProfiles': _i1.MethodConnector(
          name: 'listCompanyProfiles',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['company'] as _i7.CompanyEndpoint)
                  .listCompanyProfiles(
                    session,
                    userId: params['userId'],
                  ),
        ),
        'getCompanyProfile': _i1.MethodConnector(
          name: 'getCompanyProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'companyProfileId': _i1.ParameterDescription(
              name: 'companyProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['company'] as _i7.CompanyEndpoint)
                  .getCompanyProfile(
                    session,
                    userId: params['userId'],
                    companyProfileId: params['companyProfileId'],
                  ),
        ),
        'createCompanyProfile': _i1.MethodConnector(
          name: 'createCompanyProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'brandVoice': _i1.ParameterDescription(
              name: 'brandVoice',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'uploadedFiles': _i1.ParameterDescription(
              name: 'uploadedFiles',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['company'] as _i7.CompanyEndpoint)
                  .createCompanyProfile(
                    session,
                    userId: params['userId'],
                    name: params['name'],
                    description: params['description'],
                    brandVoice: params['brandVoice'],
                    uploadedFiles: params['uploadedFiles'],
                  ),
        ),
        'updateCompanyProfile': _i1.MethodConnector(
          name: 'updateCompanyProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'companyProfileId': _i1.ParameterDescription(
              name: 'companyProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'brandVoice': _i1.ParameterDescription(
              name: 'brandVoice',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'uploadedFiles': _i1.ParameterDescription(
              name: 'uploadedFiles',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['company'] as _i7.CompanyEndpoint)
                  .updateCompanyProfile(
                    session,
                    userId: params['userId'],
                    companyProfileId: params['companyProfileId'],
                    name: params['name'],
                    description: params['description'],
                    brandVoice: params['brandVoice'],
                    uploadedFiles: params['uploadedFiles'],
                  ),
        ),
        'deleteCompanyProfile': _i1.MethodConnector(
          name: 'deleteCompanyProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'companyProfileId': _i1.ParameterDescription(
              name: 'companyProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['company'] as _i7.CompanyEndpoint)
                  .deleteCompanyProfile(
                    session,
                    userId: params['userId'],
                    companyProfileId: params['companyProfileId'],
                  ),
        ),
        'getCompanyProducts': _i1.MethodConnector(
          name: 'getCompanyProducts',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'companyProfileId': _i1.ParameterDescription(
              name: 'companyProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['company'] as _i7.CompanyEndpoint)
                  .getCompanyProducts(
                    session,
                    userId: params['userId'],
                    companyProfileId: params['companyProfileId'],
                  ),
        ),
      },
    );
    connectors['connections'] = _i1.EndpointConnector(
      name: 'connections',
      endpoint: endpoints['connections']!,
      methodConnectors: {
        'listConnections': _i1.MethodConnector(
          name: 'listConnections',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['connections'] as _i8.ConnectionsEndpoint)
                  .listConnections(
                    session,
                    userId: params['userId'],
                  ),
        ),
        'syncFromPostiz': _i1.MethodConnector(
          name: 'syncFromPostiz',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['connections'] as _i8.ConnectionsEndpoint)
                  .syncFromPostiz(
                    session,
                    userId: params['userId'],
                  ),
        ),
        'disconnectPlatform': _i1.MethodConnector(
          name: 'disconnectPlatform',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'connectionId': _i1.ParameterDescription(
              name: 'connectionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['connections'] as _i8.ConnectionsEndpoint)
                  .disconnectPlatform(
                    session,
                    userId: params['userId'],
                    connectionId: params['connectionId'],
                  ),
        ),
        'getConnectionStatus': _i1.MethodConnector(
          name: 'getConnectionStatus',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['connections'] as _i8.ConnectionsEndpoint)
                  .getConnectionStatus(
                    session,
                    userId: params['userId'],
                  ),
        ),
      },
    );
    connectors['post'] = _i1.EndpointConnector(
      name: 'post',
      endpoint: endpoints['post']!,
      methodConnectors: {
        'listPosts': _i1.MethodConnector(
          name: 'listPosts',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'statusFilter': _i1.ParameterDescription(
              name: 'statusFilter',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'platformFilter': _i1.ParameterDescription(
              name: 'platformFilter',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'searchQuery': _i1.ParameterDescription(
              name: 'searchQuery',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['post'] as _i9.PostEndpoint).listPosts(
                session,
                userId: params['userId'],
                statusFilter: params['statusFilter'],
                platformFilter: params['platformFilter'],
                startDate: params['startDate'],
                endDate: params['endDate'],
                searchQuery: params['searchQuery'],
                limit: params['limit'],
                offset: params['offset'],
              ),
        ),
        'getPost': _i1.MethodConnector(
          name: 'getPost',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['post'] as _i9.PostEndpoint).getPost(
                session,
                userId: params['userId'],
                postId: params['postId'],
              ),
        ),
        'updatePost': _i1.MethodConnector(
          name: 'updatePost',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'scheduleTime': _i1.ParameterDescription(
              name: 'scheduleTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'editedContent': _i1.ParameterDescription(
              name: 'editedContent',
              type: _i1.getType<Map<String, String>?>(),
              nullable: true,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['post'] as _i9.PostEndpoint).updatePost(
                session,
                userId: params['userId'],
                postId: params['postId'],
                status: params['status'],
                scheduleTime: params['scheduleTime'],
                editedContent: params['editedContent'],
                title: params['title'],
              ),
        ),
        'deletePost': _i1.MethodConnector(
          name: 'deletePost',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['post'] as _i9.PostEndpoint).deletePost(
                session,
                userId: params['userId'],
                postId: params['postId'],
              ),
        ),
        'duplicatePost': _i1.MethodConnector(
          name: 'duplicatePost',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['post'] as _i9.PostEndpoint).duplicatePost(
                session,
                userId: params['userId'],
                postId: params['postId'],
              ),
        ),
        'publishNow': _i1.MethodConnector(
          name: 'publishNow',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'postId': _i1.ParameterDescription(
              name: 'postId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['post'] as _i9.PostEndpoint).publishNow(
                session,
                userId: params['userId'],
                postId: params['postId'],
              ),
        ),
      },
    );
    connectors['product'] = _i1.EndpointConnector(
      name: 'product',
      endpoint: endpoints['product']!,
      methodConnectors: {
        'listProducts': _i1.MethodConnector(
          name: 'listProducts',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'companyProfileId': _i1.ParameterDescription(
              name: 'companyProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i10.ProductEndpoint).listProducts(
                    session,
                    userId: params['userId'],
                    companyProfileId: params['companyProfileId'],
                  ),
        ),
        'getProduct': _i1.MethodConnector(
          name: 'getProduct',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i10.ProductEndpoint).getProduct(
                    session,
                    userId: params['userId'],
                    productId: params['productId'],
                  ),
        ),
        'createProduct': _i1.MethodConnector(
          name: 'createProduct',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'companyProfileId': _i1.ParameterDescription(
              name: 'companyProfileId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'targetAudience': _i1.ParameterDescription(
              name: 'targetAudience',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'keyFeatures': _i1.ParameterDescription(
              name: 'keyFeatures',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i10.ProductEndpoint).createProduct(
                    session,
                    userId: params['userId'],
                    companyProfileId: params['companyProfileId'],
                    name: params['name'],
                    description: params['description'],
                    targetAudience: params['targetAudience'],
                    keyFeatures: params['keyFeatures'],
                    category: params['category'],
                  ),
        ),
        'updateProduct': _i1.MethodConnector(
          name: 'updateProduct',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'targetAudience': _i1.ParameterDescription(
              name: 'targetAudience',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'keyFeatures': _i1.ParameterDescription(
              name: 'keyFeatures',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i10.ProductEndpoint).updateProduct(
                    session,
                    userId: params['userId'],
                    productId: params['productId'],
                    name: params['name'],
                    description: params['description'],
                    targetAudience: params['targetAudience'],
                    keyFeatures: params['keyFeatures'],
                    category: params['category'],
                  ),
        ),
        'deleteProduct': _i1.MethodConnector(
          name: 'deleteProduct',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i10.ProductEndpoint).deleteProduct(
                    session,
                    userId: params['userId'],
                    productId: params['productId'],
                  ),
        ),
        'getProductPosts': _i1.MethodConnector(
          name: 'getProductPosts',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i10.ProductEndpoint)
                  .getProductPosts(
                    session,
                    userId: params['userId'],
                    productId: params['productId'],
                  ),
        ),
      },
    );
    connectors['settings'] = _i1.EndpointConnector(
      name: 'settings',
      endpoint: endpoints['settings']!,
      methodConnectors: {
        'getUserSettings': _i1.MethodConnector(
          name: 'getUserSettings',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['settings'] as _i11.SettingsEndpoint)
                  .getUserSettings(
                    session,
                    userId: params['userId'],
                  ),
        ),
        'updateUserProfile': _i1.MethodConnector(
          name: 'updateUserProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['settings'] as _i11.SettingsEndpoint)
                  .updateUserProfile(
                    session,
                    userId: params['userId'],
                    fullName: params['fullName'],
                    email: params['email'],
                  ),
        ),
        'updatePassword': _i1.MethodConnector(
          name: 'updatePassword',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'currentPassword': _i1.ParameterDescription(
              name: 'currentPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['settings'] as _i11.SettingsEndpoint)
                  .updatePassword(
                    session,
                    userId: params['userId'],
                    currentPassword: params['currentPassword'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'updateOrganization': _i1.MethodConnector(
          name: 'updateOrganization',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'postizApiKey': _i1.ParameterDescription(
              name: 'postizApiKey',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'geminiApiKey': _i1.ParameterDescription(
              name: 'geminiApiKey',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['settings'] as _i11.SettingsEndpoint)
                  .updateOrganization(
                    session,
                    userId: params['userId'],
                    name: params['name'],
                    postizApiKey: params['postizApiKey'],
                    geminiApiKey: params['geminiApiKey'],
                  ),
        ),
        'deactivateAccount': _i1.MethodConnector(
          name: 'deactivateAccount',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['settings'] as _i11.SettingsEndpoint)
                  .deactivateAccount(
                    session,
                    userId: params['userId'],
                    password: params['password'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i12.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i13.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i14.Endpoints()
      ..initializeEndpoints(server);
  }
}
