import '../../domain/entities/client_summary.dart';

List<ClientSummary> buildClientsFixture() {
  return const [
    ClientSummary(
      id: 'client-1',
      name: 'Loja Horizonte',
      code: 'CL-204',
      city: 'Campinas',
    ),
    ClientSummary(
      id: 'client-2',
      name: 'Moto Peças Aurora',
      code: 'CL-311',
      city: 'Jundiaí',
    ),
    ClientSummary(
      id: 'client-3',
      name: 'Ponto Rota Sul',
      code: 'CL-118',
      city: 'Sorocaba',
    ),
  ];
}
