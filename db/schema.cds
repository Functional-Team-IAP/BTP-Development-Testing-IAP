namespace iap.sales;

using { cuid, managed } from '@sap/cds/common';

/**
 * Flat source table - one row per sales-order item position.
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

/**
 * Hierarchical projection for the Fiori Elements V4 TreeTable.
 *
 *   level 1 : Company         (1 row per Company)
 *   level 2 : Sales Order     (1 row per Company / SalesOrder)
 *   level 3 : Line Item       (1 row per Company / SalesOrder / ItemPosition)
 *
 * Each row carries its own nodeID and points at its parent via parentID.
 * The Parent association makes the parent reference a navigation property,
 * which Aggregation.RecursiveHierarchy requires.
 *
 * Aggregated levels (Company, SalesOrder) carry the rolled-up sum of
 * convertedAmount across their descendants so the TreeTable can show
 * subtotals + grand totals without firing $apply requests.
 */
entity BPSalesTree {
  key nodeID         : String(140);
  parentID           : String(140);
  hierarchyLevel     : Integer;
  drillState         : String(20);  // 'expanded', 'collapsed', 'leaf'
  companyName        : String(80);
  salesOrderID       : String(20);
  itemPosition       : Integer;
  city               : String(80);
  country            : String(3);
  convertedAmount    : Decimal(15, 2) default 0;
  currency           : String(5);
  salesOrderCount    : Integer default 0;
  Parent             : Association to BPSalesTree on Parent.nodeID = parentID;
}
