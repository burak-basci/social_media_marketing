import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/postiz_client.dart';

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
class ConnectionsEndpoint extends Endpoint {
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
  Future<List<SocialMediaConnection>> listConnections(
    Session session, {
    required int userId,
  }) async {
    try {
      session.log('Fetching connections for user $userId');

      // Load user to get organizationId
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      session.log('User organization: ${user.organizationId}');

      // Find all connections for this organization
      final connections = await SocialMediaConnection.db.find(
        session,
        where: (t) => t.organizationId.equals(user.organizationId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );

      session.log('Found ${connections.length} connections');
      return connections;
    } catch (e) {
      session.log('Failed to list connections: $e', level: LogLevel.error);
      rethrow;
    }
  }

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
  Future<List<SocialMediaConnection>> syncFromPostiz(
    Session session, {
    required int userId,
  }) async {
    try {
      session.log('Starting Postiz sync for user $userId');

      // Load user and organization
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      final organization = await Organization.db.findById(
        session,
        user.organizationId,
      );
      if (organization == null) {
        throw Exception('Organization not found');
      }

      // Validate Postiz API key is configured
      if (organization.postizApiKey.isEmpty) {
        throw Exception(
          'Postiz API key not configured. Please configure in organization settings.',
        );
      }

      session.log('Organization: ${organization.name}');
      session.log('Syncing from Postiz API...');

      // Create Postiz client and fetch integrations
      final postizClient = PostizClient(
        apiKey: organization.postizApiKey,
        baseUrl: 'https://api.postiz.com',
        session: session,
      );

      final integrations = await postizClient.getIntegrations();
      session.log('Retrieved ${integrations.length} integrations from Postiz');

      final syncedConnections = <SocialMediaConnection>[];
      final now = DateTime.now();

      for (final integration in integrations) {
        try {
          // Skip disabled integrations
          if (integration.disabled) {
            session.log(
              'Skipping disabled integration: ${integration.name} (${integration.providerIdentifier})',
            );
            continue;
          }

          // Check if connection already exists
          final existingConnection =
              await SocialMediaConnection.db.findFirstRow(
            session,
            where: (t) =>
                t.organizationId.equals(user.organizationId) &
                t.postizIntegrationId.equals(integration.id),
          );

          if (existingConnection != null) {
            // Update existing connection
            session.log(
              'Updating existing connection: ${integration.name}',
            );

            final updated = await SocialMediaConnection.db.updateRow(
              session,
              existingConnection.copyWith(
                platform: integration.providerIdentifier,
                platformUsername: integration.name,
                isActive: true,
                lastUsed: now,
              ),
            );

            syncedConnections.add(updated);
          } else {
            // Create new connection
            session.log(
              'Creating new connection: ${integration.name} (${integration.providerIdentifier})',
            );

            final newConnection = await SocialMediaConnection.db.insertRow(
              session,
              SocialMediaConnection(
                organizationId: user.organizationId,
                platform: integration.providerIdentifier,
                platformUserId: integration.id, // Using ID as platformUserId
                platformUsername: integration.name,
                postizIntegrationId: integration.id,
                isActive: true,
                createdAt: now,
                lastUsed: now,
              ),
            );

            syncedConnections.add(newConnection);
          }
        } catch (e) {
          session.log(
            'Failed to sync integration ${integration.name}: $e',
            level: LogLevel.warning,
          );
          // Continue with other integrations
        }
      }

      session.log('Successfully synced ${syncedConnections.length} connections');
      return syncedConnections;
    } catch (e, stackTrace) {
      session.log('Postiz sync failed: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

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
  Future<void> disconnectPlatform(
    Session session, {
    required int userId,
    required int connectionId,
  }) async {
    try {
      session.log('Disconnecting connection $connectionId for user $userId');

      // Load user to validate organization access
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Load connection and validate ownership
      final connection = await SocialMediaConnection.db.findById(
        session,
        connectionId,
      );

      if (connection == null) {
        throw Exception('Connection not found');
      }

      // Validate user has access (via organization)
      if (connection.organizationId != user.organizationId) {
        throw Exception(
          'Access denied: Connection does not belong to your organization',
        );
      }

      session.log(
        'Removing connection: ${connection.platform} (@${connection.platformUsername})',
      );

      // Delete the connection
      await SocialMediaConnection.db.deleteRow(session, connection);

      session.log('Connection disconnected successfully');
    } catch (e) {
      session.log('Failed to disconnect platform: $e', level: LogLevel.error);
      rethrow;
    }
  }

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
  Future<Map<String, bool>> getConnectionStatus(
    Session session, {
    required int userId,
  }) async {
    try {
      session.log('Checking connection status for user $userId');

      // Load user
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Get all active connections for organization
      final connections = await SocialMediaConnection.db.find(
        session,
        where: (t) =>
            t.organizationId.equals(user.organizationId) &
            t.isActive.equals(true),
      );

      // Build platform status map
      final platforms = ['x', 'linkedin', 'instagram', 'facebook', 'pinterest'];
      final status = <String, bool>{};

      for (final platform in platforms) {
        status[platform] = connections.any(
          (conn) => conn.platform.toLowerCase() == platform.toLowerCase(),
        );
      }

      session.log(
        'Connection status: ${status.entries.where((e) => e.value).map((e) => e.key).join(', ')}',
      );

      return status;
    } catch (e) {
      session.log(
        'Failed to get connection status: $e',
        level: LogLevel.error,
      );
      rethrow;
    }
  }
}
