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

  // Two-level grouping (Company Name -> Sales Order ID) with running
  // subtotals on the converted amount. In a real BTP Fiori Launchpad
  // shell, sap.fe.templates renders the AnalyticalTable with auto
  // expand / collapse + per-group subtotals + a grand total row,
  // driven by OData V4 $apply requests against the CAP service.
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

  // Declares analytical capability of the service. CAP already answers
  // $apply=groupby(...)aggregate(...) correctly; this annotation tells
  // the Fiori Elements client that it is safe to fire those requests.
  Aggregation.ApplySupported : {
    Transformations        : [
      'aggregate', 'groupby', 'filter', 'search',
      'topcount', 'bottomcount', 'identity', 'concat',
      'orderby', 'top', 'skip'
    ],
    Rollup                 : #None,
    PropertyRestrictions   : true,
    GroupableProperties    : [ companyName, salesOrderID, country, city, currency ],
    AggregatableProperties : [
      { Property : convertedAmount },
      { Property : salesOrderCount }
    ]
  }
);

annotate SalesService.BusinessPartnerSalesOrders with {
  companyName     @title : 'Company Name';
  salesOrderID    @title : 'Sales Order ID';
  itemPosition    @title : 'Item Position';
  city            @title : 'City';
  country         @title : 'Country';
  convertedAmount @title : 'Converted Amount'
                  @Measures.ISOCurrency : currency;
  currency        @title : 'Currency';
  salesOrderCount @title : 'Sales Order Count';
};
