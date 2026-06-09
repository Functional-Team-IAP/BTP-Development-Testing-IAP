namespace iap.sales;

using { cuid, managed, Currency } from '@sap/cds/common';

/**
 * One row per sales-order item position (or one row per business partner
 * when the partner has no orders yet — those rows have empty
 * salesOrderID / itemPosition and a converted amount of 0).
 */
entity BusinessPartnerSalesOrders : cuid, managed {
  companyName      : String(80) not null;
  salesOrderID     : String(20);
  itemPosition     : Integer;
  city             : String(80);
  country          : String(3);
  convertedAmount  : Decimal(15, 2) default 0;
  currency         : String(5);
  salesOrderCount  : Integer default 0;
}
