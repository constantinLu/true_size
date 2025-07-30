import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../../app/app.locator.dart';
import '../../../core/models/brand.dart';

class BrandViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final Brand? selectedBrand;
  final String? selectedCustomBrand;
  final Function(Brand?) onBrandSelected;
  final Function(String?) onCustomBrandSelected;

  String _selectedIcon = 'fitness_center';
  String get selectedIcon => _selectedIcon;

  List<Brand> _availableBrands = [];
  List<Brand> get availableBrands => _availableBrands;

  BrandViewModel({
    required this.selectedBrand,
    required this.selectedCustomBrand,
    required this.onBrandSelected,
    required this.onCustomBrandSelected,
  });

  Future<void> initialize() async {
    setBusy(true);
    try {
      await _loadBrands();
    } catch (e) {
      // Handle error
    } finally {
      setBusy(false);
    }
  }

  Future<void> _loadBrands() async {
    _availableBrands = [
      Brand(
          id: const Uuid().v4(),
          name: 'Nike',
          logo: "palette",
          createdAt: DateTime.now()),
      Brand(
          id: const Uuid().v4(),
          name: 'Adidas',
          logo: "work",
          createdAt: DateTime.now()),
      Brand(
          id: const Uuid().v4(),
          name: 'Under Armour',
          logo: "train",
          createdAt: DateTime.now()),
      Brand(
          id: const Uuid().v4(),
          name: 'Reebok',
          logo: "monitor_heart",
          createdAt: DateTime.now()),
      Brand(
          id: const Uuid().v4(),
          name: 'Puma',
          logo: "lightbulb",
          createdAt: DateTime.now()),
    ];
    notifyListeners();
  }

  void selectBrand(Brand? brand) {
    onBrandSelected(brand);
    _navigationService.back();
  }

  void createCustomBrand(String brandName) {
    if (brandName.trim().isNotEmpty) {
      onCustomBrandSelected(brandName.trim());
      _navigationService.back();
    }
  }

  void updateSelectedIcon(String iconName) {
    _selectedIcon = iconName;
    notifyListeners();
  }

  bool isBrandSelected(Brand brand) {
    return selectedBrand?.id == brand.id;
  }

  void navigateBack() {
    _navigationService.back();
  }
}
