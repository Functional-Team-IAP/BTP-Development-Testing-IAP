using { iap.sales as my } from '../db/schema';

@path: '/sales'
@requires: 'BPSalesViewer'
service SalesService {

  @readonly
  entity BusinessPartnerSalesOrders as projection on my.BusinessPartnerSalesOrders;

}
