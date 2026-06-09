using SalesService from './sales-service';

annotate SalesService.BusinessPartnerSalesOrders with @(

  // ---------- header ----------
  UI.HeaderInfo : {
    TypeName       : 'Sales Order Item',
    TypeNamePlural : 'Business Partner Sales Orders',
    Title          : { Value : companyName },
    Description    : { Value : salesOrderID }
  },

  // ---------- filter bar ----------
  UI.SelectionFields : [
    companyName,
    country,
    city,
    currency,
    salesOrderID
  ],

  // ---------- columns (line item) ----------
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

  // ---------- aggregation contract ----------
  Aggregation.ApplySupported : {
    Transformations         : [
      'aggregate', 'groupby', 'filter', 'search',
      'topcount', 'bottomcount', 'identity', 'concat',
      'orderby', 'top', 'skip'
    ],
    Rollup                  : #None,
    PropertyRestrictions    : true,
    GroupableProperties     : [ companyName, salesOrderID, country, city, currency ],
    AggregatableProperties  : [
      { Property : convertedAmount },
      { Property : salesOrderCount }
    ]
  },

  // ---------- chart (required by ALP template) ----------
  UI.Chart : {
    Title          : 'Sales by Company / Order',
    ChartType      : #Column,
    Dimensions     : [ companyName, salesOrderID ],
    DynamicMeasures : [ '@Analytics.AggregatedProperty#totalConvertedAmount' ],
    DimensionAttributes : [
      { Dimension : companyName,  Role : #Category },
      { Dimension : salesOrderID, Role : #Series   }
    ],
    MeasureAttributes : [{
      DynamicMeasure : '@Analytics.AggregatedProperty#totalConvertedAmount',
      Role           : #Axis1
    }]
  },

  // ---------- presentation: two-level group, totals ----------
  UI.PresentationVariant : {
    SortOrder : [
      { Property : companyName,  Descending : false },
      { Property : salesOrderID, Descending : false },
      { Property : itemPosition, Descending : false }
    ],
    GroupBy : [ companyName, salesOrderID ],
    Total   : [ convertedAmount ],
    Visualizations : [
      '@UI.Chart',
      '@UI.LineItem'
    ]
  },

  // ---------- selection x presentation: default landing variant ----------
  UI.SelectionPresentationVariant #default : {
    Text                : 'Default',
    SelectionVariant    : { SelectOptions : [] },
    PresentationVariant : ![@UI.PresentationVariant]
  }
);

// ---------- analytical measure (named, referenced by chart) ----------
annotate SalesService.BusinessPartnerSalesOrders with @(
  Analytics.AggregatedProperty #totalConvertedAmount : {
    Name                  : 'totalConvertedAmount',
    AggregationMethod     : 'sum',
    AggregatableProperty  : convertedAmount,
    ![@Common.Label]      : 'Total Converted Amount'
  }
);

// ---------- field labels, semantic hints, default aggregation ----------
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
