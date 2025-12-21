import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../services/serverpod_client.dart';

/// Provider for managing company profiles.
///
/// Handles CRUD operations for company profiles and manages loading states.
/// Used in company management screens and campaign wizard company selection.
class CompanyProvider with ChangeNotifier {
  // State
  List<CompanyProfile> _companies = [];
  CompanyProfile? _selectedCompany;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CompanyProfile> get companies => List.unmodifiable(_companies);
  CompanyProfile? get selectedCompany => _selectedCompany;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCompanies => _companies.isNotEmpty;
  bool get hasError => _error != null;

  /// Serverpod client instance
  Client get _client => ServerpodClientManager.instance.client;

  /// Mock user ID (TODO: Replace with actual auth)
  final int _userId = 1;

  /// Loads all companies for the current organization
  Future<void> loadCompanies() async {
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

  /// Creates a new company profile
  Future<CompanyProfile?> createCompany({
    required String name,
    String? description,
    String? brandVoice,
    String? targetAudience,
    String? industry,
    List<String>? uploadedFiles,
  }) async {
    _error = null;
    notifyListeners();

    try {
      // Note: targetAudience and industry are not currently supported by the API
      // They will be ignored until the backend is updated
      final company = await _client.company.createCompanyProfile(
        userId: _userId,
        name: name,
        description: description,
        brandVoice: brandVoice,
        uploadedFiles: uploadedFiles,
      );

      // Add to local list
      _companies.add(company);
      _companies.sort((a, b) => a.name.compareTo(b.name));

      notifyListeners();
      return company;
    } catch (e) {
      _error = 'Failed to create company: ${e.toString()}';
      debugPrint('Error creating company: $e');
      notifyListeners();
      return null;
    }
  }

  /// Updates an existing company profile
  Future<CompanyProfile?> updateCompany({
    required int companyId,
    String? name,
    String? description,
    String? brandVoice,
    List<String>? uploadedFiles,
  }) async {
    _error = null;
    notifyListeners();

    try {
      final updatedCompany = await _client.company.updateCompanyProfile(
        userId: _userId,
        companyProfileId: companyId,
        name: name,
        description: description,
        brandVoice: brandVoice,
        uploadedFiles: uploadedFiles,
      );

      // Update in local list
      final index = _companies.indexWhere((c) => c.id == companyId);
      if (index != -1) {
        _companies[index] = updatedCompany;
        _companies.sort((a, b) => a.name.compareTo(b.name));
      }

      notifyListeners();
      return updatedCompany;
    } catch (e) {
      _error = 'Failed to update company: ${e.toString()}';
      debugPrint('Error updating company: $e');
      notifyListeners();
      return null;
    }
  }

  /// Deletes a company profile
  Future<bool> deleteCompany(int companyId) async {
    _error = null;
    notifyListeners();

    try {
      await _client.company.deleteCompanyProfile(
        userId: _userId,
        companyProfileId: companyId,
      );

      // Remove from local list
      _companies.removeWhere((c) => c.id == companyId);

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete company: ${e.toString()}';
      debugPrint('Error deleting company: $e');
      notifyListeners();
      return false;
    }
  }

  /// Gets a company by ID from the local cache
  CompanyProfile? getCompanyById(int companyId) {
    try {
      return _companies.firstWhere((c) => c.id == companyId);
    } catch (e) {
      return null;
    }
  }

  /// Selects a company
  void selectCompany(CompanyProfile? company) {
    _selectedCompany = company;
    notifyListeners();
  }

  /// Adds a new product to a company
  Future<Product> addProduct({
    required int companyId,
    required String name,
    String? description,
    List<String>? keyFeatures,
    String? targetAudience,
    String? category,
  }) async {
    try {
      final product = await _client.product.createProduct(
        userId: _userId,
        companyProfileId: companyId,
        name: name,
        description: description,
        keyFeatures: keyFeatures,
        targetAudience: targetAudience,
        category: category,
      );

      // Reload companies to get updated products list
      await loadCompanies();

      return product;
    } catch (e) {
      _error = 'Failed to add product: ${e.toString()}';
      debugPrint('Error adding product: $e');
      notifyListeners();
      rethrow;
    }
  }

  /// Parses uploaded files JSON string to list
  static List<String> parseUploadedFiles(String uploadedFilesJson) {
    try {
      final decoded = jsonDecode(uploadedFilesJson);
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

  /// Resets the provider to initial state
  void reset() {
    _companies = [];
    _selectedCompany = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
