enum Flavor { prod, dev, uat, qa }

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.qa:
        return 'QA';
      case Flavor.prod:
        return 'prod';
      case Flavor.dev:
        return 'dev';
      case Flavor.uat:
        return 'Uat';
      default:
        return 'title';
    }
  }

  static String get apiUrl {
    switch (appFlavor) {
      case Flavor.qa:
        return '';
      case Flavor.prod:
        return '';
      case Flavor.dev:
        return '';
      case Flavor.uat:
        return '';
      default:
        return '';
    }
  }

  static String get pviInsurancesUrl {
    switch (appFlavor) {
      case Flavor.prod:
        return '';
      case Flavor.qa:
      case Flavor.dev:
        return '';
      case Flavor.uat:
        return '';
      default:
        return '';
    }
  }

  static String get minIO {
    switch (appFlavor) {
      case Flavor.prod:
        return '';
      case Flavor.qa:
      case Flavor.dev:
        return '';
      case Flavor.uat:
        return '';
      default:
        return '';
    }
  }
}
