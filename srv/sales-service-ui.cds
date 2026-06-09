using SalesService from './sales-service';

annotate SalesService.BusinessPartnerSalesOrders with @(
  UI.HeaderInfo : {
    TypeName       : 'Sales Order Item',
    TypeNamePlural : 'Business Partner Sales Orders',
    Title          : { Value : companyName },
    Description    : { Value : salesOrderID }
  },

  UI.SelectionFields : [
    companyName,
    country,
    city,
    currency,
    salesOrderID
  ],

  UI.LineItem : [
    { $Type : 'UI.DataField', Value : companyName,     Label : 'Company Name' },
    { $Type : 'UI.DataField', Value : salesOrderID,    Label : 'Sales Order ID' },
    { $Type : 'UI.DataField', Value : itemPosition,    Label : 'Item Position' },
    { $Type : 'UI.DataField', Value : city,            Label : 'City' },
    { $Type : 'UI.DataField', Value : country,         Label : 'Country' },
    { $Type : 'UI.DataField', Value : convertedAmount, Label : 'Converted Amount' },
    { $Type : 'UI.DataField', Value : currency,        Label : 'Currency' },
    { $Type : 'UI.DataField', Value : salesOrderCount, Label : 'Sales Order Count' }
  ],

  // Two-level tree-style grouping (Company Name -> Sales Order ID) with
  // running subtotals on the converted amount at each group level.
  UI.PresentationVariant : {
    SortOrder : [
      { Property : companyName,  Descending : false },
      { Property : salesOrderID, Descending : false },
      { Property : itemPosition, Descending : false }
    ],
    GroupBy : [ companyName, salesOrderID ],
    Total   : [ convertedAmount ],
    Visualizations : [ '@UI.LineItem' ]
  },

  // Declare analytical capabilities so the List Report can render
  // running subtotals at every group level. Without this, FE only
  // applies a single-level visual grouping with no aggregation.
  Aggregation.ApplySupported : {
    Transformations         : [
      'aggregate', 'groupby', 'filter', 'search',
      'topcount', 'bottomcount', 'identity', 'concat',
      'orderby', 'top', 'skip'
    ],
    Rollup                  : #None,
    PropertyRestrictions    : true,
    GroupableProperties     : [ companyName, salesOrderID, country, city, currency ],
    AggregatableProperties  : [ { Property : convertedAmount }, { Property : salesOrderCount } ]
  }
);

// Field-level labels, semantics, and default aggregation behaviour
annotate SalesService.BusinessPartnerSalesOrders with {
  companyName     @title : 'Company Name';
  salesOrderID    @title : 'Sales Order ID';
  itemPosition    @title : 'Item Position';
  city            @title : 'City';
  country         @title : 'Country';
  convertedAmount @title : 'Converted Amount'
                  @Measures.ISOCurrency : currency
                  @Aggregation.default  : #SUM;
  currency        @title : 'Currency';
  salesOrderCount @title : 'Sales Order Count'
                  @Aggregation.default  : #SUM;
};
