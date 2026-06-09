using { iap.sales as my } from '../db/schema';

@path: '/sales'
@requires: 'BPSalesViewer'
service SalesService {

  @readonly
  entity BusinessPartnerSalesOrders as projection on my.BusinessPartnerSalesOrders;

  // Recursive hierarchy view consumed by the Fiori Elements TreeTable.
  @readonly
  entity BPSalesTree as projection on my.BPSalesTree;

}
