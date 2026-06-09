# Business Partner Sales Orders — Fiori Elements List Report on SAP BTP

A SAP Cloud Application Programming Model (CAP, Node.js) service that exposes
Business Partner sales orders as OData V4, paired with a SAPUI5 Fiori Elements
**List Report** that uses the annotation-driven **grouping** feature described
in the SAP community blog [*Fiori Elements List Report — sorting, grouping and
table types*](https://community.sap.com/t5/technology-blog-posts-by-sap/fiori-elements-list-report-sorting-grouping-and-table-types/ba-p/13350422/page/2).

## What it does

- Loads the sample dataset from the provided Excel workbook (55 rows) as a CSV
  seed file in `db/data/`.
- Exposes a `SalesService.BusinessPartnerSalesOrders` OData V4 entity set.
- Renders a List Report with:
  - **Initial grouping** by `companyName` and `country` via
    `UI.PresentationVariant.GroupBy`.
  - **Default sort** by company ascending then converted amount descending via
    `UI.PresentationVariant.SortOrder`.
  - User-controlled re-grouping, sorting, filtering, and column selection
    enabled through `tableSettings.personalization` in `manifest.json`.
  - Filter bar exposing Company, Country, City, Currency, and Sales Order ID.
  - Currency-aware amount column via `@Measures.ISOCurrency`.

## Project layout

```
.
├── app/businesspartnersalesorders/   # Fiori Elements List Report
│   ├── annotations.cds               # UI annotations (LineItem, PresentationVariant.GroupBy, ...)
│   ├── webapp/                       # UI5 boot files (manifest, Component.js, index.html, i18n)
│   ├── ui5.yaml                      # local dev server config
│   ├── xs-app.json                   # app-level router rules (used by html5-apps-repo)
│   └── package.json
├── approuter/                        # Managed approuter for CF
├── db/
│   ├── schema.cds                    # BusinessPartnerSalesOrders entity
│   └── data/iap.sales-BusinessPartnerSalesOrders.csv
├── srv/sales-service.cds             # OData V4 service definition
├── mta.yaml                          # Cloud Foundry multi-target build
├── xs-security.json                  # XSUAA scopes / role templates
└── package.json                      # CAP root (Node.js)
```

## Local development

```bash
npm install
cd app/businesspartnersalesorders && npm install && cd ../..
npm start                                       # CAP service on http://localhost:4004
# in a second shell:
cd app/businesspartnersalesorders && npm start  # Fiori app via @sap/ux-ui5-tooling
```

Open the URL printed by `fiori run`. The List Report opens already grouped
by Company Name and Country; users can change grouping via the table's
*Settings → Group* dialog.

A mocked user `alice` with role `BPSalesViewer` is pre-configured in
`package.json`, so authentication does not block local testing.

## Deploy to SAP BTP Cloud Foundry

Prerequisites: Cloud MTA Build Tool (`mbt`), `cf` CLI with the
multiapps plug-in, and a CF space with entitlements for **HANA Cloud**,
**XSUAA**, **HTML5 Application Repository**, and **Destination Service**.

```bash
npm run build           # produces mta_archives/archive.mtar
cf deploy mta_archives/archive.mtar
```

After deploy, assign the `BPSalesViewerRC` role collection to your user in
the BTP Cockpit and launch the app from the *HTML5 Applications* section.

## Where the grouping behavior lives

| File | Annotation / setting | Effect |
| --- | --- | --- |
| `app/businesspartnersalesorders/annotations.cds` | `UI.PresentationVariant.GroupBy: [companyName, country]` | Initial group rows |
| `app/businesspartnersalesorders/annotations.cds` | `UI.PresentationVariant.SortOrder` | Default sort within groups |
| `app/businesspartnersalesorders/webapp/manifest.json` | `tableSettings.personalization.group: true` | Users can change grouping at runtime |
| `app/businesspartnersalesorders/webapp/manifest.json` | `tableSettings.type: "ResponsiveTable"` | Table type that renders group headers |
