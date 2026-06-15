import '../../../../core/config/fixture_access_profile.dart';
import '../../domain/entities/operational_context.dart';

OperationalContext buildOperationalContextFixture() {
  return OperationalContext(
    userName: appFixtureAccessProfile.userName,
    userEmail: appFixtureAccessProfile.userEmail,
    tenantName: appFixtureAccessProfile.tenantName,
    tenantSlug: appFixtureAccessProfile.tenantSlug,
    features: appFixtureAccessProfile.features,
    permissions: appFixtureAccessProfile.permissions,
  );
}
