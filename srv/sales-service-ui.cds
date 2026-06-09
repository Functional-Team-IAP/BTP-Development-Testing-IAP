using SalesService from './sales-service';

annotate SalesService.BPSalesTree with @(

  // Declare the recursive hierarchy. NodeProperty is the unique id of
  // each row, ParentNavigationProperty is the self-association that
  // points each row at its parent. FE V4 TreeTable looks this up via
  // the qualifier set in the manifest (tableSettings.hierarchyQualifier
  // = "salesHier").
  Aggregation.RecursiveHierarchy #salesHier : {
    NodeProperty             : nodeID,
    ParentNavigationProperty : Parent
  },

  // ---------- Header / filter / columns ----------
  UI.HeaderInfo : {
    TypeName       : 'Sales Hierarchy Node',
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

  UI.PresentationVariant : {
    Visualizations : [ '@UI.LineItem' ]
  }
);

annotate SalesService.BPSalesTree with {
  nodeID          @title : 'Node ID';
  parentID        @title : 'Parent ID';
  hierarchyLevel  @title : 'Level';
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
